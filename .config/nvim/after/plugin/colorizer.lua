local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
	return
end

colorizer.setup({
    conf = { names = false },
    sh = { names = false },
    lua = { names = false }
})
