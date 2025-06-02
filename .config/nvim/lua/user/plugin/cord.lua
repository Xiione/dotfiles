local status_ok, cord = pcall(require, "cord")
if not status_ok then
	return
end

local icons = require("cord.api.icon")

local apm_status_ok, _ = pcall(require, "vim-apm")
if not apm_status_ok then
	return
end

local manager = nil
local suppressed = false

local apm_bus = require("vim-apm.bus")
local apm_events = require("vim-apm.event_names")
local stats = { buf_enter_count = 0, write_count = 0 }
local apm_stats = 0

-- apm_bus:listen(apm_events.STATS, function(s)
-- 	stats = s
-- end)
-- apm_bus:listen(apm_events.APM_REPORT, function(a)
-- 	if not manager then
-- 		return
-- 	end
-- 	local prev = apm_stats
-- 	apm_stats = a
--
-- 	-- gives it a chance to go to idle mode instead of causing an update when APM is 0
-- 	if prev ~= 0 then
--         if suppressed then
--             manager:toggle_suppress()
--             suppressed = false
--         end
--         -- manager:unidle()
-- 		manager:queue_update(true)
--     else
--         manager:suppress()
--         suppressed = true
-- 		manager:queue_update(true)
-- 	end
-- end)

-- cord.setup({
-- 	editor = {
-- 		tooltip = vim.g.neogurt and "Neogurt MacOS Frontend" or "Neovim",
-- 		icon = icons.get("neovim", "catppuccin", "dark"),
-- 	},
-- 	display = {
-- 		theme = "default",
-- 		flavor = "accent",
-- 	},
-- 	idle = {
-- 		-- timeout = 300000,
--         smart_idle = false,
-- 		timeout = 10000,
-- 		show_status = false,
-- 		-- unidle_on_focus = false,
-- 	},
-- 	variables = {
-- 		apm = function()
-- 			return apm_stats
-- 		end,
-- 		writes = function()
-- 			return stats.write_count
-- 		end,
-- 		bufenters = function()
-- 			return stats.buf_enter_count
-- 		end,
-- 	},
-- 	text = {
-- 		workspace = "💾 ${writes} | ${apm} APM",
-- 	},
-- 	hooks = {
-- 		ready = function(m)
-- 			manager = m
-- 		end,
-- 	},
-- })
