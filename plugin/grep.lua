if vim.fn.executable 'rg' == 1 then
  vim.opt.grepprg = 'rg --vimgrep --smart-case --hidden'
  vim.opt.grepformat = '%f:%l:%c:%m'
else
  vim.opt.grepprg = 'grep -rnH'
  vim.opt.grepformat = '%f:%l:%m'
end

vim.keymap.set('n', '<leader>g', function()
  vim.ui.input({ prompt = 'Grep: ' }, function(pattern)
    if pattern then
      vim.cmd('silent grep! ' .. vim.fn.fnameescape(pattern))
      vim.cmd 'copen'
    end
  end)
end, { silent = true })
