local set = vim.api.nvim_set_hl
local get_hl = vim.api.nvim_get_hl
vim.g.nord_contrast = true
vim.g.nord_borders = true
vim.g.nord_disable_background = false
vim.g.nord_cursorline_transparent = false
vim.g.nord_enable_sidebar_background = true
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

local colorscheme = "nord"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

-- require("nord")

local colors = require("user.cfg.colors")

-- local normal = get_hl(0, {name = "Normal"})
-- normal.bg = "None"
-- -- normal.sp = "None"
-- set(0, "Normal", normal)

local update = function(ns_id, name, opts)
	local hl = get_hl(ns_id, { name = name })
	hl = vim.tbl_extend("force", hl, opts)
	set(ns_id, name, hl)
	return hl
end

local update_from = function(ns_id, name, from, opts)
	local hl = get_hl(ns_id, { name = from })
	hl = vim.tbl_extend("force", hl, opts)
	set(ns_id, name, hl)
	return hl
end

update(0, "Normal", { sp = "None" })
update(0, "NormalFloat", { bg = colors.nord18 })
update(0, "FloatBorder", { fg = colors.nord8, bg = colors.nord18 })
set(0, "NormalSidebar", { bg = colors.nord17 })
set(0, "HarpoonBorder", { link = "FloatBorder" })
set(1, "HarpoonWindow", { link = "NormalFloat" })
set(0, "LazyProp", { link = "NormalFloat" })

-- update_from(0, "NormalFidget", "Normal", { bg = "None" })

local cursorLineBg = colors.nord0o

update(0, "CursorLine", { bg = cursorLineBg })
update_from(0, "CursorLineSidebar", "CursorLine", { bg = colors.nord1 })
-- update_from(0, "CursorLineSign", "CursorLine", { bg = cursorLineBg })
-- update(0, "CursorLineNr", { bg = cursorLineBg })
-- update(0, "CursorLineFold", { bg = cursorLineBg })
-- update(0, "CursorLineSign", { bg = cursorLineBg })

set(0, "NvimTreeEmptyFolderName", { fg = colors.nord10 })
set(0, "NvimTreeIndentMarker", { fg = colors.nord0 })
set(0, "NvimTreeWindowPicker", { fg = colors.nord0, bg = colors.nord9 })
update(0, "NvimTreeCursorLine", { bg = cursorLineBg })

set(0, "QuickFixLine", { bg = colors.nord0 })
set(0, "qfLineNr", { fg = colors.nord10 })

set(0, "DapUIBreakpointsDisabledLine", { fg = colors.nord2 })
set(0, "DapUIStepOver", { fg = colors.nord8 })
set(0, "DapUIStepInto", { fg = colors.nord8 })
set(0, "DapUIStepBack", { fg = colors.nord8 })
set(0, "DapUIStepOut", { fg = colors.nord8 })
set(0, "DapUIStop", { fg = colors.nord11 })
set(0, "DapUIPlayPause", { fg = colors.nord14 })
set(0, "DapUIRestart", { fg = colors.nord14 })
set(0, "DapUIUnavailable", { fg = colors.nord2 })
set(0, "DapUIWinSelect", { fg = colors.nord8 })

set(0, "DapUIStepOverNC", { fg = colors.nord8 })
set(0, "DapUIStepIntoNC", { fg = colors.nord8 })
set(0, "DapUIStepBackNC", { fg = colors.nord8 })
set(0, "DapUIStepOutNC", { fg = colors.nord8 })
set(0, "DapUIStopNC", { fg = colors.nord11 })
set(0, "DapUIPlayPauseNC", { fg = colors.nord14 })
set(0, "DapUIRestartNC", { fg = colors.nord14 })
set(0, "DapUIUnavailableNC", { fg = colors.nord2 })

set(0, "DapBreakpointSign", { fg = colors.nord13 })

set(0, "BufferLineIndicatorVisible", { fg = colors.nord17, bg = colors.nord17 })
set(0, "StatusLine", { fg = colors.nord4, bg = colors.nord0 })
set(0, "StatusLineNC", { fg = colors.nord0, bg = colors.nord0 })

set(0, "SmoothCursor", { fg = colors.nord13 })
set(0, "SmoothCursorRed", { fg = colors.nord11 })
set(0, "SmoothCursorOrange", { fg = colors.nord12 })
set(0, "SmoothCursorYellow", { fg = colors.nord13 })
set(0, "SmoothCursorGreen", { fg = colors.nord14 })
set(0, "SmoothCursorAqua", { fg = colors.nord8 })
set(0, "SmoothCursorBlue", { fg = colors.nord10 })
set(0, "SmoothCursorPurple", { fg = colors.nord15 })

set(0, "SmoothCursor0", { fg = colors.nord0 })
set(0, "SmoothCursor1", { fg = colors.nord1 })
set(0, "SmoothCursor2", { fg = colors.nord2 })
set(0, "SmoothCursor3", { fg = colors.nord3 })
set(0, "SmoothCursor9", { fg = colors.nord9 })

