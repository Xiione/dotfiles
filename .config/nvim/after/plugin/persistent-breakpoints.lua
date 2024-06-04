local status_ok, pbreakpoints = pcall(require, "persistent-breakpoints")
if not status_ok then
	return
end

pbreakpoints.setup{
	save_dir = vim.fn.expand("~/.vim/breakpoints/"),
	load_breakpoints_event = "BufReadPost",
}
