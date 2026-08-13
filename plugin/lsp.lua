-- ================================================================================================
-- TITLE : lsp.lua
-- ABOUT : Eager LSP configuration for Neovim, including nvim-lspconfig, mason, fidget, and keymaps.
-- LINKS :
--   > github : https://github.com/neovim/nvim-lspconfig
-- ================================================================================================

-- LSP config
vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- Diagnostics
local diagnostic_signs = { Error = '✘', Warn = '▲', Hint = '⚑', Info = '»' }
vim.diagnostic.config {
  virtual_text = { prefix = '●', spacing = 4 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    header = '',
    prefix = '',
    focusable = false,
    style = 'minimal',
  },
}

-- LSP Attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('MyLsp', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local bufnr = ev.buf
    local opts = { buffer = bufnr, silent = true }

    -- LSP Keymaps
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>gS', function()
      vim.cmd 'vsplit'
      vim.lsp.buf.definition()
    end, opts)

    vim.keymap.set('n', '<leader>fi', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code action' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set('n', '<leader>D', function()
    --   vim.diagnostic.open_float { scope = 'line' }
    -- end, opts)
    -- vim.keymap.set('n', '<leader>d', function()
    --   vim.diagnostic.open_float { scope = 'cursor' }
    -- end, opts)
    vim.keymap.set('n', '<leader>nd', function()
      vim.diagnostic.jump { count = 1 }
    end, opts)
    vim.keymap.set('n', '<leader>pd', function()
      vim.diagnostic.jump { count = -1 }
    end, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  end,
})

-- LSP SERVERS CONFIGURATION
local caps = require('cmp_nvim_lsp').default_capabilities()

-- Lua
vim.lsp.config('lua_ls', {
  capabilities = caps, -- Integrates LSP capabilities with Neovim (completion, signature help, etc.)
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT', -- Tell the server to use LuaJIT (used by Neovim)
      },
      diagnostics = {
        globals = { 'vim' }, -- Recognize 'vim' as a global variable to avoid undefined warnings
        disable = { 'missing-fields' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true), -- Make server aware of Neovim runtime files
        checkThirdParty = false, -- Disable prompt for third-party library checks
      },
      telemetry = {
        enable = false, -- Disable telemetry for privacy
      },
      completion = {
        callSnippet = 'Replace', -- Provide snippet-style completions for functions
      },
      hint = {
        enable = true, -- Show inlay hints (like parameter names, return types)
      },
      format = {
        enable = true,
      },
    },
  },
})

-- ocaml
vim.lsp.config('ocamllsp', {
  cmd = { 'ocamllsp' },
  capabilities = caps,
  filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason' },
  root_dir = function(fname)
    return vim.fs.root(fname, { '*.opam', 'dune-project', 'dune-workspace', '.git' })
  end,
})

-- Shell
vim.lsp.config('bashls', {
  capabilities = caps,
  filetypes = { 'bash', 'sh', 'zsh' },
})

--  Python
vim.lsp.config('pyright', {
  capabilities = caps,
  filetypes = { 'python' },
  settings = {
    pyright = {
      disableOrganizeImports = false,
      analysis = {
        useLibraryCodeForTypes = true,
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        autoImportCompletions = true,
      },
    },
  },
})

vim.lsp.config('ruff', {
  default_config = {
    filetypes = { 'python' },
    single_file_support = true,
  },
  init_options = {
    settings = {
      logLevel = 'info',
    },
  },
})

vim.lsp.config['serve_d'] = {
  cmd = { 'serve-d' },
  filetypes = { 'd' },
  root_markers = { 'dub.sdl', 'dub.json', '.git' },
  capabilities = caps,
}

vim.lsp.config['c3lsp'] = {
  cmd = { 'c3-lsp' },
  filetypes = { 'c3' },
  root_markers = { 'project.json', '.git' },
  capabilities = caps,
}

-- TypeScript / JS
vim.lsp.config['ts_ls'] = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  capabilities = caps,
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
}

vim.lsp.config('solidity', {
  capabilities = caps,
  single_file_support = true,
  cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
  filetypes = { 'solidity' },
  settings = { rootMarkers = { '.git/' } },
})

vim.lsp.config['cssls'] = {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  capabilities = caps,
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}

-- JSON
vim.lsp.config['jsonls'] = {
  filetypes = { 'json', 'jsonc' },
  capabilities = caps,
}

-- PHP
vim.lsp.config['phpls'] = {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  capabilities = caps,
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000, -- default 5MB
      },
    },
  },
}
-- Tailwind
vim.lsp.config['tailwindcss'] = {
  capabilities = caps,
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'heex',
  },
}