set(0, "LspFloatWinBorder", { link = "FloatBorder" })
set(0, "LsOutlinePreviewBorder", { link = "FloatBorder" })
set(0, "LspInfoBorder", { link = "FloatBorder" })

set(0, "TelescopeNormal", { bg = colors.nord18 })
set(0, "TelescopeBorder", { link = "FloatBorder" })

set(0, "TelescopePromptNormal", { bg = colors.nord18 })
set(0, "TelescopePromptBorder", { link = "FloatBorder" })
set(0, "TelescopePromptTitle", { fg = colors.nord4, bg = colors.nord0 })
set(0, "TelescopePromptCounter", { bg = colors.nord18 })

set(0, "TelescopeResultsTitle", { bg = colors.nord18 })
set(0, "TelescopeResultsBorder", { link = "FloatBorder" })

set(0, "TelescopePreviewTitle", { fg = colors.nord4, bg = colors.nord0 })
set(0, "TelescopePreviewBorder", { link = "FloatBorder" })

set(0, "luaParenError", { link = "None" })
set(0, "MarkdownError", { link = "None" })
set(0, "MarkdownLinkText", { sp = colors.nord14 })
set(0, "luaError", { link = "Structure" })

set(0, "EyelinerPrimary", { fg = colors.nord4, sp = colors.nord4, underline = true })
set(0, "EyelinerSecondary", { fg = colors.nord8 })

-- set_hl(0, "TelescopeMatching", { bg = colors.nord17 })

-- vim.api.nvim_set_hl(0, "FloatShadow", { fg = colors.nord0 })
-- vim.api.nvim_set_hl(0, "FloatShadowThrough", { fg = colors.nord0 })

update(0, "SpellBad", { sp = colors.nord11 })
update(0, "SpellCap", { sp = colors.nord7 })
update(0, "SpellRare", { sp = colors.nord9 })
update(0, "SpellLocal", { sp = colors.nord8 })

set(0, "Quote", { fg = colors.nord4 })

set(0, "MatchParen", { fg = colors.nord4, bg = colors.nord3 })

-- gas.vim
set(0, "gasBinaryNumber", { fg = colors.nord15 })
set(0, "gasOctalNumber", { fg = colors.nord15 })
set(0, "gasDecimalNumber", { fg = colors.nord15 })
set(0, "gasHexNumber", { fg = colors.nord15 })
set(0, "gasSymbolRef", { fg = colors.nord8 })

-- semantic tokens 'fix'
local links = {
	["@lsp.type.namespace"] = "@namespace",
	["@lsp.type.type"] = "@type",
	["@lsp.type.class"] = "@type",
	["@lsp.type.enum"] = "@type",
	["@lsp.type.interface"] = "@type",
	["@lsp.type.struct"] = "@structure",
	["@lsp.type.parameter"] = "@parameter",
	["@lsp.type.variable"] = "@variable",
	["@lsp.type.property"] = "@property",
	["@lsp.type.enumMember"] = "@constant",
	["@lsp.type.function"] = "@function",
	["@lsp.type.method"] = "@method",
	["@lsp.type.macro"] = "@macro",
	["@lsp.type.decorator"] = "@function",
}
for newgroup, oldgroup in pairs(links) do
	set(0, newgroup, { link = oldgroup, default = true })
end
-- set(0, "@type", { fg = colors.nord10 })
set(0, "@namespace", { fg = colors.nord10 })

set(0, "NvimTreeGitNew", { fg = colors.nord11 })
set(0, "NvimTreeGitStaged", { fg = colors.nord14 })
set(0, "NvimTreeGitDirty", { fg = colors.nord11 })

-- changed in 0.10?
set(0, "WinSeparator", { fg = colors.nord0, bg = colors.nord0 })
set(0, "VertSplit", { fg = colors.nord0, bg = colors.nord0 })
set(0, "lualine_transparent", { fg = colors.nord0, bg = colors.nord0 })
set(0, "WinBar", { bg = colors.nord16 })
set(0, "WinBarNC", { bg = colors.nord16 })

-- for lsp_signature
set(0, "LspSignatureActiveParameter", { link = "Visual" })

-- dapui float boarder
set(0, "DapUIFloatBorder", { link = "FloatBorder" })

-- ufo
set(0, "FoldColumn", { fg = colors.nord3L })

-- cmp match colors
set(0, "CmpItemAbbr", { fg = colors.nord4 })
set(0, "CmpItemAbbrMatch", { fg = colors.nord4, sp = colors.nord4, underline = true })
set(0, "CmpItemAbbrMatchFuzzy", { fg = colors.nord8 })

-- tailwind-tools
-- this also in the tailwind-tools config itself
-- set(0, "TailwindConceal", { link = "Comment" })

-- gitsign cursorline
-- for _, name in ipairs({
-- 	"GitSignsAdd",
-- 	"GitSignsChange",
-- 	"GitSignsDelete",
-- 	"GitSignsChangedelete",
-- 	"GitSignsTopdelete",
-- 	"GitSignsUntracked",
-- }) do
-- 	update_from(0, name .. "Cul", name, { bg = cursorLineBg, link = "" })
-- end

