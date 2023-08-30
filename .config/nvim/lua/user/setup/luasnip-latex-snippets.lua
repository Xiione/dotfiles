local status_ok, snippets = pcall(require, "luasnip-latex-snippets")
if not status_ok then
    return
end
snippets.setup()
