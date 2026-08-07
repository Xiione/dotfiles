local uv = vim.uv
local rendezvous_dir = vim.fn.stdpath("state") .. "/sidekick/rendezvous"
local orphan_log_path = vim.fn.stdpath("state") .. "/sidekick/orphan-windows.jsonl"
local orphan_status_path = vim.fn.stdpath("state") .. "/sidekick/orphan-trace-status.json"

local function trace_orphan_windows()
	local recent_split
	local ctrl_w_at
	local window_events = {}
	local trace_group = vim.api.nvim_create_augroup("UserSidekickOrphanTrace", { clear = true })
	local key_namespace = vim.api.nvim_create_namespace("UserSidekickOrphanTrace")
	local split_commands = {
		new = true,
		sbuffer = true,
		sfind = true,
		split = true,
		vnew = true,
		vsplit = true,
	}
	local split_chords = {
		["<C-S>"] = "<C-W><C-S>",
		S = "<C-W>S",
		n = "<C-W>n",
		s = "<C-W>s",
		v = "<C-W>v",
	}

	local function remember_split(source, action)
		recent_split = {
			action = action,
			at = uv.hrtime(),
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
			elseif command.cmd == "wincmd" and vim.list_contains({ "n", "s", "S", "v" }, command.args[1]) then
				remember_split("command", "wincmd " .. command.args[1])
			end
		end,
		desc = "Track explicit split commands without retaining command-line text",
	})

	local function snapshot_terminals()
		local ok, terminal_module = pcall(require, "sidekick.cli.terminal")
		if not ok then
			return {}
		end

		local terminals = {}
		for id, terminal in pairs(terminal_module.terminals) do
			table.insert(terminals, {
				buf = terminal.buf,
				id = id,
				win = terminal.win,
			})
		end
		table.sort(terminals, function(left, right)
			return left.id < right.id
		end)
		return terminals
	end

	local function snapshot_window(win)
		local buf = vim.api.nvim_win_get_buf(win)
		return {
			buf = buf,
			current = win == vim.api.nvim_get_current_win(),
			filetype = vim.bo[buf].filetype,
			height = vim.api.nvim_win_get_height(win),
			sidekick_cli = vim.w[win].sidekick_cli,
			sidekick_session_id = vim.w[win].sidekick_session_id,
			width = vim.api.nvim_win_get_width(win),
			win = win,
			winbar = vim.wo[win].winbar,
			winfixbuf = vim.wo[win].winfixbuf,
		}
	end

	local function snapshot_state()
		return {
			cwd = uv.cwd(),
			layout = vim.fn.winlayout(),
			mode = vim.api.nvim_get_mode().mode,
			neogurt = vim.g.neogurt == true,
			pid = uv.os_getpid(),
			server = vim.v.servername,
			terminals = snapshot_terminals(),
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			uis = vim.api.nvim_list_uis(),
			version = 2,
			windows = vim.tbl_map(snapshot_window, vim.api.nvim_list_wins()),
		}
	end

	local function write_snapshot(path, snapshot, flags)
		vim.fn.mkdir(vim.fs.dirname(path), "p")
		local did_encode, content = pcall(vim.json.encode, snapshot)
		if did_encode and vim.fn.writefile({ content }, path, flags or "") == 0 then
			return true
		end
		vim.notify("Failed to write Sidekick window trace: " .. tostring(content), vim.log.levels.ERROR)
		return false
	end

	local function log_orphan(win, event_state)
		if not vim.api.nvim_win_is_valid(win) then
			return
		end

		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype ~= "sidekick_terminal" or vim.w[win].sidekick_orphan_trace then
			return
		end

		local terminals = snapshot_terminals()
		if vim.iter(terminals):any(function(terminal)
			return terminal.win == win
		end) then
			return
		end

		local split
		if recent_split then
			local elapsed_ms = (uv.hrtime() - recent_split.at) / 1e6
			if elapsed_ms <= 2000 then
				split = {
					action = recent_split.action,
					elapsed_ms = elapsed_ms,
					source = recent_split.source,
				}
			end
		end

		local record = vim.tbl_extend("force", snapshot_state(), {
			buffer = buf,
			event_mode = event_state.mode,
			event_reason = event_state.reason,
			event_stack = event_state.stack,
			kind = "orphan",
			split = split,
			win = win,
		})

		if not write_snapshot(orphan_log_path, record, "a") then
			return
		end

		vim.w[win].sidekick_orphan_trace = true
		vim.notify("Detected an untracked Sidekick window; wrote " .. orphan_log_path, vim.log.levels.WARN)
	end

	local function capture_event(reason)
		return {
			mode = vim.api.nvim_get_mode().mode,
			reason = reason,
			stack = debug.traceback(reason, 3),
		}
	end

	local function scan_windows(event_state, update_status)
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			log_orphan(win, window_events[win] or event_state)
		end
		if update_status then
			local status = vim.tbl_extend("force", snapshot_state(), {
				event_mode = event_state.mode,
				event_reason = event_state.reason,
				kind = "status",
			})
			write_snapshot(orphan_status_path, status)
		end
	end

	local function schedule_scan(reason, update_status)
		local event_state = capture_event(reason)
		vim.schedule(function()
			scan_windows(event_state, update_status)
		end)
	end

	vim.api.nvim_create_autocmd("WinNew", {
		group = trace_group,
		callback = function()
			local win = vim.api.nvim_get_current_win()
			local event_state = capture_event("WinNew")
			window_events[win] = event_state
			vim.schedule(function()
				scan_windows(event_state, false)
			end)
		end,
		desc = "Log untracked Sidekick terminal windows",
	})

	vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType", "TermOpen", "VimResized", "WinEnter" }, {
		group = trace_group,
		callback = function(event)
			schedule_scan(event.event, event.event == "VimResized")
		end,
		desc = "Rescan for delayed Sidekick terminal orphans",
	})

	vim.api.nvim_create_autocmd("WinClosed", {
		group = trace_group,
		callback = function(event)
			window_events[tonumber(event.match)] = nil
		end,
		desc = "Discard closed Sidekick window trace state",
	})

	schedule_scan("setup", true)
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

return {
	"folke/sidekick.nvim",
	lazy = false,
	keys = {
		{
			"<S-Tab>",
			function()
				if not require("sidekick").nes_jump_or_apply() then
					return "<S-Tab>"
				end
			end,
			mode = "i",
			expr = true,
			desc = "Go to/apply next edit suggestion",
		},
		{
			"<D-i>",
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
		{
			"<D-i>",
			function()
				require("user.lib.sidebars").open("sidekick", true)
				require("sidekick.cli").send({ name = "codex", msg = "{selection}" })
			end,
			mode = "x",
			desc = "Send visual selection to Codex",
		},
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
					nav_right = {
						"<C-l>",
						function() end,
						mode = "t",
						desc = "Ignore Ctrl-L in Sidekick terminal", -- codex clear chat is annoying and i dont need it
					},
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
