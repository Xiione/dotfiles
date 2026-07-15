local uv = vim.uv
local rendezvous_dir = vim.fn.stdpath("state") .. "/sidekick/rendezvous"

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
