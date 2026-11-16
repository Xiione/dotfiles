-- SPDX-License-Identifier: GPL-2.0-only
-- Copyright (C) 2026 OmniNull — https://github.com/OmniNull/OmniWM

local button = require("../lib/menu-button")
local actions = require("../lib/actions")
local look = require("../lib/look")

function render(ctx: Context)
	if not ctx.data.bar.style.hidesMenuBar then
		return ui.box({ w = 0, h = 0 })
	end
	local menu = button.render(ctx, {
		symbol = "applelogo",
		action = "menu apple",
		help = omniwm.l10n("Apple Menu; right-click for OmniWM controls and menu bar items"),
	})
	menu.onRightClick = ui.popout
	return menu
end

function popout(ctx: Context)
	local width = 200
	return ui.column({
		pad = 5,
		gap = 0,
		radius = 14,
		material = "regular",
		actions.row("slider.horizontal.3", omniwm.l10n("OmniWM Controls…"), "shell menu", width),
		actions.row("menubar.rectangle", omniwm.l10n("Menu Bar Items…"), "hidden-bar panel", width),
	})
end
