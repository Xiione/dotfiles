local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

sbar.add("event", "brew_update")

local keepass = sbar.add("alias", "KeePassXC,Item-0", {
	display = 1,
	position = "e",
	padding_left = -3,
	padding_right = -2,
	icon = { drawing = false },
	label = { drawing = false },
	width = "dynamic",
	click_script = [[
        osascript -e 'tell application "System Events" to tell process "KeePassXC"
            click menu bar item 1 of menu bar 2
            click menu item 2 of menu 1 of menu bar item 1 of menu bar 2
        end tell'
    ]],
})

local github = sbar.add("item", "widgets.status_icons.github", {
	display = 1,
	position = "e",
	padding_left = 0,
	padding_right = 6,
	icon = {
		string = icons.bell,
		font = {
			style = settings.font.style_map["Bold"],
			size = 15.0,
		},
		color = colors.blue,
	},
	label = {
		string = "?",
		color = colors.white,
	},
	update_freq = 60,
})

local brew = sbar.add("item", "widgets.status_icons.brew", {
	display = 1,
	position = "e",
	padding_left = 0,
	padding_right = 6,
	icon = {
		string = "􀐛",
		color = colors.white,
	},
	label = {
		string = "?",
		color = colors.white,
	},
	update_freq = 180,
})

local tailscale = sbar.add("alias", "Tailscale,Item-0", {
	display = 1,
	position = "e",
	padding_left = 0,
	padding_right = 0,
	icon = { drawing = false },
	label = { drawing = false },
	width = "dynamic",
})

-- Create the bracket with popup configuration
local status_bracket = sbar.add("bracket", "widgets.status_icons.bracket", {
	"widgets.status_icons.brew",
	"KeePassXC,Item-0",
	"widgets.status_icons.github",
	"Tailscale,Item-0",
}, {
	display = 1,
	background = {
		color = colors.bg1,
		height = 26,
		corner_radius = 6,
		border_width = 2,
		border_color = colors.bg2,
	},
	popup = { align = "center", height = 30 },
})

local function hide_gh_details()
	status_bracket:set({ popup = { drawing = false } })
end

-- Helper function to create notification items
local function create_notification_item(notification, counter)
	local title = notification.subject.title:gsub("^'", ""):gsub("'$", "")
	local repo = notification.repository.name:gsub("^'", ""):gsub("'$", "")
	local type = notification.subject.type:gsub("^'", ""):gsub("'$", "")
	local url = notification.subject.url

	local color = colors.blue
	local icon = "􀍷" -- Default to issue icon

	if type == "Issue" then
		color = colors.green
		icon = "􀍷"
	elseif type == "Discussion" then
		color = colors.white
		icon = "􀒤"
	elseif type == "PullRequest" then
		color = colors.magenta
		icon = "􀙡"
	elseif type == "Commit" then
		color = colors.white
		icon = "􀡚"
	end

	-- Check for important notifications
	if title:match("deprecat") or title:match("break") or title:match("broke") then
		color = colors.red
		icon = "􀁞"
	end

	local item_name = "widgets.status_icons.github.notification." .. counter
	local notification_item = sbar.add("item", item_name, {
		drawing = true,
		position = "popup." .. status_bracket.name,
		icon = {
			string = icon .. " " .. repo .. ":",
			color = color,
			padding_left = 6,
		},
		label = {
			string = title,
			padding_right = 6,
		},
		background = {
			drawing = false,
			border_width = 0,
			color = colors.grey,
			height = 22,
		},
	})

	-- Add hover effect
	notification_item:subscribe("mouse.entered", function()
		notification_item:set({
			background = {
				drawing = true,
			},
		})
	end)

	notification_item:subscribe("mouse.exited", function()
		notification_item:set({
			background = {
				drawing = false,
			},
		})
	end)

	-- Add click handler to open notification
	notification_item:subscribe("mouse.clicked", function()
		sbar.exec(string.format('open "%s"', url or "https://github.com/notifications"))
		hide_gh_details()
	end)

	return notification_item
end

local function toggle_gh_details()
	local bracket_query = status_bracket:query()
	local should_draw = true

	if bracket_query and bracket_query.popup and bracket_query.popup.drawing then
		should_draw = bracket_query.popup.drawing == "off"
	end

	if should_draw then
		sbar.exec("sketchybar --remove '/widgets.status_icons.github.notification.*/'")

		sbar.exec("gh api notifications", function(result)
			status_bracket:set({ popup = { drawing = true } })
			local notifications = result or {}
			for i, notification in ipairs(notifications) do
				create_notification_item(notification, i)
			end
			if #notifications == 0 then
				sbar.add("item", "widgets.status_icons.github.notification.none", {
					position = "popup." .. status_bracket.name,
					icon = {
						string = "Note:",
						color = colors.lighter_grey,
					},
					label = { string = "No new notifications" },
				})
			end
		end)
	else
		hide_gh_details()
	end
end

local function update_github()
	sbar.exec("gh api notifications", function(result)
		if not result then
			return
		end

		local count = #result
		local color = colors.blue
		local icon = icons.bell

		if count > 0 then
			icon = icons.bell_dot
			for _, notification in ipairs(result) do
				if notification.subject and notification.subject.title then
					if
						notification.subject.title:match("deprecat")
						or notification.subject.title:match("break")
						or notification.subject.title:match("broke")
					then
						color = colors.red
						break
					end
				end
			end
		end

		github:set({
			icon = {
				string = icon,
				color = color,
			},
			label = { string = tostring(count) },
		})
	end)
end

local function update_brew()
	sbar.exec("brew outdated | wc -l | tr -d ' '", function(count)
		if not count then
			return
		end

		count = tonumber(count:match("%d+"))
		local color = colors.green
		local display = "􀆅" -- Checkmark for no updates

		if count and count > 0 then
			display = tostring(count)
			if count >= 30 then
				color = colors.orange
			elseif count >= 10 then
				color = colors.yellow
			else
				color = colors.white
			end
		end

		brew:set({
			icon = { color = color },
			label = { string = display },
		})
	end)
end

-- Set up event handlers
github:subscribe("mouse.clicked", function(env)
	if env.MODIFIER == "shift" then
		sbar.exec('open "https://github.com/notifications"')
	else
		toggle_gh_details()
	end
end)
status_bracket:subscribe("mouse.exited.global", hide_gh_details)
github:subscribe("routine", update_github)
brew:subscribe("routine", update_brew)
brew:subscribe("brew_update", update_brew)

-- Initial updates
update_github()
update_brew()
