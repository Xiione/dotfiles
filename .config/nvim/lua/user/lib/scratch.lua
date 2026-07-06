local M = {}

M.root = vim.fs.normalize(vim.fn.stdpath("data") .. "/scratch")

function M.context(cwd)
	cwd = vim.fs.normalize(cwd or assert(vim.uv.cwd()))
	local result = vim.system({ "git", "-C", cwd, "branch", "--show-current" }, { text = true }):wait()
	local branch = vim.trim(result.stdout or "")

	return {
		cwd = cwd,
		branch = result.code == 0 and branch ~= "" and branch or nil,
	}
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
