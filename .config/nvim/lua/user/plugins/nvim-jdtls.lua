return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	config = function()
		local function java_21_environment()
			if vim.fn.executable("mise") ~= 1 then
				return nil
			end

			local result = vim.system({ "mise", "where", "java@temurin-21" }, { text = true }):wait()
			local java_home = result.code == 0 and vim.trim(result.stdout or "") or ""
			if java_home == "" then
				return nil
			end

			return {
				JAVA_HOME = java_home,
				PATH = vim.fs.joinpath(java_home, "bin") .. ":" .. vim.env.PATH,
			}
		end

		local cmd = { vim.fn.exepath("jdtls") }
		local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
		table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))

		local opts = {
			root_dir = function(path)
				return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
			end,
			project_name = function(root_dir)
				return root_dir and vim.fs.basename(root_dir)
			end,
			jdtls_config_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
			end,
			jdtls_workspace_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
			end,
			cmd = cmd,
			cmd_env = java_21_environment(),
			full_cmd = function(jdtls_opts)
				local fname = vim.api.nvim_buf_get_name(0)
				local root_dir = jdtls_opts.root_dir(fname)
				local project_name = jdtls_opts.project_name(root_dir)
				local full_cmd = vim.deepcopy(jdtls_opts.cmd)
				if project_name then
					vim.list_extend(full_cmd, {
						"-configuration",
						jdtls_opts.jdtls_config_dir(project_name),
						"-data",
						jdtls_opts.jdtls_workspace_dir(project_name),
					})
				end
				return full_cmd
			end,
			dap = { hotcodereplace = "auto", config_overrides = {} },
			dap_main = {},
			test = true,
			settings = {
				java = {
					inlayHints = {
						parameterNames = {
							enabled = "all",
						},
					},
				},
			},
		}

		local bundles = {}
		local mason_registry = require("mason-registry")
		if opts.dap and mason_registry.is_installed("java-debug-adapter") then
			bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*jar", false, true)
			if opts.test and mason_registry.is_installed("java-test") then
				vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))
			end
		end

		local function extend_or_override(config, custom, ...)
			if type(custom) == "function" then
				config = custom(config, ...) or config
			elseif custom then
				config = vim.tbl_deep_extend("force", config, custom)
			end
			return config
		end

		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)
			local config = extend_or_override({
				cmd = opts.full_cmd(opts),
				cmd_env = opts.cmd_env,
				root_dir = opts.root_dir(fname),
				init_options = {
					bundles = bundles,
				},
				settings = opts.settings,
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			}, opts.jdtls)

			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = attach_jdtls,
		})

		if vim.bo.filetype == "java" then
			attach_jdtls()
		end
	end,
}
