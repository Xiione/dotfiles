local status_ok, navic = pcall(require, "nvim-navic")
if not status_ok then
	return
end

-- navic.setup({
--     -- hack to get rid of stupid tailwind classes after html document symbols
--     format_text = function (text)
--         return text:match("(.+#?.*)%.?.*")
--     end
-- })
