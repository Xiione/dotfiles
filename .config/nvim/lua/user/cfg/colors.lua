local function hex_to_rgb(hex)
	return {
		tonumber(hex:sub(2, 3), 16) / 255,
		tonumber(hex:sub(4, 5), 16) / 255,
		tonumber(hex:sub(6, 7), 16) / 255,
	}
end

local function to_linear(channel)
	if channel <= 0.04045 then
		return channel / 12.92
	end

	return ((channel + 0.055) / 1.055) ^ 2.4
end

local function from_linear(channel)
	if channel <= 0.0031308 then
		return channel * 12.92
	end

	return (1.055 * (channel ^ (1 / 2.4))) - 0.055
end

local function overlay(fg, bg, alpha)
	local fg_rgb = hex_to_rgb(fg)
	local bg_rgb = hex_to_rgb(bg)
	local channels = {}

	for i = 1, 3 do
		local fg_linear = to_linear(fg_rgb[i])
		local bg_linear = to_linear(bg_rgb[i])
		local mixed = (fg_linear * alpha) + (bg_linear * (1 - alpha))
		channels[i] = math.floor((from_linear(mixed) * 255) + 0.5)
	end

	return string.format("#%02X%02X%02X", channels[1], channels[2], channels[3])
end

local palette = {
	nord18 = "#191D24", -- custom
	nord17 = "#1E222B", -- custom
	nord16 = "#232731", -- custom
	nord0o = "#2A2F3A",
	nord0 = "#2E3440",
	-- nord0o = "#2E3441", -- i think the nord nvim theme takes all bgs with the nord0 color "none"
	nord1 = "#3B4252",
	nord2 = "#434C5E",
	nord3 = "#4C566A",
	nord3L = "#616E88",
	nord4 = "#D8DEE9",
	nord5 = "#E5E9F0",
	nord6 = "#ECEFF4",
	nord7 = "#8FBCBB",
	nord8 = "#88C0D0",
	nord9 = "#81A1C1",
	nord10 = "#5E81AC",
	nord11 = "#BF616A",
	nord12 = "#D08770",
	nord13 = "#EBCB8B",
	nord14 = "#A3BE8C",
	nord15 = "#B48EAD",
}

palette.diff = {
	add_bg = overlay(palette.nord14, palette.nord16, 0.08),
	delete_bg = overlay(palette.nord11, palette.nord16, 0.08),
	change_bg = overlay(palette.nord13, palette.nord16, 0.08),
	add_inline_bg = overlay(palette.nord14, palette.nord16, 0.16),
	change_inline_bg = overlay(palette.nord13, palette.nord16, 0.16),
	cursorline_bg = "#313743",
	cursorline_sp = "#616E88",
	filler_fg = overlay(palette.nord11, palette.nord16, 0.45),
}

palette.debug = {
	stopped_bg = overlay(palette.nord13, palette.nord16, 0.12),
}

return palette
