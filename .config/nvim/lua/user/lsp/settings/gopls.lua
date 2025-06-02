return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
    single_file_support = true,
    settings = {
        gopls = {
            buildFlags = {"-tags=host"},
            verboseOutput = true,
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            semanticTokens = true,
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
