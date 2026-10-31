-- -------------------------------
-- Mason + Mason LSPConfig
-- -------------------------------
local ok_mason, mason = pcall(require, 'mason')
if not ok_mason then
  return
end

---@diagnostic disable-next-line: unused-local
local ok_mason_lsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not ok_mason_lsp then
  return
end

mason.setup {}

require('mason-lspconfig').setup {
  -- LSP servers to install automatically
  ensure_installed = {
    'lua_ls', -- Lua language server
    -- 'pylsp',  -- Python language server
    -- 'clangd',       -- C/C++ language server
    -- 'bashls', -- Bash language server
    -- 'gopls',  -- Go language server
    -- 'zls',          -- Zig language server
    -- 'ts_ls',        -- TypeScript / JavaScript language server
    -- 'html',         -- HTML language server
    -- 'cssls',        -- CSS language server
    -- 'jsonls',       -- JSON language server
    -- 'ansiblels',    -- Ansible language server
    -- 'intelephense', -- PHP language server
    -- 'yamlls',       -- YAML language server
    -- 'nil_ls',       -- Nix language server
    -- 'ruby_lsp',     -- Ruby language server
    -- 'vimls',        -- Vimscript language server
    -- 'tailwindcss',  -- Tailwind CSS language server
    -- 'jdtls',        -- Java language server
    -- 'tflint',       -- Terraform language server
    -- 'taplo',        -- TOML language server
    -- 'lemminx',      -- XML language server
    -- 'sqls',         -- SQL language server
  },

  -- Automatically install servers configured through LSP
  automatic_installation = true,
}

-- -------------------------------
-- Mason Tool Installer
-- -------------------------------
require('mason-tool-installer').setup {
  -- Formatters and external development tools to install
  ensure_installed = {
    -- 'ruff',         -- Python linter and formatter
    -- 'shfmt',    -- Shell script formatter
    -- 'nixpkgs-fmt',  -- Nix formatter
    'prettier', -- Formatter for JS, TS, HTML, CSS, JSON, YAML, etc.
    -- 'gofumpt',  -- Go script formatter
  },
}

-- -------------------------------
-- Fidget (LSP status updates)
-- -------------------------------
require('fidget').setup {
  notification = {
    window = { winblend = 0 },
  },
}
