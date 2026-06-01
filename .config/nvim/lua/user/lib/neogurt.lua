local utils = require("user.lib.utils")

local M = {}

local function git_output(path, args)
	local cmd = { "git", "-C", path }
	vim.list_extend(cmd, args)

	local result = utils.system(cmd)
	if result == "" then
		return nil
	end

	return result
end

local function git_session_name(path)
	local root = git_output(path, { "rev-parse", "--show-toplevel" })
	if not root then
		return nil
	end

	local repo = vim.fs.basename(vim.fs.normalize(root))
	local branch = git_output(path, { "branch", "--show-current" })
	if not branch then
		local commit = git_output(path, { "rev-parse", "--short", "HEAD" })
		branch = commit and ("@" .. commit) or "HEAD"
	end

	local prefix = git_output(path, { "rev-parse", "--show-prefix" })
	local dir = prefix and prefix:gsub("/$", "") or ""
	local label = dir == "" and "." or utils.last_path_parts(dir, 2)

	return ("%s:%s %s"):format(repo, branch, label)
end

M.session_name = function(path)
	local uv = vim.uv or vim.loop
	path = vim.fs.normalize((path and path ~= "" and path) or uv.cwd())

	return git_session_name(path) or utils.parent_dir_label(path)
end

return M
