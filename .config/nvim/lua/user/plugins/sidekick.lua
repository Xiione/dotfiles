local uv = vim.uv
local rendezvous_dir = vim.fn.stdpath("state") .. "/sidekick/rendezvous"
local orphan_log_path = vim.fn.stdpath("state") .. "/sidekick/orphan-windows.jsonl"
local orphan_status_path = vim.fn.stdpath("state") .. "/sidekick/orphan-trace-status.json"

local function trace_orphan_windows()
	local recent_split
	local ctrl_w_at
	local window_history = {}
	local known_windows = {}
	local trace_started = uv.hrtime()
	local trace_group = vim.api.nvim_create_augroup("UserSidekickOrphanTrace", { clear = true })
	local key_namespace = vim.api.nvim_create_namespace("UserSidekickOrphanTrace")
	local history_limit = 80
	local close_delay_ms = 150
	local split_commands = {
		new = true,
		sbuffer = true,
		sfind = true,
		split = true,
		tabnew = true,
		tabsplit = true,
		vnew = true,
		vsplit = true,
	}
	local split_chords = {
		["<C-S>"] = "<C-W><C-S>",
		["<C-V>"] = "<C-W><C-V>",
		["<C-N>"] = "<C-W><C-N>",
		S = "<C-W>S",
		n = "<C-W>n",
		s = "<C-W>s",
		v = "<C-W>v",
	}

	local function remember_split(source, action)
		recent_split = {
			action = action,
			at = uv.hrtime(),
			current_win = vim.api.nvim_get_current_win(),
			windows = vim.api.nvim_list_wins(),
			source = source,
		}
	end

	-- Retain recognized split actions only; never record ordinary terminal input.
	vim.on_key(nil, key_namespace)
	vim.on_key(function(key)
		local now = uv.hrtime()
		local token = vim.fn.keytrans(key)
		if ctrl_w_at and now - ctrl_w_at <= 2e9 then
			local chord = split_chords[token]
			if chord then
				remember_split("key", chord)
			end
			ctrl_w_at = nil
		elseif token == "<C-W>" then
			ctrl_w_at = now
		else
			ctrl_w_at = nil
		end
	end, key_namespace)

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = trace_group,
		pattern = ":",
		callback = function()
			local ok, command = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
			if not ok then
				return
			end
			if split_commands[command.cmd] then
				remember_split("command", command.cmd)
			elseif command.cmd == "tab" and vim.list_contains({ "new", "split" }, command.args[1]) then
				remember_split("command", "tab " .. command.args[1])
			elseif command.cmd == "wincmd" and vim.list_contains({ "n", "s", "S", "v" }, command.args[1]) then
				remember_split("command", "wincmd " .. command.args[1])
			end
		end,
		desc = "Track explicit split commands without retaining command-line text",
	})

	local function get_terminal_module()
		local ok, module = pcall(require, "sidekick.cli.terminal")
		if not ok then
			return nil, tostring(module)
		end
		return module
	end

	local function snapshot_tool(tool)
		if type(tool) == "string" then
			return tool
		end
		if type(tool) ~= "table" then
			return nil
		end
		return {
			cmd = tool.cmd,
			config_cmd = type(tool.config) == "table" and tool.config.cmd or nil,
			is_proc = type(tool.is_proc) == "string" and tool.is_proc or nil,
			name = tool.name,
			url = tool.url,
		}
	end

	local function snapshot_terminals()
		local module, err = get_terminal_module()
		if not module then
			return {}, err
		end

		local terminals = {}
		for id, terminal in pairs(module.terminals) do
			local running_ok, running = pcall(terminal.is_running, terminal)
			local open_ok, is_open = pcall(terminal.is_open, terminal)
			table.insert(terminals, {
				atime = terminal.atime,
				backend = terminal.backend,
				buf = terminal.buf,
				closed = terminal.closed,
				cwd = terminal.cwd,
				ctime = terminal.ctime,
				id = id,
				is_open = open_ok and is_open or nil,
				is_running = running_ok and running or nil,
				job = terminal.job,
				mux_backend = terminal.mux_backend,
				mux_session = terminal.mux_session,
				parent = terminal.parent and {
					backend = terminal.parent.backend,
					cwd = terminal.parent.cwd,
					id = terminal.parent.id,
					mux_session = terminal.parent.mux_session,
					tool = snapshot_tool(terminal.parent.tool),
				} or nil,
				pids = terminal.pids,
				started = terminal.started,
				tool = snapshot_tool(terminal.tool),
				win = terminal.win,
			})
		end
		table.sort(terminals, function(left, right)
			return left.id < right.id
		end)
		return terminals, nil
	end

	local function snapshot_window(win)
		local buf = vim.api.nvim_win_get_buf(win)
		local config = vim.api.nvim_win_get_config(win)
		return {
			buf = {
				buf = buf,
				bufhidden = vim.bo[buf].bufhidden,
				buflisted = vim.bo[buf].buflisted,
				buftype = vim.bo[buf].buftype,
				changedtick = vim.api.nvim_buf_get_changedtick(buf),
				filetype = vim.bo[buf].filetype,
				line_count = vim.api.nvim_buf_line_count(buf),
				modifiable = vim.bo[buf].modifiable,
				name = vim.api.nvim_buf_get_name(buf),
				sidekick_cli = snapshot_tool(vim.b[buf].sidekick_cli),
				sidekick_session_id = vim.b[buf].sidekick_session_id,
			},
			current = win == vim.api.nvim_get_current_win(),
			height = vim.api.nvim_win_get_height(win),
			relative = config.relative,
			tabpage = vim.api.nvim_win_get_tabpage(win),
			window_config = {
				anchor = config.anchor,
				col = config.col,
				external = config.external,
				focusable = config.focusable,
				height = config.height,
				row = config.row,
				style = config.style,
				width = config.width,
			},
			sidekick_cli = snapshot_tool(vim.w[win].sidekick_cli),
			sidekick_session_id = vim.w[win].sidekick_session_id,
			width = vim.api.nvim_win_get_width(win),
			win = win,
			winbar = vim.wo[win].winbar,
			winfixbuf = vim.wo[win].winfixbuf,
			winfixheight = vim.wo[win].winfixheight,
			winfixwidth = vim.wo[win].winfixwidth,
			winhighlight = vim.wo[win].winhighlight,
		}
	end

	local function snapshot_state()
		local terminals, terminal_error = snapshot_terminals()
		return {
			cwd = uv.cwd(),
			current_buf = vim.api.nvim_get_current_buf(),
			current_win = vim.api.nvim_get_current_win(),
			layout = vim.fn.winlayout(),
			mode = vim.api.nvim_get_mode().mode,
			neogurt = vim.g.neogurt == true,
			pid = uv.os_getpid(),
			server = vim.v.servername,
			terminal_registry_error = terminal_error,
			terminals = terminals,
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			uis = vim.api.nvim_list_uis(),
			version = 3,
			windows = vim.tbl_map(snapshot_window, vim.api.nvim_list_wins()),
		}
	end

	local function write_snapshot(path, snapshot, flags)
		vim.fn.mkdir(vim.fs.dirname(path), "p")
		local did_encode, content = pcall(vim.json.encode, snapshot)
		if not did_encode then
			vim.notify("Failed to encode Sidekick window trace: " .. tostring(content), vim.log.levels.ERROR)
			return false
		end
		local result = vim.fn.writefile({ content }, path, flags or "")
		if result == 0 then
			return true
		end
		vim.notify(
			"Failed to write Sidekick window trace: " .. path .. " (writefile=" .. result .. ")",
			vim.log.levels.ERROR
		)
		return false
	end

	local function has_registered_window(win)
		local module = get_terminal_module()
		if not module then
			return nil, false
		end
		for _, terminal in pairs(module.terminals) do
			if terminal.win == win then
				return true, true
			end
		end
		return false, true
	end

	local function lifecycle_event(reason, win, buf, event, with_stack)
		local current_win = vim.api.nvim_get_current_win()
		local current_buf = vim.api.nvim_get_current_buf()
		local buf_valid = buf and buf > 0 and vim.api.nvim_buf_is_valid(buf)
		local record = {
			buf = buf_valid and buf or nil,
			bufname = buf_valid and vim.api.nvim_buf_get_name(buf) or nil,
			buftype = buf_valid and vim.bo[buf].buftype or nil,
			current_buf = current_buf,
			current_win = current_win,
			elapsed_ms = (uv.hrtime() - trace_started) / 1e6,
			event = reason,
			filetype = buf_valid and vim.bo[buf].filetype or nil,
			match = event and event.match or nil,
			mode = vim.api.nvim_get_mode().mode,
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			win = win,
		}
		if win and vim.api.nvim_win_is_valid(win) then
			record.window_buf = vim.api.nvim_win_get_buf(win)
			record.window_bufname = vim.api.nvim_buf_get_name(record.window_buf)
			record.window_filetype = vim.bo[record.window_buf].filetype
		end
		if event and event.file and event.file ~= "" then
			record.file = event.file
		end
		local event_data_ok, event_data = pcall(vim.deepcopy, vim.v.event)
		if event_data_ok and type(event_data) == "table" and next(event_data) then
			record.event_data = event_data
		end
		if with_stack then
			record.stack = debug.traceback("", 3)
		end
		return record
	end

	local function remember_window_event(win, record)
		local history = window_history[win] or {}
		table.insert(history, record)
		while #history > history_limit do
			table.remove(history, 1)
		end
		window_history[win] = history
	end

	local function record_event_for_buffer(reason, event, with_stack, explicit_win)
		local buf = event and event.buf or nil
		local wins = {}
		if explicit_win then
			wins[1] = explicit_win
		elseif buf and buf > 0 and vim.api.nvim_buf_is_valid(buf) then
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_get_buf(win) == buf then
					table.insert(wins, win)
				end
			end
		end
		if #wins == 0 then
			wins[1] = vim.api.nvim_get_current_win()
		end
		for _, win in ipairs(wins) do
			remember_window_event(win, lifecycle_event(reason, win, buf, event, with_stack))
		end
	end

	local function close_orphan(win, buf, detected)
		local decision
		if not vim.api.nvim_win_is_valid(win) then
			decision = "already_closed"
		elseif vim.api.nvim_win_get_buf(win) ~= buf then
			decision = "buffer_changed"
		elseif vim.bo[buf].filetype ~= "sidekick_terminal" then
			decision = "filetype_changed"
		else
			local tracked, registry_available = has_registered_window(win)
			if not registry_available then
				decision = "registry_unavailable"
			elseif tracked then
				decision = "now_registered"
			else
				decision = "close"
			end
		end

		local record = vim.tbl_extend("force", snapshot_state(), {
			decision = decision,
			detected_event = detected.event,
			detected_win = win,
			kind = "orphan_close",
			recheck_after_ms = close_delay_ms,
			window_history = window_history[win] or {},
		})
		if decision ~= "close" then
			if vim.api.nvim_win_is_valid(win) then
				vim.w[win].sidekick_orphan_trace = nil
			end
			write_snapshot(orphan_log_path, record, "a")
			return
		end

		local logged = write_snapshot(orphan_log_path, record, "a")
		local closed, err = pcall(vim.api.nvim_win_close, win, true)
		local close_record = {
			action_succeeded = closed,
			closed_window = closed and not vim.api.nvim_win_is_valid(win),
			detected_event = detected.event,
			detected_win = win,
			error = closed and nil or tostring(err),
			kind = "orphan_close_result",
			log_written = logged,
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			version = 3,
		}
		write_snapshot(orphan_log_path, close_record, "a")
		if close_record.closed_window then
			vim.notify("Closed an untracked Sidekick window; trace: " .. orphan_log_path, vim.log.levels.WARN)
		else
			vim.notify(
				"Could not close untracked Sidekick window " .. win .. "; trace: " .. orphan_log_path,
				vim.log.levels.ERROR
			)
		end
	end

	local function log_orphan(win, event_state)
		if not vim.api.nvim_win_is_valid(win) then
			return
		end

		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype ~= "sidekick_terminal" or vim.w[win].sidekick_orphan_trace then
			return
		end

		local tracked, registry_available = has_registered_window(win)
		if not registry_available or tracked then
			return
		end

		local split
		if recent_split then
			local elapsed_ms = (uv.hrtime() - recent_split.at) / 1e6
			if elapsed_ms <= 2000 then
				split = {
					action = recent_split.action,
					current_win = recent_split.current_win,
					elapsed_ms = elapsed_ms,
					source = recent_split.source,
					windows = recent_split.windows,
				}
			end
		end

		local record = vim.tbl_extend("force", snapshot_state(), {
			buffer = buf,
			close_delay_ms = close_delay_ms,
			event_mode = event_state.mode,
			event_reason = event_state.event,
			event_stack = event_state.stack,
			kind = "orphan",
			split = split,
			win = win,
			window_history = window_history[win] or {},
		})

		vim.w[win].sidekick_orphan_trace = true
		local logged = write_snapshot(orphan_log_path, record, "a")
		vim.notify(
			(logged and "Detected" or "Detected; trace write failed for")
				.. " an untracked Sidekick window; trace: "
				.. orphan_log_path,
			logged and vim.log.levels.WARN or vim.log.levels.ERROR
		)
		vim.defer_fn(function()
			close_orphan(win, buf, event_state)
		end, close_delay_ms)
	end

	local function scan_windows(event_state, update_status)
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			log_orphan(win, event_state)
		end
		if update_status then
			local status = vim.tbl_extend("force", snapshot_state(), {
				event_mode = event_state.mode,
				event_reason = event_state.event,
				event_stack = event_state.stack,
				kind = "status",
			})
			write_snapshot(orphan_status_path, status)
		end
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		known_windows[win] = true
		remember_window_event(win, lifecycle_event("trace_setup", win, vim.api.nvim_win_get_buf(win), nil, false))
	end

	vim.api.nvim_create_autocmd("WinNew", {
		group = trace_group,
		callback = function(event)
			local new_wins = {}
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if not known_windows[win] then
					known_windows[win] = true
					table.insert(new_wins, win)
				end
			end
			local event_state = lifecycle_event("WinNew", nil, vim.api.nvim_get_current_buf(), event, true)
			for _, win in ipairs(new_wins) do
				local buf = vim.api.nvim_win_get_buf(win)
				remember_window_event(win, lifecycle_event("WinNew", win, buf, event, true))
			end
			vim.schedule(function()
				scan_windows(event_state, false)
			end)
		end,
		desc = "Track Sidekick window creation and close orphaned terminals",
	})

	vim.api.nvim_create_autocmd({
		"BufEnter",
		"BufDelete",
		"BufWipeout",
		"BufWinEnter",
		"BufWinLeave",
		"FileType",
		"TermClose",
		"TermOpen",
		"VimResized",
		"WinEnter",
		"WinLeave",
	}, {
		group = trace_group,
		callback = function(event)
			local with_stack = vim.list_contains({ "BufWinEnter", "FileType", "TermOpen" }, event.event)
			record_event_for_buffer(event.event, event, with_stack)
			local event_state =
				lifecycle_event(event.event, vim.api.nvim_get_current_win(), event.buf, event, with_stack)
			vim.schedule(function()
				scan_windows(event_state, event.event == "VimResized")
			end)
		end,
		desc = "Trace buffer and window lifecycle while checking for Sidekick orphans",
	})

	vim.api.nvim_create_autocmd("WinClosed", {
		group = trace_group,
		callback = function(event)
			local win = tonumber(event.match)
			if win then
				remember_window_event(win, lifecycle_event("WinClosed", win, nil, event, false))
				window_history[win] = nil
				known_windows[win] = nil
			end
		end,
		desc = "Discard closed Sidekick window trace state",
	})

	local setup_event =
		lifecycle_event("trace_setup", vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), nil, true)
	vim.schedule(function()
		scan_windows(setup_event, true)
	end)
