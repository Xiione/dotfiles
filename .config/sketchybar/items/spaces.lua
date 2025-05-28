local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local empty_string = "—"

local current_space = nil
local previous_space = nil
local current_display = nil
local current_spaces = {}
local windows_on_spaces = {}

local total_spaces = 12

-- Initialize current_display with yabai query
sbar.exec("yabai -m query --displays --display | jq -r '.index'", function(result)
	if result then
		current_display = tonumber(result)
	end
end)

local function log_debug(s)
	-- os.execute("echo '" .. s .. "' >> /tmp/sketchybar_debug.log")
end

local spaces = {}
local space_brackets = {}
local spaces_initialized = {}

local bracket_border_default = colors.bg2
local bracket_border_prev = colors.bg2
local bracket_border_selected = colors.bg2
local bg_border_default = colors.bg2
local bg_border_prev = colors.lighter_grey
local bg_border_selected = colors.blue

local function hl_space_default(sid)
	if not sid then
		return
	end
	spaces[sid]:set({
		icon = { highlight = false },
		label = { highlight = false },
		background = { border_color = bg_border_default },
	})

	space_brackets[sid]:set({
		background = { border_color = bracket_border_default },
	})
end

local function hl_space_prev(sid)
	if not sid then
		return
	end
	spaces[sid]:set({
		icon = { highlight = false },
		label = { highlight = false },
		background = { border_color = bg_border_prev },
	})

	space_brackets[sid]:set({
		background = { border_color = bracket_border_prev },
	})
end

local function hl_space_selected(sid)
	if not sid then
		return
	end
	spaces[sid]:set({
		icon = { highlight = true },
		label = { highlight = true },
		background = { border_color = bg_border_selected },
	})

	space_brackets[sid]:set({
		background = { border_color = bracket_border_selected },
	})
end

local spaces_indicator = sbar.add("item", {
	padding_left = -2,
	padding_right = 4,
	icon = {
		padding_left = 8,
		padding_right = 8,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Menus",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

for i = 1, total_spaces, 1 do
	local space = sbar.add("space", "space." .. i, {
		space = i,
		icon = {
			font = { family = settings.font.numbers },
			string = i,
			padding_left = 10,
			padding_right = 8,
			color = colors.light_grey,
			highlight_color = colors.white,
		},
		label = {
			padding_right = 12,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			string = empty_string,
			y_offset = 0,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			color = colors.bg1,
			border_width = 1,
			height = 26,
			border_color = bg_border_default,
		},
		popup = { background = { border_width = 5, border_color = colors.bg2 } },
	})

	spaces[i] = space
	spaces_initialized[i] = false

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = bracket_border_default,
			height = 28,
			border_width = 2,
		},
	})
	space_brackets[i] = space_bracket

	-- Padding space
	sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
	})

	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 0,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2,
			},
		},
	})

	-- not fired when selecting a space already active but on a different display.
	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		local sid = tonumber(env.SID)

		current_spaces = env.INFO

		-- event fires once on startup, we want to throw it away for all but the selected space
		if not spaces_initialized[sid] then
			spaces_initialized[sid] = true

			-- highlight active space on focused display only on init
			if selected and current_spaces["display-" .. current_display] ~= sid then
				return
			end
		end

		if selected then
			hl_space_selected(sid)
			current_space = sid
		elseif spaces_initialized[sid] and previous_space ~= sid then
			if previous_space ~= current_space then
				hl_space_default(previous_space)
			end
			previous_space = sid
			hl_space_prev(sid)
		end
	end)


	-- we must refresh every space's highlights since we can't keep track of swaps
	space:subscribe("mission_control_exit", function(env)
		sbar.exec("yabai -m query --spaces --space " .. env.SID, function(result)
			local sid = tonumber(env.SID)
			if result["has-focus"] then
				current_space = sid
				hl_space_selected(sid)
				current_spaces["display-" .. result["display"]] = sid
			else
				hl_space_default(sid)
			end
		end)
	end)

	space:subscribe("mouse.clicked", function(env)
		if env.MODIFIER == "shift" then
			space_popup:set({ background = { image = "space." .. env.SID } })
			space:set({ popup = { drawing = "toggle" } })
		else
			local op = (env.BUTTON == "right") and "--destroy" or "--focus"
			sbar.exec("yabai -m space " .. op .. " " .. env.SID)
		end
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)

	windows_on_spaces[i] = {}
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

-- inconsistent behavior
-- space_window_observer:subscribe("space_windows_change", function(env)
--     log_debug("a")
-- 	local icon_line = ""
-- 	local no_app = true
-- 	for app, count in pairs(env.info.apps) do
-- 		no_app = false
-- 		local lookup = app_icons[app]
-- 		local icon = ((lookup == nil) and app_icons["default"] or lookup)
-- 		icon_line = icon_line .. icon
-- 	end
--
-- 	if no_app then
-- 		icon_line = "—"
-- 	end
-- 	sbar.animate("tanh", 10, function()
-- 		spaces[env.info.space]:set({ label = icon_line })
-- 	end)
-- end)

space_window_observer:subscribe("display_change", function(env)
	local new_did = tonumber(env.INFO)
	local cur_display_sid = current_spaces["display-" .. new_did]
	if not cur_display_sid then
		return
	end

	if current_display then
		local prev_display_sid = current_spaces["display-" .. current_display]
		hl_space_prev(prev_display_sid)
		if previous_space and previous_space ~= cur_display_sid then
			hl_space_default(previous_space)
		end
		previous_space = prev_display_sid
	end

	current_display = new_did

	current_space = cur_display_sid
	hl_space_selected(cur_display_sid)
end)

space_window_observer:subscribe("windows_on_spaces", function(env)
	for i = 1, total_spaces, 1 do
		log_debug(string.format("windows_on_spaces: SID %s", i))
		local sid = i
		sbar.exec(
			"yabai -m query --windows --space "
				.. sid
				.. [[ | jq 'sort_by(.["stack-index"], .frame.x, .frame.y, .id) | map(.app)']],
			function(result)
                -- lazy update
				if #windows_on_spaces[sid] ~= #result then
					windows_on_spaces[sid] = result
				elseif #result ~= 0 then
					return
				end

				local icon_line = ""
				local no_app = true
				for _, app in ipairs(result) do
					no_app = false
					local lookup = app_icons[app]
					local icon = ((lookup == nil) and app_icons["default"] or lookup)
					icon_line = icon_line .. icon
				end

				if no_app then
					icon_line = "—"
				end
				sbar.animate("tanh", 10, function()
					spaces[sid]:set({ label = icon_line })
				end)
			end
		)
	end
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		label = { string = currently_on and "Spaces" or "Menus" },
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 15, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 15, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

sbar.delay(1, function()
	sbar.trigger("windows_on_spaces")
end)
