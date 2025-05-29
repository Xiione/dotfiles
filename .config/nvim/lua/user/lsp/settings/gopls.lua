return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
    single_file_support = true,
    settings = {
        gopls = {
            buildFlags = {"-tags=host"},
            -- Logging settings from VSCode config
            verboseOutput = true,
            -- Additional settings that might be useful
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            -- Formatting configuration
            -- formatting = {
            --     gofumpt = false,  -- Explicitly disable gofumpt
            --     use_local_gofmt = true,     -- Use local version of gofmt (from Go installation)
            -- },
            -- Environment settings (uncomment if you need to override system env vars)
            -- env = {
            --     GOFLAGS = "-tags=host",
            --     GOPATH = vim.fn.expand("${workspaceFolder}/samsara/go"),
            --     GOROOT = vim.fn.expand("${workspaceFolder}/go"),
            --     GO111MODULE = "on",
            --     GOPRIVATE = "firmware.samsaradev.io",
            -- },
        },
    },
    flags = {
        debounce_text_changes = 150,
    },
}
