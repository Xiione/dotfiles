local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
	return
end

ufo.setup({
    open_fold_hl_timeout = 0
})
