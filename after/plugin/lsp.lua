-- -------------------------------
-- Mason + Mason LSPConfig
-- -------------------------------
local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
        return
end

---@diagnostic disable-next-line: unused-local
local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok_mason_lsp then
        return
end

mason.setup {}

require("mason-lspconfig").setup {
        ensure_installed = {
                "lua_ls",
                "pylsp",
                "clangd",
                "bashls",
                -- "gopls",
                "zls",
                "ts_ls",
                "html",
                "cssls",
                "jsonls",
                "ansiblels",
                -- "intelephense",
                -- "yamlls",
                -- "nil_ls",
                -- "ruby_lsp",
                -- "vimls",
                -- "tailwindcss",
                -- "jdtls",
                -- "tflint",
                -- "taplo",
                -- "lemminx",
                -- "sqls",
        },
        automatic_installation = true,
}

-- -------------------------------
-- Mason Tool Installer
-- -------------------------------
require("mason-tool-installer").setup {
        ensure_installed = {
                "ruff",
                "shfmt",
                -- "nixpkgs-fmt",
                "prettier",
        },
}

-- -------------------------------
-- Fidget (LSP status updates)
-- -------------------------------
require("fidget").setup {
        notification = {
                window = { winblend = 0 },
        },
}