update(0, "DiffDelete", { bg = "None" })
update(0, "DiffChange", { bg = "None" })
update(0, "DiffAdd", { bg = "None" })
update(0, "DiffText", { bg = "None" })

set(0, "CmpItemKindSupermaven", { fg = colors.nord15 })

-- also in indent_blankline.lua
set(0, "IblRainbowRed", { fg = colors.nord11 })
set(0, "IblRainbowYellow", { fg = colors.nord13 })
set(0, "IblRainbowCyan", { fg = colors.nord8 })

-- diff
set(0, "Added", { link = "DiffAdd" })
set(0, "Removed", { link = "DiffDelete" })
set(0, "Changed", { link = "DiffChange" })

-- treesittercontext
update_from(0, "TreesitterContext", "NormalFloat", { bg = colors.nord17 })
update_from(0, "TreesitterContextLineNumber", "LineNr", { bg = colors.nord17 })
update_from(0, "TreesitterContextBottom", "TreesitterContext", { fg = "None", underdouble = true, sp = colors.nord2 })
update_from(
	0,
	"TreesitterContextLineNumberBottom",
	"TreesitterContextLineNumber",
	{ fg = "None", underdouble = true, sp = colors.nord2 }
)

set(0, "AvantePromptInput", { link = "NormalFloat" })
set(0, "AvantePromptInputBorder", { link = "FloatBorder" })

set(0, "AvanteSidebarNormal", { link = "NormalSidebar" })
set(0, "AvanteSidebarWinSeparator", { link = "WinSeparator" })
update(0, "AvanteSidebarWinHorizontalSeparator", { fg = colors.nord18, bg = colors.nord18 })

set(0, "AvanteTitle", { fg = colors.nord0, bg = colors.nord14 })
set(0, "AvanteReversedTitle", { fg = colors.nord14 })
set(0, "AvanteSubtitle", { fg = colors.nord0, bg = colors.nord8 })
set(0, "AvanteReversedSubtitle", { fg = colors.nord8 })
set(0, "AvanteThirdTitle", { fg = colors.nord4, bg = colors.nord2 })
set(0, "AvanteReversedThirdTitle", { fg = colors.nord2 })
-- set(0, "AvanteSuggestion", { link = "Comment" })
-- set(0, "AvanteAnnotation", { link = "Comment" })
set(0, "AvantePopupHint", { link = "Comment" })
set(0, "AvanteInlineHint", { link = "Comment" })
set(0, "AvanteConfirmTitle", { fg = colors.nord0, bg = colors.nord11 })
set(0, "AvanteButtonDefault", { fg = colors.nord0, bg = colors.nord4 })
set(0, "AvanteButtonDefaultHover", { fg = colors.nord0, bg = colors.nord14 })
set(0, "AvanteButtonPrimary", { fg = colors.nord0, bg = colors.nord4 })
set(0, "AvanteButtonPrimaryHover", { fg = colors.nord0, bg = colors.nord8 })
set(0, "AvanteButtonDanger", { fg = colors.nord0, bg = colors.nord4 })
set(0, "AvanteButtonDangerHover", { fg = colors.nord0, bg = colors.nord11 })
-- set(0, "AvanteCommentFg", { fg_link = "Comment" })
set(0, "AvanteReversedNormal", { fg = colors.nord0, bg = colors.nord4 })
set(0, "AvanteStateSpinnerGenerating", { fg = colors.nord0, bg = colors.nord15 })
set(0, "AvanteStateSpinnerToolCalling", { fg = colors.nord0, bg = colors.nord8 })
set(0, "AvanteStateSpinnerFailed", { fg = colors.nord0, bg = colors.nord11 })
set(0, "AvanteStateSpinnerSucceeded", { fg = colors.nord0, bg = colors.nord14 })
set(0, "AvanteStateSpinnerSearching", { fg = colors.nord0, bg = colors.nord15 })
set(0, "AvanteStateSpinnerThinking", { fg = colors.nord0, bg = colors.nord15 })
set(0, "AvanteStateSpinnerCompacting", { fg = colors.nord0, bg = colors.nord15 })
set(0, "AvanteThinking", { fg = colors.nord15 })

set(0, "AvanteConflictCurrent", { bg = "#562C30", bold = false })
-- set(0,  "AvanteConflictCurrentLabel", { link = "AvanteConflictCurrent" }) -- shade_link not a valid property in set_hl
set(0, "AvanteConflictIncoming", { bg = "#314753", bold = false })
-- set(0,  "AvanteConflictIncomingLabel", { link = "AvanteConflictIncoming" }) -- shade_link not a valid property in set_hl

-- Avante ft
set(1, "Normal", { bg = colors.nord17 })
set(1, "AvanteSidebarNormal", { link = "Normal" })
-- set(1, "RenderMarkdownCode", { fg = "None", bg = colors.nord16 })
set(1, "RenderMarkdownQuote", { fg = colors.nord3L })
set(1, "@markup.quote.markdown", { fg = colors.nord10 })

-- go semantic tokens
set(0, "@lsp.type.string.go", { link = "None" })
