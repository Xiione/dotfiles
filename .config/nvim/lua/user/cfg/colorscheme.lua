local set = vim.api.nvim_set_hl

local colors = require("user.cfg.colors")

local function set_nord_colors(palette)
	palette.nord18 = colors.nord18
	palette.nord17 = colors.nord17
	palette.nord16 = colors.nord16
	palette.nord0o = colors.nord0o
	palette.nord0 = colors.nord0
	palette.nord1 = colors.nord1
	palette.nord2 = colors.nord2
	palette.nord3 = colors.nord3
	palette.nord3L = colors.nord3L
	palette.nord4 = colors.nord4
	palette.nord5 = colors.nord5
	palette.nord6 = colors.nord6
	palette.nord7 = colors.nord7
	palette.nord8 = colors.nord8
	palette.nord9 = colors.nord9
	palette.nord10 = colors.nord10
	palette.nord11 = colors.nord11
	palette.nord12 = colors.nord12
	palette.nord13 = colors.nord13
	palette.nord14 = colors.nord14
	palette.nord15 = colors.nord15

	if palette.polar_night then
		palette.polar_night.origin = colors.nord0
		palette.polar_night.bright = colors.nord1
		palette.polar_night.brighter = colors.nord2
		palette.polar_night.brightest = colors.nord3
	end
	if palette.snow_storm then
		palette.snow_storm.origin = colors.nord4
		palette.snow_storm.brighter = colors.nord5
		palette.snow_storm.brightest = colors.nord6
	end
	if palette.frost then
		palette.frost.polar_water = colors.nord7
		palette.frost.ice = colors.nord8
		palette.frost.artic_water = colors.nord9
		palette.frost.artic_ocean = colors.nord10
	end
	if palette.aurora then
		palette.aurora.red = colors.nord11
		palette.aurora.orange = colors.nord12
		palette.aurora.yellow = colors.nord13
		palette.aurora.green = colors.nord14
		palette.aurora.purple = colors.nord15
	end
end

