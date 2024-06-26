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

local colors = {
	nord17 = "#1e2128", -- custom
	nord16 = "#272c36", -- custom
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

-- local normal = get_hl(0, {name = "Normal"})
-- normal.bg = "none"
-- -- normal.sp = "none"
-- set(0, "Normal", normal)

local normalFloat = get_hl(0, { name = "NormalFloat" })
normalFloat.bg = colors.nord17
normalFloat.sp = colors.nord4
set(0, "NormalSidebar", normalFloat)
set(0, "NormalFloat", normalFloat)

set(0, "HarpoonBorder", normalFloat)
set(1, "HarpoonWindow", normalFloat)

set(0, "NormalFloat", normalFloat)
set(0, "LazyProp", normalFloat)

local cursorLine = get_hl(0, { name = "CursorLine" })
cursorLine.bg = colors.nord0
set(0, "CursorLineSidebar", cursorLine)

set(0, "NvimTreeEmptyFolderName", { fg = colors.nord10 })
set(0, "NvimTreeIndentMarker", { fg = colors.nord0 })
set(0, "NvimTreeWindowPicker", { fg = colors.nord0, bg = colors.nord9 })
-- set_hl(0, "NvimTreeCursorLine", { bg = colors.nord0 })

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

set(0, "FloatBorder", { bg = colors.nord17 })
set(0, "LspFloatWinBorder", { bg = colors.nord17 })
set(0, "LsOutlinePreviewBorder", { bg = colors.nord17 })
set(0, "LspInfoBorder", { bg = colors.nord17 })

set(0, "TelescopeNormal", { bg = colors.nord17 })
set(0, "TelescopeBorder", { bg = colors.nord17 })

set(0, "TelescopePromptNormal", { bg = colors.nord17 })
set(0, "TelescopePromptBorder", { bg = colors.nord17 })
set(0, "TelescopePromptTitle", { fg = colors.nord4, bg = colors.nord0 })
set(0, "TelescopePromptCounter", { bg = colors.nord17 })

set(0, "TelescopeResultsTitle", { bg = colors.nord17 })
set(0, "TelescopeResultsBorder", { bg = colors.nord17 })

set(0, "TelescopePreviewTitle", { fg = colors.nord4, bg = colors.nord0 })
set(0, "TelescopePreviewBorder", { bg = colors.nord17 })

set(0, "luaParenError", { link = "none" })
set(0, "MarkdownError", { link = "None" })
set(0, "MarkdownLinkText", { sp = colors.nord14 })
set(0, "luaError", { link = "Structure" })

set(0, "EyelinerPrimary", { fg = colors.nord4, sp = colors.nord4, underline = true })
set(0, "EyelinerSecondary", { fg = colors.nord8 })

-- set_hl(0, "TelescopeMatching", { bg = colors.nord17 })

-- vim.api.nvim_set_hl(0, "FloatShadow", { fg = colors.nord0 })
-- vim.api.nvim_set_hl(0, "FloatShadowThrough", { fg = colors.nord0 })

local spellBad = get_hl(0, { name = "SpellBad" })
spellBad.sp = colors.nord11
set(0, "SpellBad", spellBad)

local spellCap = get_hl(0, { name = "SpellCap" })
spellCap.sp = colors.nord7
set(0, "SpellCap", spellCap)

local spellRare = get_hl(0, { name = "SpellRare" })
spellRare.sp = colors.nord9
set(0, "SpellRare", spellRare)

local spellLocal = get_hl(0, { name = "SpellLocal" })
spellLocal.sp = colors.nord8
set(0, "SpellLocal", spellLocal)

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
set(0, "WinSeparator", { fg = colors.nord0 })
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

return colors
