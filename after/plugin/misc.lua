-- ================================================================================================
-- TITLE : misc.lua
-- LINKS :
--   > github : https://github.com/jiaoshijie/undotree
--   > github : https://github.com/lambdalisue/suda.vim
-- ================================================================================================

vim.keymap.set('n', '<Space>w', ':SudaWrite<CR>', { silent = true, desc = 'Write file with sudo' })
vim.keymap.set('v', '<Space>w', ':SudaWrite<CR>', { silent = true, desc = 'Read file with sudo' })
vim.keymap.set('n', '<Space>r', ':SudaRead<CR>', { silent = true, desc = 'Write file with sudo' })
vim.keymap.set('v', '<Space>r', ':SudaRead<CR>', { silent = true, desc = 'Read file with sudo' })

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
