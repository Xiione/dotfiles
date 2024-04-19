vim.g.rustaceanvim = {
    server = {
        on_attach = require("user.lsp.handlers").on_attach
    }
}
