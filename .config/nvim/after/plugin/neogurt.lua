-- neogurt
if not vim.g.neogurt then
	return
end

local utils = require("user.lib.utils")
local map = utils.map
local colors = require("user.cfg.colors")

local silent = { silent = true }
local remap = { remap = true }

-- all modes
local mode = { "", "!", "t", "l" }

vim.g.neogurt_cmd("option_set", {
	titlebar = "transparent",
	show_title = true,
	blur = 20,
	gamma = 1.7,
	vsync = true,
	fps = 60,

	margin_top = 0,
	margin_bottom = 0,
	margin_left = 0,
	margin_right = 0,

	macos_option_is_meta = "both",
	cursor_idle_time = 10,
	scroll_speed = 1,

	bg_color = tonumber(colors.nord17:sub(2), 16),
	opacity = 1.0,
})

-- sessionizer (create or select session)
-- from wiliam config
local choose_session = function(startup)
	local curr_id = vim.g.neogurt_cmd("session_info").id
	local session_list = vim.g.neogurt_cmd("session_list", { sort = "time" })

	local cmd = [[
            echo "$(begin;
              echo ~/;
              echo ~/dotfiles;
              echo ~/Documents;
              find ~/code -mindepth 0 -maxdepth 2 -type d;
            end;)"
            ]]
	local output = vim.fn.system(cmd)

	for dir in string.gmatch(output, "([^\n]+)") do
		table.insert(session_list, { dir = dir })
	end

	vim.ui.select(session_list, {
		prompt = "Create or select a session",
		format_item = function(session)
			if session.id ~= nil then
				if session.id == curr_id then
					return " " .. session.name
				else
					return " " .. session.name
				end
			else
				return session.dir
			end
		end,
	}, function(choice)
		if choice == nil then
			return
		end

		if choice.id ~= nil then
			vim.g.neogurt_cmd("session_switch", { id = choice.id })
		else
			local fmod = vim.fn.fnamemodify
			local dir = fmod(choice.dir, ":p")
			local name = fmod(dir, ":h:h:t") .. "/" .. fmod(dir, ":h:t")

			if startup then
				vim.g.neogurt_cmd("session_new", { dir = dir, name = name })
				vim.g.neogurt_cmd("session_kill")
			else
				vim.g.neogurt_cmd("session_new", { dir = dir, name = name })
			end
		end
	end)
end

-- change font size
map(mode, "<D-=>", "<cmd>Neogurt font_size_change 1 all=false<cr>")
map(mode, "<D-->", "<cmd>Neogurt font_size_change -1 all=false<cr>")
map(mode, "<D-0>", "<cmd>Neogurt font_size_reset all=false<cr>")

-- session mappings
map(mode, "<D-l>", "<cmd>Neogurt session_prev<cr>")
-- map(mode, "<D-m>", "<cmd>Neogurt session_select sort=time<cr>")
map(mode, "<D-R>", "<cmd>Neogurt session_restart<cr>")

map({ "n", "v" }, "<D-v>", '"+p', silent)
map({ "i", "c" }, "<D-v>", "<C-r>+", silent)
map("t", "<D-v>", "<C-\\><C-N><D-v>i", remap)

map(mode, "<D-m>", function()
	choose_session(false)
end)

vim.g.neogurt_startup = function()
	choose_session(true)
end