end

local function codex_session(event)
	local id = event.data and event.data.id
	return type(id) == "string" and id:match("^terminal: (codex [%da-f]+)$") or nil
end

local function rendezvous_path(session)
	return rendezvous_dir .. "/" .. session .. ".json"
end

local function read_rendezvous(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	local ok, rendezvous = pcall(vim.json.decode, content)
	return ok and rendezvous or nil
end

local function register_codex_host(event)
	local session = codex_session(event)
	if not session or vim.v.servername == "" then
		return
	end

	local session_state = require("sidekick.util").get_state(session)
	if not session_state or session_state.tool ~= "codex" then
		return
	end

	vim.fn.mkdir(rendezvous_dir, "p")
	local path = rendezvous_path(session)
	local temp_path = path .. "." .. uv.os_getpid() .. ".tmp"
	local rendezvous = vim.json.encode({
		version = 1,
		session = session,
		server = vim.v.servername,
		pid = uv.os_getpid(),
		cwd = session_state.cwd,
	})
	if vim.fn.writefile({ rendezvous }, temp_path, "b") ~= 0 then
		vim.notify("Failed to write Codex Neovim rendezvous", vim.log.levels.ERROR)
		return
	end
	local renamed, err = uv.fs_rename(temp_path, path)
	if not renamed then
		uv.fs_unlink(temp_path)
		vim.notify("Failed to publish Codex Neovim rendezvous: " .. tostring(err), vim.log.levels.ERROR)
	end
end

local function remove_codex_host(event)
	local session = codex_session(event)
	if not session then
		return
	end
	local path = rendezvous_path(session)
	local rendezvous = read_rendezvous(path)
	if rendezvous and rendezvous.server == vim.v.servername then
		uv.fs_unlink(path)
	end
end

local function remove_owned_hosts()
	local directory = uv.fs_scandir(rendezvous_dir)
	if not directory then
		return
	end
	while true do
		local name, kind = uv.fs_scandir_next(directory)
		if not name then
			break
		end
		if kind == "file" and name:match("^codex [%da-f]+%.json$") then
			local path = rendezvous_dir .. "/" .. name
			local rendezvous = read_rendezvous(path)
			if rendezvous and rendezvous.server == vim.v.servername then
				uv.fs_unlink(path)
			end
		end
	end
end

local function resolve_path(path)
	local normalized = vim.fs.normalize(uv.fs_realpath(path) or vim.fn.fnamemodify(path, ":p")):gsub("/+$", "")
	return normalized == "" and "/" or normalized
end

local function focus_codex(args)
	local target = vim.json.decode(args.args)
	assert(
		type(target) == "table" and type(target.cwd) == "string" and type(target.session) == "string",
		"Invalid Codex notification target"
	)
	assert(vim.g.neogurt and target.pid == uv.os_getpid(), "The target Neogurt session is no longer available")
	local terminal = require("sidekick.cli.session").attached()[target.session]
	assert(
		terminal
			and terminal.backend == "terminal"
			and terminal.tool.name == "codex"
			and resolve_path(terminal.cwd) == resolve_path(target.cwd),
		"The matching Codex terminal is no longer attached"
	)
	local session = vim.g.neogurt_cmd("session_info")
	assert(session and vim.g.neogurt_cmd("session_switch", { id = session.id }), "Failed to select the Neogurt session")
	require("user.lib.sidebars").open("sidekick", true)
	-- show() keeps focus on repeated clicks; focus() would toggle it away.
	require("sidekick.cli").show({
		focus = true,
		filter = { name = "codex", session = target.session, attached = true },
	})
end

return {
	"folke/sidekick.nvim",
	lazy = false,
	keys = {
		-- {
		-- 	"<S-Tab>",
		-- 	function()
		-- 		if not require("sidekick").nes_jump_or_apply() then
		-- 			return "<S-Tab>"
		-- 		end
		-- 	end,
		-- 	mode = "i",
		-- 	expr = true,
		-- 	desc = "Go to/apply next edit suggestion",
		-- },
		{
			"<c-.>",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").focus("codex")
			end,
			mode = { "n", "t", "i" },
			desc = "Focus Codex",
		},
		{
			"<leader>aa",
			function()
				require("user.lib.sidebars").toggle("sidekick")
			end,
			desc = "Toggle Codex",
		},
		{
			"<leader>a?",
			function()
				require("sidekick.cli").select({ filter = { name = "codex" } })
			end,
			desc = "Select Codex session",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close("codex")
			end,
			desc = "Detach a Codex session",
		},
		{
			"<leader>at",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").send({ name = "codex", msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send this to Codex",
		},
		{
			"<leader>ac",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").send({ name = "codex", msg = "{file}" })
			end,
			desc = "Send file to Codex",
		},
		-- {
		-- 	"<D-i>",
		-- 	function()
		-- 		require("user.lib.sidebars").open("sidekick", true)
		-- 		require("sidekick.cli").send({ name = "codex", msg = "{selection}" })
		-- 	end,
		-- 	mode = "x",
		-- 	desc = "Send visual selection to Codex",
		-- },
		{
			"<leader>ap",
			function()
				local cli = require("sidekick.cli")
				cli.prompt(function(_, text)
					if text then
						require("user.lib.sidebars").open("sidekick", true)
						cli.send({ name = "codex", text = text })
					end
				end)
			end,
			mode = { "n", "x" },
			desc = "Select prompt for Codex",
		},
		{
			"<leader>ak",
			function()
				require("sidekick.cli").select({
					filter = { name = "codex", started = true },
					cb = function(state)
						local session = state and state.session
						local name = session and session.mux_session

						if not name then
							vim.notify("No Zellij session found", vim.log.levels.WARN)
							return
						end

						Snacks.picker.util.confirm(("Kill Codex session in %s?"):format(session.cwd), function()
							vim.system({ "zellij", "kill-session", name })
						end)
					end,
				})
			end,
			desc = "Kill Codex session",
		},
	},
	opts = {
		cli = {
			tools = {
				codex = {
					cmd = { vim.fn.expand("~/.codex/bin/codex-terminal-filter") },
					is_proc = "\\<codex\\>\\|\\<codex-terminal-filter\\>",
				},
			},
			prompts = {
				diagnostics = "{diagnostics}",
				diagnostics_all = "{diagnostics_all}",
			},
			win = {
				wo = {
					winfixbuf = true,
				},
				keys = {
					hide_n = false,
					-- nav_right = {
					-- 	"<C-l>",
					-- 	function() end,
					-- 	mode = "t",
					-- 	desc = "Ignore Ctrl-L in Sidekick terminal", -- codex clear chat is annoying and i dont need it
					-- },
				},
			},
			mux = {
				backend = "zellij",
				enabled = true,
			},
		},
		nes = {
			enabled = false,
		},
	},
	config = function(_, opts)
		require("sidekick").setup(opts)
		trace_orphan_windows()
		vim.api.nvim_create_user_command("CodexNotifyFocus", focus_codex, {
			nargs = 1,
			desc = "Focus the existing Neogurt Codex terminal named by a notification target",
		})

		local group = vim.api.nvim_create_augroup("UserSidekickRendezvous", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "SidekickCliAttach",
			callback = register_codex_host,
		})
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "SidekickCliDetach",
			callback = remove_codex_host,
		})
		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = group,
			callback = remove_owned_hosts,
		})
	end,
}
