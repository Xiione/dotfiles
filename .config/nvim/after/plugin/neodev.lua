local status_ok, neodev = pcall(require, "neodev")
if not status_ok then
	return
end

require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})