-- Go
vim.lsp.config('gopls', {
  capabilities = caps, -- Integrates LSP capabilities with Neovim (e.g., completion)
  settings = {
    gopls = {
      gofumpt = true, -- Use gofumpt instead of gofmt for stricter and uniform formatting
      hints = {
        assignVariableTypes = true, -- Show variable types when assigning
        compositeLiteralFields = true, -- Show field names when creating struct literals
        compositeLiteralTypes = true, -- Show struct type when creating literals
        constantValues = true, -- Show constant values directly in the code
        functionTypeParameters = true, -- Show types of function/generic parameters
        parameterNames = true, -- Show parameter names in function calls
        rangeVariableTypes = true, -- Show variable types in range loops
      },
      completeUnimported = true, -- Auto-completion for unimported packages + auto-import
      usePlaceholders = true, -- Use placeholders for missing function parameters/values
      analyses = {
        unusedparams = true, -- Warn about unused function parameters
        shadow = true, -- Warn when a variable shadows another one (common bug)
        unusedwrite = true, -- Warn when values are written but never used
      },
    },
  },
})

-- Nix LSP (nil)
vim.lsp.config['nil_ls'] = {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', 'default.nix', '.git' },
  capabilities = caps,
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'nixpkgs-fmt' },
        -- command = { "alejandra" },
      },
    },
  },
}
-- Zig
vim.lsp.config['zls'] = {
  cmd = { 'zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'zls.json', 'build.zig', '.git' },
  capabilities = caps,
  settings = {
    zls = {
      -- enable_build_on_save = true,
      build_on_save_step = 'install',
      warn_style = true,
      enable_snippets = true,
      enable_inlay_hints = true,
    },
  },
}

-- Rust
vim.lsp.config('rust_analyzer', {
  capabilities = caps,
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
    },
  },
})

-- Haskell
vim.lsp.config['hls'] = {
  cmd = { 'haskell-language-server-wrapper', '--lsp' },
  filetypes = { 'haskell', 'lhaskell' },
  root_markers = { 'stack.yaml', 'cabal.project', 'package.yaml', '*.cabal', 'hie.yaml', '.git' },
  capabilities = caps,
  settings = {
    haskell = {
      formattingProvider = 'fourmolu',
      plugin = {
        semanticTokens = { globalOn = false },
      },
    },
  },
}

-- Yaml
vim.lsp.config('yamlls', {
  capabilities = caps,
  settings = {
    yaml = {
      schemas = {
        ['https://json.schemastore.org/composer.json'] = 'composer.json',
        ['https://json.schemastore.org/docker-compose.json'] = 'docker-compose*.yml',
      },
      validate = true,
      format = {
        enable = true,
      },
    },
  },
  filetypes = { 'yaml' },
})

-- C / C++
vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--completion-style=detailed',
    '--fallback-style=GNU',
    '--query-driver=/nix/store/*-gcc-*/bin/gcc*,/nix/store/*-clang-*/bin/clang*,/run/current-system/sw/bin/cc*',
  },

  filetypes = {
    'c',
    'cpp',
    'objc',
    'objcpp',
  },

  root_markers = {
    'compile_commands.json',
    '.clangd',
    'configure.ac',
    'Makefile',
    '.git',
  },

  capabilities = caps,
  initialization_options = {
    fallbackFlags = { '-xc-header' },
  },
  init_options = {},
})

vim.lsp.config('ruby_lsp', {
  capabilities = caps,
  filetypes = { 'ruby' },
  root_markers = { '.git', 'Gemfile' },
})

vim.lsp.config['templ'] = {
  cmd = { 'templ', 'lsp' },
  filetypes = { 'templ' },
  root_markers = { 'go.mod', '.git' },
  capabilities = caps,
}
vim.lsp.config('prettierd', {
  cmd = { 'prettierd', '--stdio' },

  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'css',
    'scss',
    'less',
    'html',
    'json',
    'yaml',
    'markdown',
  },

  root_markers = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.js',
    'package.json',
    '.git',
  },

  capabilities = caps,
})

-- Other LSP Configurations
vim.lsp.config('lemminx', { capabilities = caps })
vim.lsp.config('asm_lsp', { capabilities = caps })
vim.lsp.config('jdtls', { capabilities = caps })
vim.lsp.config('html', { capabilities = caps })
vim.lsp.config('tflint', { capabilities = caps })
vim.lsp.config('vimscript', { capabilities = caps })
vim.lsp.config('taplo', { capabilities = caps })
vim.lsp.config('dockerls', { capabilities = caps })
vim.lsp.config('sqls', { capabilities = caps })

---@diagnostic disable-next-line: invisible
for name, _ in pairs(vim.lsp.config._configs) do
  if name ~= '*' then
    vim.lsp.enable(name)
  end
end
