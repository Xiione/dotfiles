local M = {}
local uv = vim.uv

M.root = vim.fs.normalize(vim.fn.stdpath("data") .. "/scratch")

local function read_file(path)
	local file, err = io.open(path, "rb")
	if not file then
		error(err)
	end
	local content = assert(file:read("*a"))
	file:close()
	return content
end

local function write_file(path, content)
	local temp_path = path .. ".codex.tmp"
	local lines = vim.split(content, "\n", { plain = true })
	if vim.fn.writefile(lines, temp_path, "b") ~= 0 then
		error("Failed to write temporary scratch file")
	end

	local renamed, err = uv.fs_rename(temp_path, path)
	if not renamed then
		uv.fs_unlink(temp_path)
		error(err)
	end
end

local function buffer_content(buf)
	local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
	return vim.bo[buf].endofline and (content .. "\n") or content
end

local function write_buffer(buf, content)
	local has_eol = content:sub(-1) == "\n"
	local lines = vim.split(content, "\n", { plain = true })
	if has_eol then
		table.remove(lines)
	end
	if #lines == 0 then
		lines = { "" }
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].endofline = has_eol
	vim.bo[buf].fixendofline = has_eol
	vim.api.nvim_buf_call(buf, function()
		vim.cmd("silent noautocmd write")
	end)
end

function M.context(cwd)
	cwd = vim.fs.normalize(cwd or assert(uv.cwd()))
	local result = vim.system({ "git", "-C", cwd, "branch", "--show-current" }, { text = true }):wait()
	local branch = vim.trim(result.stdout or "")

	return {
		cwd = cwd,
		branch = result.code == 0 and branch ~= "" and branch or nil,
	}
end

function M.notify_changed()
	vim.api.nvim_exec_autocmds("User", {
		pattern = "SnacksScratchChanged",
		modeline = false,
	})

	if not (_G.Snacks and Snacks.picker) then
		return
	end
	for _, picker in ipairs(Snacks.picker.get()) do
		if not picker.closed and picker.opts.source == "scratch" then
			picker:refresh()
		end
	end
end

local function validate_request(request)
	if type(request) ~= "table" then
		error("Scratch request must be a JSON object")
	end
	if not vim.list_contains({ "list", "read", "write" }, request.op) then
		error("Scratch request has an invalid operation")
	end

	request.cwd = vim.fs.normalize(request.cwd or assert(uv.cwd()))
	if not vim.startswith(request.cwd, "/") or vim.fn.isdirectory(request.cwd) == 0 then
		error("Scratch request cwd must be an existing absolute directory")
	end
	if request.op == "list" then
		return request
	end

	request.name = type(request.name) == "string" and vim.trim(request.name) or ""
	if request.name == "" or request.name:find("[%c]") then
		error("Scratch name must be non-empty and contain no control characters")
	end
	request.ft = request.ft or "markdown"
	if type(request.ft) ~= "string" or not request.ft:match("^[%w_.+-]+$") then
		error("Scratch filetype contains invalid characters")
	end
	request.count = tonumber(request.count or 1)
	if not request.count or request.count < 1 or request.count % 1 ~= 0 then
		error("Scratch count must be a positive integer")
	end
	if request.op == "write" and type(request.content) ~= "string" then
		error("Scratch write request requires string content")
	end
	if request.force ~= nil and type(request.force) ~= "boolean" then
		error("Scratch force option must be a boolean")
	end
	return request
end

local function matches_identity(saved, request, context)
	return saved.cwd == context.cwd
		and saved.branch == context.branch
		and saved.name == request.name
		and saved.ft == request.ft
		and saved.count == request.count
end

local function find_scratch(request, context)
	local matches = {}
	for _, saved in ipairs(Snacks.scratch.list()) do
		if matches_identity(saved, request, context) then
			matches[#matches + 1] = saved
		end
	end
	if #matches > 1 then
		error(("Multiple scratches match %q (%s, count %d)"):format(request.name, request.ft, request.count))
	end
	return matches[1]
end

local function scratch_buf(path)
	local buf = vim.fn.bufnr(path)
	return buf ~= -1 and vim.api.nvim_buf_is_loaded(buf) and buf or nil
end

local function list_scratches(request)
	local context = M.context(request.cwd)
	local items = {}
	for _, saved in ipairs(Snacks.scratch.list()) do
		if saved.cwd == context.cwd and saved.branch == context.branch then
			local buf = scratch_buf(saved.file)
			items[#items + 1] = {
				name = saved.name,
				ft = saved.ft,
				count = saved.count,
				cwd = saved.cwd,
				branch = saved.branch,
				file = saved.file,
				modified = buf and vim.bo[buf].modified or false,
			}
		end
	end
	return { status = "ok", items = items }
end

local function read_scratch(request)
	local context = M.context(request.cwd)
	local saved = find_scratch(request, context)
	if not saved then
		return { status = "not_found", error = ("Scratch %q does not exist"):format(request.name) }
	end

	local buf = scratch_buf(saved.file)
	return {
		status = "ok",
		content = buf and buffer_content(buf) or read_file(saved.file),
		modified = buf and vim.bo[buf].modified or false,
		file = saved.file,
	}
end

local function write_scratch(request)
	local context = M.context(request.cwd)
	local saved = find_scratch(request, context)
	local buf = saved and scratch_buf(saved.file) or nil
	if buf and vim.bo[buf].modified and not request.force then
		return {
			status = "conflict",
			error = ("Scratch %q has unsaved edits"):format(request.name),
			file = saved.file,
		}
	end

	local status = saved and "updated" or "created"
	if not saved then
		saved = {
			name = request.name,
			ft = request.ft,
			count = request.count,
			cwd = context.cwd,
			branch = context.branch,
		}
		local write_metadata = assert(Snacks.scratch._write_meta, "Snacks scratch metadata writer is unavailable")
		saved.file = write_metadata(M.root, saved)
		buf = scratch_buf(saved.file)
	end

	local wrote, err = pcall(buf and write_buffer or write_file, buf or saved.file, request.content)
	if not wrote then
		if status == "created" then
			uv.fs_unlink(saved.file .. ".meta")
		end
		error(err)
	end
	M.notify_changed()
	return {
		status = status,
		name = saved.name,
		ft = saved.ft,
		count = saved.count,
		cwd = saved.cwd,
		branch = saved.branch,
		file = saved.file,
	}
end

function M.run_agent_request(path)
	local ok, response = pcall(function()
		local request = validate_request(vim.json.decode(read_file(path)))
		if request.op == "list" then
			return list_scratches(request)
		elseif request.op == "read" then
			return read_scratch(request)
		else
			return write_scratch(request)
		end
	end)
	if not ok then
		response = { status = "error", error = tostring(response) }
	end
	return vim.json.encode(response)
end

function M.enable_nested_branches()
	local scratch = Snacks.scratch
	if rawget(scratch, "_user_nested_branch_keys") then
		return
	end

	-- Snacks only discovers a branch when `.git` is in the exact cwd and has no
	-- branch resolver option, so fill the metadata before it hashes the file key.
	local write_metadata = assert(scratch._write_meta, "Snacks scratch metadata writer is unavailable")
	scratch._write_meta = function(root, metadata)
		if metadata.cwd and not metadata.branch then
			metadata.branch = M.context(metadata.cwd).branch
		end
		return write_metadata(root, metadata)
	end
	rawset(scratch, "_user_nested_branch_keys", true)
end

return M
