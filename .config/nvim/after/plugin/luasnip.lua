local status_ok, from_vscode = pcall(require, "luasnip.loaders.from_vscode")
if not status_ok then
	return
end

from_vscode.lazy_load({ paths = { "./snippets" } })

local status_ok_ls, config = pcall(require, "luasnip.config")
if not status_ok_ls then
	return
end

config.setup({ enable_autosnippets = true })
