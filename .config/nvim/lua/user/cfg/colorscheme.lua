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
	define("SidebarEndOfBuffer", { fg = colors.nord17, bg = colors.nord17 })
	define("HarpoonBorder", { link = "FloatBorder" })
	define("LazyProp", { link = "NormalFloat" })

	update("CursorLine", { bg = cursorline_bg })
	update("CursorLineNr", { bg = cursorline_bg, bold = false })
	define("CursorLineSign", { link = "CursorLine" })
	define("CursorLineFold", { link = "CursorLine" })
	define("CursorLineSidebar", { link = "CursorLine" })

	define("NvimTreeNormal", { link = "NormalSidebar" })
	define("NvimTreeNormalNC", { link = "NormalSidebar" })
	define("NvimTreeWinSeparator", { link = "WinSeparator" })
	define("NvimTreeEndOfBuffer", { link = "SidebarEndOfBuffer" })
	define("NvimTreeRootFolder", { fg = colors.nord15 })
	define("NvimTreeIndentMarker", { fg = colors.nord1 })
	define("NvimTreeWindowPicker", { fg = colors.nord0, bg = colors.nord9 })
	define("NvimTreeCutHL", { fg = colors.nord11, bg = colors.nord17, bold = true })
	define("NvimTreeCopiedHL", { fg = colors.nord9, bg = colors.nord17, bold = true })
	define("NvimTreeGitStaged", { fg = colors.nord14 })
	define("NvimTreeGitDeletedIcon", { link = "NvimTreeGitDeleted" })
	define("NvimTreeGitDirtyIcon", { link = "NvimTreeGitDirty" })
	define("NvimTreeGitIgnoredIcon", { link = "NvimTreeGitIgnored" })
	define("NvimTreeGitNewIcon", { link = "NvimTreeGitNew" })
	define("NvimTreeGitStagedIcon", { link = "NvimTreeGitStaged" })

	define("QuickFixLine", { bg = colors.nord0o })
	define("QuickFixDelimiter", { fg = colors.nord3L })
	define("Search", { fg = colors.nord6, bg = colors.nord3L })
	define("IncSearch", { bg = colors.nord3L })
	define("Substitute", { fg = colors.nord0, bg = colors.nord12 })

	define("DapBreakpointSign", { fg = colors.nord11 })
	define("DapBreakpointConditionSign", { link = "DapBreakpointSign" })
	define("DapBreakpointRejectedSign", { link = "DiagnosticWarn" })
	define("DapStoppedSign", { fg = colors.nord13 })
	define("DapStoppedLine", { bg = colors.debug.stopped_bg })
	define("DapUICurrentFrameName", { fg = colors.nord13, bold = true })
	define("DapUIBreakpointsCurrentLine", { link = "DapUICurrentFrameName" })
	define("DapUIFloatBorder", { link = "FloatBorder" })

	define("BufferLineIndicatorVisible", { fg = colors.nord17, bg = colors.nord17 })
	define("StatusLine", { fg = colors.nord4, bg = colors.nord0 })
	define("StatusLineNC", { fg = colors.nord0, bg = colors.nord0 })

	define("SmoothCursorRed", { fg = colors.nord11 })
	define("SmoothCursorOrange", { fg = colors.nord12 })
	define("SmoothCursorYellow", { fg = colors.nord13 })
	define("SmoothCursor", { link = "SmoothCursorYellow" })
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

	define("luaParenError", { link = "NONE" })
	define("MarkdownError", { link = "NONE" })
	define("MarkdownLinkText", { sp = colors.nord14 })
	define("luaError", { link = "Structure" })

	define("EyelinerPrimary", { fg = colors.nord4, sp = colors.nord4, underline = true })
	define("EyelinerSecondary", { fg = colors.nord8 })

	update("SpellCap", { sp = colors.nord7 })
	update("SpellRare", { sp = colors.nord9 })
	update("SpellLocal", { sp = colors.nord8 })

	define("Quote", { fg = colors.nord4 })
	define("MatchParen", { fg = colors.nord4, bg = colors.nord3 })

	define("gasBinaryNumber", { link = "Number" })
	define("gasOctalNumber", { link = "Number" })
	define("gasDecimalNumber", { link = "Number" })
	define("gasHexNumber", { link = "Number" })
	define("gasSymbolRef", { fg = colors.nord8 })

	define("PreCondit", { fg = colors.nord13 })
	define("Debug", { fg = colors.nord11 })
	define("Underlined", { fg = colors.nord14, underline = true })
	define("Ignore", { fg = colors.nord1 })
	define("Todo", { fg = colors.nord13, italic = true })
	define("Conditional", { fg = colors.nord9, italic = true })
	define("Function", { fg = colors.nord8, italic = true })
	define("Identifier", { fg = colors.nord9, italic = true })
	define("Keyword", { fg = colors.nord9, italic = true })
	define("Repeat", { fg = colors.nord9, italic = true })
	define("String", { fg = colors.nord14, italic = true })

	define("@text.phpdoc", { link = "@comment" })
	define("@type", { link = "Type" })
	define("@type.definition", { link = "@type" })
	define("@string", { link = "String" })
	define("@function", { link = "Function" })
	define("@function.builtin", { link = "@function" })
	define("@function.call", { link = "@function" })
	define("@function.method", { link = "@function" })
	define("@function.method.call", { link = "@function" })
	define("@constructor", { link = "@function" })
	define("@variable", { fg = colors.nord4, italic = true })
	define("@variable.parameter", { fg = colors.nord10, italic = true })
	define("@variable.builtin", { fg = colors.nord9, italic = true })
	define("@variable.member", { fg = colors.nord4, italic = true })
	define("@property", { link = "@variable.member" })
	define("@module", { fg = colors.nord4, italic = true })
	define("@keyword", { link = "Keyword" })
	define("@keyword.function", { link = "@keyword" })
	define("@keyword.operator", { link = "@keyword" })
	define("@keyword.return", { link = "@keyword" })
	define("@keyword.conditional", { link = "@keyword" })
	define("@keyword.repeat", { link = "@keyword" })
	define("@keyword.import", { link = "@keyword" })
	define("@keyword.exception", { link = "@keyword" })
	define("@label", { fg = colors.nord9, italic = true })
	define("@comment.todo", { link = "Todo" })
	define("@comment.note", { link = "Todo" })
	define("@punctuation.delimiter", { fg = colors.nord9 })
	define("@punctuation.special", { fg = colors.nord6 })
	define("@attribute", { fg = colors.nord12 })
	define("@attribute.phpdoc", { link = "@attribute" })

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
	define("@lsp.type.string.go", { link = "NONE" })

	define("WinSeparator", { fg = colors.nord0, bg = colors.nord0 })
	define("VertSplit", { link = "WinSeparator" })
	define("lualine_transparent", { fg = colors.nord0, bg = colors.nord0 })
	define("DropBarBackground", { fg = colors.nord3L, bg = colors.nord18 })
	define("WinBar", { link = "DropBarBackground" })
	define("WinBarNC", { link = "DropBarBackground" })
	define("WinBarIconUIExtends", { link = "DropBarBackground" })
	define("DropBarKindFile", { fg = colors.nord4 })
	define("DropBarKindFileNC", { link = "DropBarKindFile" })
	define("DropBarModified", { fg = colors.nord14, bg = colors.nord18 })
	define("DropBarModifiedNC", { link = "DropBarModified" })
	define("DropBarIconUISeparator", { fg = colors.nord3, bg = colors.nord18 })
	define("DropBarIconUISeparatorNC", { link = "DropBarIconUISeparator" })
	define("DropBarIconUISeparatorMenu", { fg = colors.nord3 })
	define("DropBarIconUIPickPivot", { link = "NvimTreeWindowPicker" })
	define("DropBarMenuCurrentContext", { link = "CursorLine" })
	define("DropBarMenuSbar", { link = "PmenuSbar" })
	define("DropBarMenuThumb", { link = "PmenuThumb" })
	define("DropBarMenuHoverEntry", { bg = colors.nord3 })

	define("FoldColumn", { fg = colors.nord3L })

	define("CmpItemAbbr", { fg = colors.nord4 })
	define("CmpItemAbbrMatch", { fg = colors.nord4, sp = colors.nord4, underline = true })
	define("CmpItemAbbrMatchFuzzy", { fg = colors.nord8 })
	define("CmpItemKindIcon", { link = "CmpItemKind" })
	define("PmenuSbar", { bg = colors.nord2 })
	define("PmenuThumb", { bg = colors.nord3L })
	define("PmenuSel", { bg = colors.nord0 })

	define("DiffAdd", { bg = colors.diff.add_bg, sp = colors.nord14 })
	define("DiffDelete", { bg = colors.diff.delete_bg, sp = colors.nord11 })
	define("DiffChange", { bg = colors.diff.change_bg, sp = colors.nord13 })
	define("DiffText", { bg = colors.diff.change_inline_bg, sp = colors.nord13 })
	define("diffAdded", { fg = colors.nord14 })
	define("diffRemoved", { fg = colors.nord11 })
	define("diffChanged", { fg = colors.nord13 })
	define("DiffviewNormal", { link = "NormalSidebar" })
	define("DiffviewEndOfBuffer", { link = "SidebarEndOfBuffer" })
	define("DiffviewCursorLine", { link = "CursorLineSidebar" })
	define("DiffviewWinSeparator", { link = "WinSeparator" })
	define("DiffviewStatusLine", { link = "StatusLine" })
	define("DiffviewStatuslineNC", { link = "StatusLineNC" })
	define("DiffviewDim1", { link = "Comment" })
	define("DiffviewFilePanelTitle", { fg = colors.nord9 })
	define("DiffviewFilePanelRootPath", { link = "DiffviewFilePanelTitle" })
	define("DiffviewFilePanelCounter", { fg = colors.nord3L })
	define("DiffviewFilePanelSelected", { fg = colors.nord8 })
	define("DiffviewFolderSign", { fg = colors.nord3L })
	define("DiffviewHash", { fg = colors.nord3L })
	define("DiffviewReference", { fg = colors.nord15 })
	define("DiffviewCommitMerged", { fg = colors.nord3L })
	define("DiffviewCommitRemoteRef", { fg = colors.nord8 })
	define("DiffviewCommitLocalOnly", { fg = colors.nord13 })
	define("DiffviewCommitSelected", { sp = colors.nord3L })
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
	define("AvanteButtonPrimary", { link = "AvanteButtonDefault" })
	define("AvanteButtonPrimaryHover", { fg = colors.nord0, bg = colors.nord8 })
	define("AvanteButtonDanger", { link = "AvanteButtonDefault" })
	define("AvanteButtonDangerHover", { fg = colors.nord0, bg = colors.nord11 })
	define("AvanteReversedNormal", { fg = colors.nord0, bg = colors.nord4 })
	define("AvanteStateSpinnerGenerating", { fg = colors.nord0, bg = colors.nord15 })
	define("AvanteStateSpinnerToolCalling", { fg = colors.nord0, bg = colors.nord8 })
	define("AvanteStateSpinnerFailed", { fg = colors.nord0, bg = colors.nord11 })
	define("AvanteStateSpinnerSucceeded", { fg = colors.nord0, bg = colors.nord14 })
	define("AvanteStateSpinnerSearching", { link = "AvanteStateSpinnerGenerating" })
	define("AvanteStateSpinnerThinking", { link = "AvanteStateSpinnerGenerating" })
	define("AvanteStateSpinnerCompacting", { link = "AvanteStateSpinnerGenerating" })
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
