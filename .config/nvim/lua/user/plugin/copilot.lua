local sidebars = require("user.lib.sidebars")

local disabled = {
	yaml = false,
	markdown = false,
	help = false,
	gitcommit = false,
	gitrebase = false,
	hgcommit = false,
	svn = false,
	cvs = false,
	["."] = false,
}
for _, ft in ipairs(sidebars.sidebar_types) do
	disabled[ft] = false
end
local filetypes = disabled

return {
	panel = {
		enabled = false,
	},
	suggestion = {
		enabled = true,
		auto_trigger = false,
		trigger_on_accept = true,
		keymap = {
			accept = "<S-tab>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = filetypes,
	copilot_model = "gpt-5-codex",
	-- https://github.com/zbirenbaum/copilot.lua/issues/484#issuecomment-3656544280
	server_opts_overrides = {
		-- Connection management to prevent GitHub handle leaks
		settings = {
			advanced = {
				timeout = 10000, -- 10 seconds instead of indefinite
			},
		},
		flags = {
			debounce_text_changes = 500, -- Reduce API calls
			allow_incremental_sync = false, -- Force clean syncs
		},
		on_attach = function(client, _)
			-- Check file handle count every 30 minutes and restart if excessive
			local timer = vim.uv.new_timer()
			if timer then
				timer:start(
					1800000, -- 30 minutes
					1800000, -- repeat every 30 minutes
					vim.schedule_wrap(function()
						-- Get handle count for copilot process
						local pid = (client.rpc and client.rpc.pid) or client.pid
						if not pid then
							vim.notify_once(
								"Copilot: Unable to determine language server PID; skipping handle leak check",
								vim.log.levels.DEBUG
							)
							return
						end
						local handle = io.popen("lsof -p " .. pid .. " 2>/dev/null | wc -l")
						if not handle then
							return
						end
						local count = tonumber(handle:read("*a"):match("%d+")) or 0
						handle:close()
						-- If > 100 handles, restart the language server
						if count > 100 then
							vim.notify(
								"Copilot: Restarting language server (handle leak detected: " .. count .. ")",
								vim.log.levels.WARN
							)
							vim.lsp.stop_client(client.id)
							timer:stop()
							timer:close()
						end
					end)
				)
			end
		end,
	},
}
