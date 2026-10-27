local M = {}

function M.add(path)
	if vim.fn.executable("zoxide") ~= 1 then
		return
	end

	path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
	if vim.fn.isdirectory(path) ~= 1 then
		return
	end

	-- Let recording finish even when Neogurt closes its startup session.
	pcall(vim.fn.jobstart, { "zoxide", "add", "--", path }, { detach = true })
end

return M
