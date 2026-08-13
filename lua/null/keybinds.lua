vim.keymap.set('n', '<leader>cd', '<cmd>Ex<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<cr>')
vim.keymap.set('n', '<leader>h', vim.cmd.noh)

-- Plugin Manager Keybinds (<leader>p + something)
vim.keymap.set('n', '<leader>pu', '<cmd>PlugUpdate<CR>', { silent = true, noremap = true, desc = 'Plugin Update' })
vim.keymap.set('n', '<leader>pl', '<cmd>PlugList<CR>', { silent = true, noremap = true, desc = 'Plugin List' })
vim.keymap.set('n', '<leader>pc', '<cmd>PlugClean<CR>', { silent = true, noremap = true, desc = 'Plugin Clean' })

local function opts(desc)
  return { silent = true, noremap = true, desc = desc }
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>ss',
  [[:lua if vim.o.spell then vim.o.spell = false; print("spellcheck off") else vim.o.spell = true; print("spellcheck on") end<cr>]],
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap('n', '<leader>si', 'z=', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sa', 'zg', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>pa', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  print('file:', path)
end, { desc = 'copy full file path' })

vim.keymap.set('n', '<leader>pf', function()
  if vim.fn.executable 'prettier' == 1 then
    vim.cmd('!prettier --write ' .. vim.fn.shellescape(vim.fn.expand '%'))
  else
    ---@diagnostic disable-next-line: undefined-field
    vim.notify('prettier not found, install with: npm install -g prettier', vim.log.levels.error)
  end
end, opts 'format with prettier')
