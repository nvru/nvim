vim.keymap.set('n', '<leader>d', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    return vim.cmd.cclose()
  end

  if not pcall(vim.diagnostic.setqflist) then
    vim.notify('No diagnostics found', vim.log.levels.INFO, { title = 'Quickfix' })
  end
end, { silent = true, desc = 'Toggle diagnostics quickfix' })
