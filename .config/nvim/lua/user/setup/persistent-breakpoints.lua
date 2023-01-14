local status_ok, persist_breakpoints = pcall(require, "persist_breakpoints")
if not status_ok then
	return
end

persist_breakpoints.setup{
    save_dir = vim.fn.expand("~/.vim/breakpoints/"),
	-- when to load the breakpoints? "BufReadPost" is recommanded.
	load_breakpoints_event = {"BufReadPost"},
	-- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
	perf_record = false,
}
