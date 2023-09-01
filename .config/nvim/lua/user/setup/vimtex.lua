vim.g.maplocalleader = " "
vim.g.vimtex_mappings_prefix = "t"
vim.g.vimtex_quickfix_open_on_warning = 0

vim.g.vimtex_view_method = "sioyek"
vim.g.vimtex_format_enabled = 1
vim.g.vimtex_compiler_latexmk_engines = {
    ["_"] = "-xelatex",
    ["pdfdvi"] = "-pdfdvi",
    ["pdfps"] = "-pdfps",
    ["pdflatex"] = "-pdf",
    ["luatex"] = "-lualatex",
    ["lualatex"] = "-lualatex",
    ["xelatex"] = "-xelatex",
    ["context (pdftex)"] = "-pdf -pdflatex=texexec",
    ["context (luatex)"] = "-pdf -pdflatex=context",
    ["context (xetex)"] = "-pdf -pdflatex='texexec --xtx'",
}
