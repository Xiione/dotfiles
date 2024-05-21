local status_ok, grapple = pcall(require, "grapple")
if not status_ok then
	return
end

grapple.setup({
    win_opts = {
        border = "solid"
    }
})
