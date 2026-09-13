local M = {}

-- Automatically resolves to ~/.cache/nvim/auto_format_state.json on Unix systems
local state_file = vim.fn.stdpath 'cache' .. '/auto_format_state.json'

local function load_state()
  local file = io.open(state_file, 'r')
  if not file then
    return true
  end
  local content = file:read '*a'
  file:close()

  if content == 'false' then
    return false
  end
  return true
end

local function save_state(enabled)
  local file = io.open(state_file, 'w')
  if file then
    file:write(tostring(enabled))
    file:close()
  end
end

M.format_enabled = load_state()

M.priority = 'lsp'

M.formatters = {
  lua = 'stylua -',

  javascript = 'prettier --stdin-filepath %',
  javascriptreact = 'prettier --stdin-filepath %',
  typescript = 'prettier --stdin-filepath %',
  typescriptreact = 'prettier --stdin-filepath %',

  json = 'prettier --stdin-filepath %',
  jsonc = 'prettier --stdin-filepath %',

  css = 'prettier --stdin-filepath %',
  scss = 'prettier --stdin-filepath %',
  less = 'prettier --stdin-filepath %',

  html = 'prettier --stdin-filepath %',
  vue = 'prettier --stdin-filepath %',
  svelte = 'prettier --stdin-filepath %',

  markdown = 'prettier --stdin-filepath %',
  mdx = 'prettier --stdin-filepath %',

  yaml = 'prettier --stdin-filepath %',
  graphql = 'prettier --stdin-filepath %',
  astro = 'prettier --stdin-filepath %',

  sh = 'shfmt -',
  bash = 'shfmt -',
  zig = 'zig fmt --stdin',
  python = 'ruff format --stdin-filename %',
  go = 'gofmt',

  -- C, C++, and Obj-C formatting via clang-format
  c = 'clang-format',
  cpp = 'clang-format',
  objc = 'clang-format',
  objcpp = 'clang-format',
  cuda = 'clang-format',

  -- Rust formatting
  rust = 'rustfmt',

  -- OCaml formatting
  ocaml = 'ocamlformat -',
  reason = 'refmt',

  -- PHP formatting
  php = 'php-cs-fixer fix --quiet --stdin',

  -- Java formatting
  java = 'google-java-format -',

  -- SQL formatting
  sql = 'sql-formatter',

  -- TOML formatting
  toml = 'taplo fmt -',

  -- Nix formatting
  nix = 'nixpkgs-fmt',
}

local function formatter_available(cmd)
  local executable = cmd:match '^%S+'
  return executable ~= nil and vim.fn.executable(executable) == 1
end

-- Keymap to toggle auto-formatting on/off globally (persisted)
vim.keymap.set('n', '<leader>ll', function()
  M.format_enabled = not M.format_enabled
  save_state(M.format_enabled)

  vim.notify('Auto format: ' .. (M.format_enabled and 'ON' or 'OFF'), vim.log.levels.INFO, { title = 'Formatter' })
end, { desc = 'Toggle auto format' })

-- Toggle formatter priority: LSP first or external tool first
vim.keymap.set('n', '<leader>lp', function()
  M.priority = M.priority == 'lsp' and 'tool' or 'lsp'
  vim.notify('Format priority: ' .. M.priority, vim.log.levels.INFO, { title = 'Formatter' })
end, { desc = 'Toggle format priority (lsp/tool)' })

local function run_tool(bufnr, ft)
  local cmd = M.formatters[ft]

  if cmd and formatter_available(cmd) then
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname == '' then
      return false
    end

    local resolved = cmd:gsub('%%', vim.fn.shellescape(bufname))
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, '\n')
    local output = vim.fn.system(resolved, input)

    if vim.v.shell_error ~= 0 then
      vim.notify('Formatter failed: ' .. cmd, vim.log.levels.ERROR, { title = 'Formatter' })
      return false
    end

    local formatted = vim.split(output, '\n', { plain = true })

    if formatted[#formatted] == '' then
      table.remove(formatted)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
    return true
  end

  return false
end

local function run_lsp(bufnr)
  local clients = vim.lsp.get_clients {
    bufnr = bufnr,
  }

  for _, client in ipairs(clients) do
    if client:supports_method 'textDocument/formatting' then
      vim.lsp.buf.format {
        bufnr = bufnr,
        async = false,
        filter = function(c)
          return c.id == client.id
        end,
      }
      return true
    end
  end

  return false
end

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    -- Check module-level persistent state, global override, or buffer-local override if present
    if not M.format_enabled then
      return
    end
    if vim.g.autoformat_enabled == false then
      return
    end
    if vim.b[args.buf].autoformat_enabled == false then
      return
    end

    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype

    if M.priority == 'lsp' then
      if not run_lsp(bufnr) then
        run_tool(bufnr, ft)
      end
    else
      if not run_tool(bufnr, ft) then
        run_lsp(bufnr)
      end
    end
  end,
})

return M