local function set_nord_highlights(highlights)
	local function update(name, opts)
		highlights[name] = vim.tbl_extend("force", highlights[name] or {}, opts)
	end

	local function update_from(name, from, opts)
		highlights[name] = vim.tbl_extend("force", highlights[from] or {}, opts)
	end

	local function define(name, opts)
		highlights[name] = opts
	end

	local cursorline_bg = colors.nord0o

	update("Normal", { bg = colors.nord16, sp = "NONE" })
	define("SignColumn", { link = "Normal" })
	update("NormalFloat", { bg = colors.nord18 })
	update("FloatBorder", { fg = colors.nord8, bg = colors.nord18 })
	define("NormalSidebar", { bg = colors.nord17 })
	define("HarpoonBorder", { link = "FloatBorder" })
	define("LazyProp", { link = "NormalFloat" })

	update("CursorLine", { bg = cursorline_bg })
	update("CursorLineNr", { bg = cursorline_bg, bold = false })
	define("CursorLineSign", { link = "CursorLine" })
	update("CursorLineFold", { bg = cursorline_bg })
	define("CursorLineSidebar", { link = "CursorLine" })

	define("NvimTreeNormal", { link = "NormalSidebar" })
	define("NvimTreeNormalNC", { link = "NormalSidebar" })
	define("NvimTreeSignColumn", { link = "NormalSidebar" })
	define("NvimTreeWinSeparator", { link = "WinSeparator" })
	define("NvimTreeVertSplit", { link = "WinSeparator" })
	define("NvimTreeEndOfBuffer", { fg = colors.nord17, bg = colors.nord17 })
	define("NvimTreeRootFolder", { fg = colors.nord15 })
	define("NvimTreeFolderName", { fg = colors.nord4 })
	define("NvimTreeEmptyFolderName", { fg = colors.nord10 })
	define("NvimTreeIndentMarker", { fg = colors.nord1 })
	define("NvimTreeWindowPicker", { fg = colors.nord0, bg = colors.nord9 })
	update("NvimTreeCursorLine", { bg = cursorline_bg })
	define("NvimTreeCursorLineNr", { link = "CursorLineNr" })
	define("NvimTreeCutHL", { fg = colors.nord11, bg = colors.nord17, bold = true })
	define("NvimTreeCopiedHL", { fg = colors.nord9, bg = colors.nord17, bold = true })
	define("NvimTreeGitNew", { fg = colors.nord11 })
	define("NvimTreeGitStaged", { fg = colors.nord14 })
	define("NvimTreeGitDirty", { fg = colors.nord11 })

	define("QuickFixLine", { bg = colors.nord0o })
	define("QuickFixDelimiter", { fg = colors.nord3L })
	define("qfLineNr", { fg = colors.nord10 })
	define("Delimiter", { fg = colors.nord6 })
	define("Search", { fg = colors.nord6, bg = colors.nord3L })
	define("IncSearch", { bg = colors.nord3L })
	define("CurSearch", { bg = colors.nord3L })
	define("Substitute", { fg = colors.nord0, bg = colors.nord12 })

	define("DapUIBreakpointsDisabledLine", { fg = colors.nord2 })
	define("DapUIStepOver", { fg = colors.nord8 })
	define("DapUIStepInto", { fg = colors.nord8 })
	define("DapUIStepBack", { fg = colors.nord8 })
	define("DapUIStepOut", { fg = colors.nord8 })
	define("DapUIStop", { fg = colors.nord11 })
	define("DapUIPlayPause", { fg = colors.nord14 })
	define("DapUIRestart", { fg = colors.nord14 })
	define("DapUIUnavailable", { fg = colors.nord2 })
	define("DapUIWinSelect", { fg = colors.nord8 })
	define("DapUIStepOverNC", { fg = colors.nord8 })
	define("DapUIStepIntoNC", { fg = colors.nord8 })
	define("DapUIStepBackNC", { fg = colors.nord8 })
	define("DapUIStepOutNC", { fg = colors.nord8 })
	define("DapUIStopNC", { fg = colors.nord11 })
	define("DapUIPlayPauseNC", { fg = colors.nord14 })
	define("DapUIRestartNC", { fg = colors.nord14 })
	define("DapUIUnavailableNC", { fg = colors.nord2 })
	define("DapBreakpointSign", { fg = colors.nord13 })
	define("DapUIFloatBorder", { link = "FloatBorder" })

	define("BufferLineIndicatorVisible", { fg = colors.nord17, bg = colors.nord17 })
	define("StatusLine", { fg = colors.nord4, bg = colors.nord0 })
	define("StatusLineNC", { fg = colors.nord0, bg = colors.nord0 })

	define("SmoothCursor", { fg = colors.nord13 })
	define("SmoothCursorRed", { fg = colors.nord11 })
	define("SmoothCursorOrange", { fg = colors.nord12 })
	define("SmoothCursorYellow", { fg = colors.nord13 })
	define("SmoothCursorGreen", { fg = colors.nord14 })
	define("SmoothCursorAqua", { fg = colors.nord8 })
	define("SmoothCursorBlue", { fg = colors.nord10 })
	define("SmoothCursorPurple", { fg = colors.nord15 })
	define("SmoothCursor0", { fg = colors.nord0 })
	define("SmoothCursor1", { fg = colors.nord1 })
	define("SmoothCursor2", { fg = colors.nord2 })
	define("SmoothCursor3", { fg = colors.nord3 })
	define("SmoothCursor9", { fg = colors.nord9 })

	define("LspFloatWinBorder", { link = "FloatBorder" })
	define("LsOutlinePreviewBorder", { link = "FloatBorder" })
	define("LspInfoBorder", { link = "FloatBorder" })

	define("TelescopeNormal", { link = "NormalFloat" })
	define("TelescopeBorder", { link = "FloatBorder" })
	define("TelescopeSelection", { link = "Visual" })
	define("TelescopeMatching", { bg = colors.nord3L })
	define("TelescopePromptNormal", { link = "NormalFloat" })
	define("TelescopePromptBorder", { link = "FloatBorder" })
	define("TelescopePromptTitle", { fg = colors.nord4, bg = colors.nord0 })
	define("TelescopePromptCounter", { bg = colors.nord18 })
	define("TelescopeResultsNormal", { link = "NormalFloat" })
	define("TelescopeResultsTitle", { bg = colors.nord18 })
	define("TelescopeResultsBorder", { link = "FloatBorder" })
	define("TelescopePreviewNormal", { link = "NormalFloat" })
	define("TelescopePreviewTitle", { fg = colors.nord4, bg = colors.nord0 })
	define("TelescopePreviewBorder", { link = "FloatBorder" })

	define("luaParenError", { link = "NONE" })
	define("MarkdownError", { link = "NONE" })
	define("MarkdownLinkText", { sp = colors.nord14 })
	define("luaError", { link = "Structure" })

	define("EyelinerPrimary", { fg = colors.nord4, sp = colors.nord4, underline = true })
	define("EyelinerSecondary", { fg = colors.nord8 })

	update("SpellBad", { sp = colors.nord11 })
	update("SpellCap", { sp = colors.nord7 })
	update("SpellRare", { sp = colors.nord9 })
	update("SpellLocal", { sp = colors.nord8 })

	define("Quote", { fg = colors.nord4 })
	define("MatchParen", { fg = colors.nord4, bg = colors.nord3 })

	define("gasBinaryNumber", { fg = colors.nord15 })
	define("gasOctalNumber", { fg = colors.nord15 })
	define("gasDecimalNumber", { fg = colors.nord15 })
	define("gasHexNumber", { fg = colors.nord15 })
	define("gasSymbolRef", { fg = colors.nord8 })

	define("Type", { fg = colors.nord9 })
	define("StorageClass", { fg = colors.nord9 })
	define("Structure", { fg = colors.nord9 })
	define("Constant", { fg = colors.nord4 })
	define("Character", { fg = colors.nord14 })
	define("Number", { fg = colors.nord15 })
	define("Boolean", { fg = colors.nord9 })
	define("Float", { fg = colors.nord15 })
	define("Statement", { fg = colors.nord9 })
	define("Label", { fg = colors.nord9 })
	define("Operator", { fg = colors.nord9 })
	define("Exception", { fg = colors.nord9 })
	define("PreProc", { fg = colors.nord9 })
	define("Include", { fg = colors.nord9 })
	define("Define", { fg = colors.nord9 })
	define("Macro", { fg = colors.nord9 })
	define("Typedef", { fg = colors.nord9 })
	define("PreCondit", { fg = colors.nord13 })
	define("Special", { fg = colors.nord4 })
	define("SpecialChar", { fg = colors.nord13 })
	define("Tag", { fg = colors.nord4 })
	define("SpecialComment", { fg = colors.nord8 })
	define("Debug", { fg = colors.nord11 })
	define("Underlined", { fg = colors.nord14, underline = true })
	define("Ignore", { fg = colors.nord1 })
	define("Todo", { fg = colors.nord13, italic = true })
	define("Comment", { fg = colors.nord3L, italic = true })
	define("Conditional", { fg = colors.nord9, italic = true })
	define("Function", { fg = colors.nord8, italic = true })
	define("Identifier", { fg = colors.nord9, italic = true })
	define("Keyword", { fg = colors.nord9, italic = true })
	define("Repeat", { fg = colors.nord9, italic = true })
	define("String", { fg = colors.nord14, italic = true })

	define("@comment", { fg = colors.nord3L, italic = true })
	define("@text.phpdoc", { fg = colors.nord3L, italic = true })
	define("@type", { fg = colors.nord9 })
	define("@type.builtin", { fg = colors.nord9 })
	define("@type.definition", { fg = colors.nord9 })
	define("@type.qualifier", { fg = colors.nord9 })
	define("@keyword.storage", { fg = colors.nord9 })
	define("@boolean", { fg = colors.nord9 })
	define("@number", { fg = colors.nord15 })
	define("@number.float", { fg = colors.nord15 })
	define("@string", { fg = colors.nord14, italic = true })
	define("@character", { fg = colors.nord14 })
	define("@function", { fg = colors.nord8, italic = true })
	define("@function.builtin", { fg = colors.nord8, italic = true })
	define("@function.call", { fg = colors.nord8, italic = true })
	define("@function.method", { fg = colors.nord8, italic = true })
	define("@function.method.call", { fg = colors.nord8, italic = true })
	define("@constructor", { fg = colors.nord8, italic = true })
	define("@variable", { fg = colors.nord4, italic = true })
	define("@variable.parameter", { fg = colors.nord10, italic = true })
	define("@variable.builtin", { fg = colors.nord9, italic = true })
	define("@variable.member", { fg = colors.nord4, italic = true })
	define("@property", { fg = colors.nord4, italic = true })
	define("@constant", { fg = colors.nord4 })
	define("@module", { fg = colors.nord4, italic = true })
	define("@keyword", { fg = colors.nord9, italic = true })
	define("@keyword.function", { fg = colors.nord9, italic = true })
	define("@keyword.operator", { fg = colors.nord9, italic = true })
	define("@keyword.return", { fg = colors.nord9, italic = true })
	define("@keyword.conditional", { fg = colors.nord9, italic = true })
	define("@keyword.repeat", { fg = colors.nord9, italic = true })
	define("@keyword.import", { fg = colors.nord9, italic = true })
	define("@keyword.exception", { fg = colors.nord9, italic = true })
	define("@keyword.directive", { fg = colors.nord9 })
	define("@keyword.directive.define", { fg = colors.nord9 })
	define("@operator", { fg = colors.nord9 })
	define("@label", { fg = colors.nord9, italic = true })
	define("@function.macro", { fg = colors.nord9 })
	define("@constant.macro", { fg = colors.nord9 })
	define("@comment.todo", { fg = colors.nord13, italic = true })
	define("@comment.note", { fg = colors.nord13, italic = true })
	define("@punctuation.delimiter", { fg = colors.nord9 })
	define("@punctuation.special", { fg = colors.nord6 })
	define("@punctuation.bracket", { fg = colors.nord8 })
	define("@attribute", { fg = colors.nord12 })
	define("@attribute.phpdoc", { fg = colors.nord12 })

	-- local semantic_links = {
	-- 	["@lsp.type.namespace"] = "@namespace",
	-- 	["@lsp.type.type"] = "@type",
	-- 	["@lsp.type.class"] = "@type",
	-- 	["@lsp.type.enum"] = "@type",
	-- 	["@lsp.type.interface"] = "@type",
	-- 	["@lsp.type.struct"] = "@structure",
	-- 	["@lsp.type.parameter"] = "@parameter",
	-- 	["@lsp.type.variable"] = "@variable",
	-- 	["@lsp.type.property"] = "@property",
	-- 	["@lsp.type.enumMember"] = "@constant",
	-- 	["@lsp.type.function"] = "@function",
	-- 	["@lsp.type.method"] = "@method",
	-- 	["@lsp.type.macro"] = "@macro",
	-- 	["@lsp.type.decorator"] = "@function",
	-- }
	-- for newgroup, oldgroup in pairs(semantic_links) do
	-- 	define(newgroup, { link = oldgroup, default = true })
	-- end
	define("@namespace", { fg = colors.nord4, italic = true })
	define("@lsp.type.string.go", { link = "NONE" })

	define("WinSeparator", { fg = colors.nord0, bg = colors.nord0 })
	define("VertSplit", { fg = colors.nord0, bg = colors.nord0 })
	define("lualine_transparent", { fg = colors.nord0, bg = colors.nord0 })
	define("WinBar", { bg = colors.nord16 })
	define("WinBarNC", { bg = colors.nord16 })

	define("LspSignatureActiveParameter", { link = "Visual" })
	define("FoldColumn", { fg = colors.nord3L })

	define("CmpItemAbbr", { fg = colors.nord4 })
	define("CmpItemAbbrMatch", { fg = colors.nord4, sp = colors.nord4, underline = true })
	define("CmpItemAbbrMatchFuzzy", { fg = colors.nord8 })
	define("CmpItemKindIcon", { link = "CmpItemKind" })
	define("CmpItemKindSupermaven", { fg = colors.nord15 })
	define("PmenuSbar", { bg = colors.nord2 })
	define("PmenuThumb", { bg = colors.nord3L })

	define("DiffAdd", { bg = colors.diff.add_bg, sp = colors.nord14 })
	define("DiffDelete", { bg = colors.diff.delete_bg, sp = colors.nord11 })
	define("DiffChange", { bg = colors.diff.change_bg, sp = colors.nord13 })
	define("DiffText", { bg = colors.diff.change_inline_bg, sp = colors.nord13 })
	define("diffAdded", { fg = colors.nord14 })
	define("diffRemoved", { fg = colors.nord11 })
	define("diffChanged", { fg = colors.nord13 })
	define("DiffviewNormal", { link = "NormalSidebar" })
	define("DiffviewEndOfBuffer", { fg = colors.nord17, bg = colors.nord17 })
	define("DiffviewCursorLine", { link = "CursorLineSidebar" })
	define("DiffviewWinSeparator", { link = "WinSeparator" })
	define("DiffviewStatusLine", { link = "StatusLine" })
	define("DiffviewStatuslineNC", { link = "StatusLineNC" })
	define("DiffviewDim1", { link = "Comment" })
	define("DiffviewDiffDeleteDim", { fg = colors.diff.filler_fg, bg = colors.diff.delete_bg })
	define("DiffviewDiffCursorLine", {
		bg = colors.diff.cursorline_bg,
		sp = "NONE",
	})
	define("DiffviewDiffCursorColumn", { bg = colors.diff.cursorline_bg, sp = "NONE" })
	define("DiffviewDiffAdd", { link = "DiffAdd" })
	define("DiffviewDiffDelete", { link = "DiffDelete" })
	define("DiffviewDiffChange", { link = "DiffChange" })
	define("DiffviewDiffText", { link = "DiffText" })
	define("DiffviewDiffAddAsDelete", { bg = colors.diff.delete_bg })
	define("DiffviewDiffAddInline", { bg = colors.diff.add_inline_bg })
	define("DiffviewDiffTextInline", { bg = colors.diff.change_inline_bg })
	define("DiffviewDiffDeleteInline", { fg = colors.nord11, bg = colors.diff.delete_bg, strikethrough = true })
	define("Added", { link = "DiffAdd" })
	define("Removed", { link = "DiffDelete" })
	define("Changed", { link = "DiffChange" })

	define("IblRainbowRed", { fg = colors.nord11 })
	define("IblRainbowYellow", { fg = colors.nord13 })
	define("IblRainbowCyan", { fg = colors.nord8 })

	update_from("TreesitterContext", "NormalFloat", { bg = colors.nord17 })
	update_from("TreesitterContextLineNumber", "LineNr", { bg = colors.nord17 })
	update_from("TreesitterContextBottom", "TreesitterContext", { fg = "NONE", underdouble = true, sp = colors.nord2 })
	update_from(
		"TreesitterContextLineNumberBottom",
		"TreesitterContextLineNumber",
		{ fg = "NONE", underdouble = true, sp = colors.nord2 }
	)

	define("AvantePromptInput", { link = "NormalFloat" })
	define("AvantePromptInputBorder", { link = "FloatBorder" })
	define("AvanteSidebarNormal", { link = "NormalSidebar" })
	define("AvanteSidebarWinSeparator", { link = "WinSeparator" })
	update("AvanteSidebarWinHorizontalSeparator", { fg = colors.nord18, bg = colors.nord18 })
	define("SidekickChat", { bg = colors.nord18 })
	define("AvanteTitle", { fg = colors.nord0, bg = colors.nord14 })
	define("AvanteReversedTitle", { fg = colors.nord14 })
	define("AvanteSubtitle", { fg = colors.nord0, bg = colors.nord8 })
	define("AvanteReversedSubtitle", { fg = colors.nord8 })
	define("AvanteThirdTitle", { fg = colors.nord4, bg = colors.nord2 })
	define("AvanteReversedThirdTitle", { fg = colors.nord2 })
	define("AvantePopupHint", { link = "Comment" })
	define("AvanteInlineHint", { link = "Comment" })
	define("AvanteConfirmTitle", { fg = colors.nord0, bg = colors.nord11 })
	define("AvanteButtonDefault", { fg = colors.nord0, bg = colors.nord4 })
	define("AvanteButtonDefaultHover", { fg = colors.nord0, bg = colors.nord14 })
	define("AvanteButtonPrimary", { fg = colors.nord0, bg = colors.nord4 })
	define("AvanteButtonPrimaryHover", { fg = colors.nord0, bg = colors.nord8 })
	define("AvanteButtonDanger", { fg = colors.nord0, bg = colors.nord4 })
	define("AvanteButtonDangerHover", { fg = colors.nord0, bg = colors.nord11 })
	define("AvanteReversedNormal", { fg = colors.nord0, bg = colors.nord4 })
	define("AvanteStateSpinnerGenerating", { fg = colors.nord0, bg = colors.nord15 })
	define("AvanteStateSpinnerToolCalling", { fg = colors.nord0, bg = colors.nord8 })
	define("AvanteStateSpinnerFailed", { fg = colors.nord0, bg = colors.nord11 })
	define("AvanteStateSpinnerSucceeded", { fg = colors.nord0, bg = colors.nord14 })
	define("AvanteStateSpinnerSearching", { fg = colors.nord0, bg = colors.nord15 })
	define("AvanteStateSpinnerThinking", { fg = colors.nord0, bg = colors.nord15 })
	define("AvanteStateSpinnerCompacting", { fg = colors.nord0, bg = colors.nord15 })
	define("AvanteThinking", { fg = colors.nord15 })
	define("AvanteConflictCurrent", { bg = "#562C30", bold = false })
	define("AvanteConflictIncoming", { bg = "#314753", bold = false })
end

local status_ok, nord = pcall(require, "nord")
if not status_ok then
	return
end

nord.setup({
	transparent = false,
	terminal_colors = true,
	diff = { mode = "bg" },
	borders = true,
	errors = { mode = "bg" },
	styles = {
		comments = { italic = true },
	},
	on_colors = set_nord_colors,
	on_highlights = set_nord_highlights,
})

local colorscheme_ok, _ = pcall(vim.cmd.colorscheme, "nord")
if not colorscheme_ok then
	return
end

-- Keep filetype-local Avante/Harpoon windows in the current namespace.
set(1, "HarpoonWindow", { link = "NormalFloat" })
set(1, "Normal", { bg = colors.nord17 })
set(1, "AvanteSidebarNormal", { link = "Normal" })
set(1, "RenderMarkdownQuote", { fg = colors.nord3L })
set(1, "@markup.quote.markdown", { fg = colors.nord10 })
