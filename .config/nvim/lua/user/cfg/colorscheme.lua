vim.g.nord_contrast = false
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_cursorline_transparent = false
vim.g.nord_enable_sidebar_background = false
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

local colorscheme = "nord"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

local colors = {
	-- nord0 = "#2E3440", -- i think the nord nvim theme takes all bgs with the nord0 color "none"
	nord0 = "#2E3440",
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

-- vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.nord0 })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = colors.nord10 })
vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = colors.nord1 })

vim.api.nvim_set_hl(0, "QuickFixLine", { bg = colors.nord2 })
vim.api.nvim_set_hl(0, "qfLineNr", { fg = colors.nord10 })

vim.api.nvim_set_hl(0, "DapUIBreakpointsDisabledLine", { fg = colors.nord2 })
vim.api.nvim_set_hl(0, "DapUIStepOver", { fg = colors.nord8 })
vim.api.nvim_set_hl(0, "DapUIStepInto", { fg = colors.nord8 })
vim.api.nvim_set_hl(0, "DapUIStepBack", { fg = colors.nord8 })
vim.api.nvim_set_hl(0, "DapUIStepOut", { fg = colors.nord8 })
vim.api.nvim_set_hl(0, "DapUIStop", { fg = colors.nord11 })
vim.api.nvim_set_hl(0, "DapUIPlayPause", { fg = colors.nord14 })
vim.api.nvim_set_hl(0, "DapUIRestart", { fg = colors.nord14 })
vim.api.nvim_set_hl(0, "DapUIUnavailable", { fg = colors.nord2 })

vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.nord3 })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.nord3 })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.nord3 })

vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.nord3 })
vim.api.nvim_set_hl(0, "NvimTreeWindowPicker", { bg = colors.nord3 })

-- hack fix for broken definiton hovers
-- nvm doesnt work
-- vim.api.nvim_set_hl(0, "markdownError", { bg = "none", fg = "none" })

