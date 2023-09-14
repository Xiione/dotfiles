local status_ok, virt_column = pcall(require, "virt-column")
if not status_ok then
	return
end

virt_column.setup_buffer({ virtcolumn = "80" })

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

-- jdtls
local home = vim.fn.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/nvim/mason/packages/jdtls/workspace/" .. project_name

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		-- 💀
		"java", -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		home
			.. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		-- 💀
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_mac_arm",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},

	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", vim.loop.cwd() }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			signatureHelp = {
				enabled = true,
				description = { enabled = false },
			},
		},
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {
			vim.fn.glob(
				home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-0.47.0.jar",
				true
			),
		},
	},

	on_attach = require("user.lsp.handlers").on_attach,
}

-- config['on_attach'] = require("utils.lsp").on_attach

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)

-- rest of the stuff
-- local tmux_send_cmd = require("utils.tmux").tmux_send_cmd
local utils = require("user.lib.utils")

local prepare_dapconfigs = function ()
    require('jdtls.dap').setup_dap_main_class_configs()
end

if vim.fn.filereadable("build.gradle") == 1 then
    local cmd_build = "./gradlew assemble"

    utils.setup_build_command("n", "<M-c>", cmd_build, prepare_dapconfigs)
    utils.setup_debug_command("n", "<M-d>", cmd_build, prepare_dapconfigs)

    -- test
    -- utils.map('n', "<leader>B", function()
    --     local cmd = "./gradlew build"
    --     utils.send_cmd(cmd)
    -- end)
else
    local cmd_build = "javac " .. utils.resolve_spaces(vim.fn.expand('%:p'))

    utils.setup_build_command("n", "<M-c>", cmd_build, prepare_dapconfigs)
    utils.setup_debug_command("n", "<M-d>", cmd_build, prepare_dapconfigs)

    -- utils.map('n', "<leader>R", function()
    --     local cmd = "java " .. utils.resolve_spaces(vim.fn.expand('%:p'))
    --     utils.send_cmd(cmd)
    -- end)
end
