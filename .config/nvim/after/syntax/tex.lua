if not vim.b.vimtex_syntax or vim.g.vimtex_syntax_enabled == 0 then
	return
end

-- VimTeX's custom command options only support braced arguments. Extend the
-- existing style groups so they can also match one bare letter or digit.
for _, style in ipairs({ "Bold", "Ital", "Both" }) do
	vim.cmd("syntax match texStyle" .. style .. " /[0-9A-Za-z]/ contained")
	vim.cmd("syntax match texMathStyle" .. style .. " /[0-9A-Za-z]/ contained")
end

-- Also recognize adjacent digits, which VimTeX's command word boundary excludes.
local conceal_styles = vim.g.vimtex_syntax_conceal.styles
local conceal = (conceal_styles == 1 or conceal_styles == true) and " conceal" or ""
local italic_commands = [[\%(emph\|textit\|textsl\)]]
-- Keep VimTeX's rule priority for bold and italic commands inside styled text.
for _, rule in ipairs({
	{ "texCmdStyleBoldItal", italic_commands, "texStyleBoth" },
	{ "texCmdStyleItalBold", "textbf", "texStyleBoth" },
	{ "texCmdStyleBold", "textbf", "texStyleBold" },
	{ "texCmdStyleItal", italic_commands, "texStyleItal" },
}) do
	local command_group, pattern, argument_group = unpack(rule)
	vim.cmd(([[syntax match %s /\\%s\ze[0-9]/ nextgroup=%s%s]]):format(command_group, pattern, argument_group, conceal))
end

for _, rule in ipairs({
	{ "Bold", [[\%(bm\|mathbf\)]] },
	{ "Ital", "mathit" },
	{ "Both", "mathbfit" },
}) do
	local style, command = unpack(rule)
	vim.cmd(
		([[syntax match texMathCmdStyle%s /\\%s\ze[0-9]/ contained nextgroup=texMathStyle%s%s]]):format(
			style,
			command,
			style,
			conceal
		)
	)
end
