local theme = {
	nord18 = 0xff191D24, -- #191D24 custom
	nord17 = 0xff1E2128, -- #1E2128 custom
	nord16 = 0xff222630, -- #222630 custom
	nord0o = 0xff2a2f3a, -- #2a2f3a
	nord0 = 0xff2E3440, -- #2E3440
	nord1 = 0xff3B4252, -- #3B4252
	nord2 = 0xff434C5E, -- #434C5E
	nord3 = 0xff4C566A, -- #4C566A
	nord3L = 0xff616E88, -- #616E88
	nord4 = 0xffD8DEE9, -- #D8DEE9
	nord5 = 0xffE5E9F0, -- #E5E9F0
	nord6 = 0xffECEFF4, -- #ECEFF4
	nord7 = 0xff8FBCBB, -- #8FBCBB
	nord8 = 0xff88C0D0, -- #88C0D0
	nord9 = 0xff81A1C1, -- #81A1C1
	nord10 = 0xff5E81AC, -- #5E81AC
	nord11 = 0xffBF616A, -- #BF616A
	nord12 = 0xffD08770, -- #D08770
	nord13 = 0xffEBCB8B, -- #EBCB8B
	nord14 = 0xffA3BE8C, -- #A3BE8C
	nord15 = 0xffB48EAD, -- #B48EAD
}

return {
	black = theme.nord16,
	white = theme.nord4,
	red = theme.nord11,
	green = theme.nord14,
	blue = theme.nord10,
	yellow = theme.nord13,
	orange = theme.nord12,
	magenta = theme.nord15,
	grey = theme.nord1,
	light_blue = theme.nord9,
	light_grey = theme.nord2,
	lighter_grey = theme.nord3,
	lightest_grey = theme.nord3L,
	purple = theme.nord15,
	cyan = theme.nord7,
	transparent = 0x00000000,

	bar = {
		bg = theme.nord18,
		border = theme.nord16,
	},
	popup = {
		bg = theme.nord16,
		border = theme.nord0,
	},
	bg1 = theme.nord16,
	bg2 = theme.nord0,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
