-- neogurt
if not vim.g.neogurt then
	return
end

local utils = require("user.lib.utils")
local map = utils.map
local neogurt = require("user.lib.neogurt")
local colors = require("user.cfg.colors")
local icons = require("user.cfg.icons")

local silent = { silent = true }
local remap = { remap = true }

local function paste_clipboard()
	vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end

local function create_session(dir, startup)
	local absolute_dir = vim.fn.fnamemodify(dir, ":p")
	local name = neogurt.session_name(absolute_dir)

	vim.g.neogurt_cmd("session_new", { dir = absolute_dir, name = name })
	if startup then
		vim.g.neogurt_cmd("session_kill")
	end
end

-- all modes
local mode = { "", "!", "t", "l" }

vim.g.neogurt_cmd("option_set", {
	titlebar = "transparent",
	show_title = true,
	blur = 20,
	gamma = 1.7,
	vsync = true,
	fps = 120,

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
	local curr_id = not startup and vim.g.neogurt_cmd("session_info").id or -1
	local session_list = not startup
			-- and utils.array_filter(vim.g.neogurt_cmd("session_list", { sort = "time" }), function(sess)
			-- 	return sess.id ~= curr_id
			-- end)
			and vim.g.neogurt_cmd("session_list", { sort = "time" })
		or {}

	local cmd = [[
             echo "$(begin;
               echo ~/;
               echo ~/dotfiles;
               echo ~/Documents;
               find ~/code -mindepth 0 -maxdepth 1 -type d 2>/dev/null;
               find ~/figma -mindepth 0 -maxdepth 1 -type d 2>/dev/null;
             end;)"
             ]]
	local output = vim.fn.system(cmd)

	for dir in string.gmatch(output, "([^\n]+)") do
		table.insert(session_list, { dir = dir })
	end

	local items = {}
	for _, session in ipairs(session_list) do
		local text
		if session.id ~= nil then
			local icon = session.id == curr_id and icons.status.current_session or icons.status.available_session
			text = icon .. " " .. session.name
		else
			text = session.dir
		end
		items[#items + 1] = { session = session, text = text }
	end

	local completed = false
	local picker = Snacks.picker({
		items = items,
		title = not startup and "Select a session" or "Welcome back :)",
		format = "text",
		preview = function()
			return false
		end,
		layout = { preset = "select", preview = false },
		actions = {
			confirm = function(current_picker, item)
				if completed then
					return
				end
				local manual_path = vim.trim(current_picker.input:get())
				completed = true
				current_picker:close()

				if item and item.session then
					if item.session.id ~= nil then
						if item.session.id ~= curr_id then
							vim.g.neogurt_cmd("session_switch", { id = item.session.id })
						end
					else
						create_session(item.session.dir, startup)
					end
					return
				end

				if manual_path ~= "" then
					create_session(manual_path, startup)
				end
			end,
		},
		on_close = function()
			if not completed then
				completed = true
			end
		end,
	})

	return picker
end

-- change font size
map(mode, "<D-=>", "<Cmd>Neogurt font_size_change 1 all=false<CR>")
map(mode, "<D-->", "<Cmd>Neogurt font_size_change -1 all=false<CR>")
map(mode, "<D-0>", "<Cmd>Neogurt font_size_reset all=false<CR>")

-- session mappings
map(mode, "<D-l>", "<Cmd>Neogurt session_prev<CR>")
-- map(mode, "<D-m>", "<Cmd>Neogurt session_select sort=time<CR>")
map(mode, "<D-S-r>", "<Cmd>Neogurt session_restart cmd=qa<CR>")

map({ "n", "v" }, "<D-v>", '"+p', silent)
map({ "i", "c" }, "<D-v>", paste_clipboard, silent)
map("t", "<D-v>", "<C-\\><C-n><D-v>i", remap)

-- whatever
map(mode, "<D-s>", function()
	choose_session(false)
end)
map(mode, "<D-m>", function()
	choose_session(false)
end)

vim.g.neogurt_startup = function()
	choose_session(true)
end
