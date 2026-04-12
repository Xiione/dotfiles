local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end
local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

virt_column.setup_buffer(0, { virtcolumn = "80" })

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

local term = require("user.lib.term")

local prepare_dapconfigs = function ()
    require('jdtls.dap').setup_dap_main_class_configs()
end

if vim.fn.filereadable("build.gradle") == 1 then
    local cmd_build = "./gradlew build"

    term.set_build_cmd("<M-b>", cmd_build)
    term.set_debug_cmd("<M-d>", cmd_build, function ()
        prepare_dapconfigs()
        dap.continue()
    end)
end
