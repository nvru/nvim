-- ================================================================================================
-- TITLE : gitsigns.lua
-- LINKS :
--   > github : https://github.com/lewis6991/gitsigns.nvim
-- ================================================================================================

-- Load gitsigns safely
local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  vim.notify('gitsigns.nvim not found!', vim.log.levels.WARN)
  return
end

-- Setup
gitsigns.setup {
  signs = {
    add = { text = '▐' },
    change = { text = '▐' },
    delete = { text = '▐' },
    topdelete = { text = '◦' },
    changedelete = { text = '●' },
    untracked = { text = '○' },
  },
  signcolumn = true,
  current_line_blame = false,
}

-- Keymaps
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, opts)
vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, opts)
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, opts)
vim.keymap.set('n', '<leader>hb', function()
  gitsigns.blame_line { full = true }
end, opts)
vim.keymap.set('n', '<leader>hB', gitsigns.toggle_current_line_blame, opts)
vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, opts)
