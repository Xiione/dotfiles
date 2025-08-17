local colors = require("colors")
local settings = require("settings")

local label_color = colors.white

local front_app = sbar.add("item", "front_app", {
	display = "active",
	icon = { drawing = false },
	label = {
		color = label_color,
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

front_app:subscribe("media_info_hovered", function(env)
	sbar.animate("tanh", 10, function()
		front_app:set({ label = { color = colors.with_alpha(label_color, 0.0) } })
	end)
end)

front_app:subscribe("media_info_unhovered", function(env)
	sbar.animate("tanh", 30, function()
		front_app:set({ label = { color = colors.with_alpha(label_color, 1.0) } })
	end)
end)
