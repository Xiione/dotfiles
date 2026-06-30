return {
	"lervag/vimtex",
	ft = "tex",
	init = function()
		vim.g.vimtex_mappings_prefix = "t"
		vim.g.vimtex_quickfix_open_on_warning = 0
		if vim.fn.has("mac") == 1 then
			vim.g.vimtex_view_method = "sioyek"
		elseif vim.fn.executable("zathura") == 1 then
			vim.g.vimtex_view_method = "zathura"
		else
			vim.g.vimtex_view_enabled = 0
		end
		vim.g.vimtex_format_enabled = 1
		vim.g.vimtex_compiler_latexmk_engines = {
			["_"] = "-lualatex",
			pdfdvi = "-pdfdvi",
			pdfps = "-pdfps",
			pdflatex = "-pdf",
			luatex = "-lualatex",
			lualatex = "-lualatex",
			xelatex = "-xelatex",
			["context (pdftex)"] = "-pdf -pdflatex=texexec",
			["context (luatex)"] = "-pdf -pdflatex=context",
			["context (xetex)"] = "-pdf -pdflatex='texexec --xtx'",
		}
	end,
}
