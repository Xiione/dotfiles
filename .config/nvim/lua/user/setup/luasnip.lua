local status_ok, from_vscode = pcall(require, "luasnip.loaders.from_vscode")
if not status_ok then
	return
end
from_vscode.lazy_load({ paths = { "./snippets" } })

