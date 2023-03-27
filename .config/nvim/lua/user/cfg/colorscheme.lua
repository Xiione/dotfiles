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

local set_hl = vim.api.nvim_set_hl
local get_hl = vim.api.nvim_get_hl_by_name
--
local normalFloat = get_hl("NormalFloat", true)
normalFloat.bg = colors.nord17
normalFloat.sp = colors.nord4
set_hl(0, "NormalSidebar", normalFloat)
set_hl(0, "NormalFloat", normalFloat)
set_hl(0, "NormalFloat", normalFloat)
set_hl(0, "LazyProp", normalFloat)

set_hl(0, "NvimTreeEmptyFolderName", { fg = colors.nord10 })
set_hl(0, "NvimTreeIndentMarker", { fg = colors.nord0 })
set_hl(0, "NvimTreeWindowPicker", { bg = colors.nord3 })
-- set_hl(0, "NvimTreeCursorLine", { bg = colors.nord0 })


set_hl(0, "QuickFixLine", { bg = colors.nord0 })
set_hl(0, "qfLineNr", { fg = colors.nord10 })


set_hl(0, "DapUIBreakpointsDisabledLine", { fg = colors.nord2 })
set_hl(0, "DapUIStepOver", { fg = colors.nord8 })
set_hl(0, "DapUIStepInto", { fg = colors.nord8 })
set_hl(0, "DapUIStepBack", { fg = colors.nord8 })
set_hl(0, "DapUIStepOut", { fg = colors.nord8 })
set_hl(0, "DapUIStop", { fg = colors.nord11 })
set_hl(0, "DapUIPlayPause", { fg = colors.nord14 })
set_hl(0, "DapUIRestart", { fg = colors.nord14 })
set_hl(0, "DapUIUnavailable", { fg = colors.nord2 })
set_hl(0, "DapUIWinSelect", { fg = colors.nord8 })

set_hl(0, "DapUIStepOverNC", { fg = colors.nord8 })
set_hl(0, "DapUIStepIntoNC", { fg = colors.nord8 })
set_hl(0, "DapUIStepBackNC", { fg = colors.nord8 })
set_hl(0, "DapUIStepOutNC", { fg = colors.nord8 })
set_hl(0, "DapUIStopNC", { fg = colors.nord11 })
set_hl(0, "DapUIPlayPauseNC", { fg = colors.nord14 })
set_hl(0, "DapUIRestartNC", { fg = colors.nord14 })
set_hl(0, "DapUIUnavailableNC", { fg = colors.nord2 })

set_hl(0, "DapBreakpointSign", { fg = colors.nord13 })


set_hl(0, "BufferLineIndicatorVisible", { fg = colors.nord17, bg = colors.nord17 })
set_hl(0, "StatusLine", { fg = colors.nord4, bg = colors.nord0 })
set_hl(0, "StatusLineNC", { fg = colors.nord0, bg = colors.nord0 })


set_hl(0, "SmoothCursor", { fg = colors.nord13 })
set_hl(0, "SmoothCursorRed", { fg = colors.nord11 })
set_hl(0, "SmoothCursorOrange", { fg = colors.nord12 })
set_hl(0, "SmoothCursorYellow", { fg = colors.nord13 })
set_hl(0, "SmoothCursorGreen", { fg = colors.nord14 })
set_hl(0, "SmoothCursorAqua", { fg = colors.nord8 })
set_hl(0, "SmoothCursorBlue", { fg = colors.nord10 })
set_hl(0, "SmoothCursorPurple", { fg = colors.nord15 })
--
set_hl(0, "FloatBorder", { bg = colors.nord17 })
set_hl(0, "LspFloatWinBorder", { bg = colors.nord17 })
set_hl(0, "LsOutlinePreviewBorder", { bg = colors.nord17 })

set_hl(0, "TelescopeNormal", { bg = colors.nord17 })
set_hl(0, "TelescopeBorder", { bg = colors.nord17 })

set_hl(0, "TelescopePromptNormal", { bg = colors.nord17 })
set_hl(0, "TelescopePromptBorder", { bg = colors.nord17 })
set_hl(0, "TelescopePromptTitle", { fg = colors.nord4, bg = colors.nord0 })
set_hl(0, "TelescopePromptCounter", { bg = colors.nord17 })

set_hl(0, "TelescopeResultsTitle", { bg = colors.nord17 })
set_hl(0, "TelescopeResultsBorder", { bg = colors.nord17 })

set_hl(0, "TelescopePreviewTitle", { fg = colors.nord4, bg = colors.nord0 })
set_hl(0, "TelescopePreviewBorder", { bg = colors.nord17 })

set_hl(0, "luaParenError", { link = "None" })
set_hl(0, "MarkdownError", { link = "None" })
set_hl(0, "MarkdownLinkText", { sp = colors.nord14 })

set_hl(0, "EyelinerPrimary", { fg = colors.nord12, underline = true })
set_hl(0, "EyelinerSecondary", { fg = colors.nord9, underline = true })

-- set_hl(0, "TelescopeMatching", { bg = colors.nord17 })

-- vim.api.nvim_set_hl(0, "FloatShadow", { fg = colors.nord0 })
-- vim.api.nvim_set_hl(0, "FloatShadowThrough", { fg = colors.nord0 })
