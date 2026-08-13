vim.o.number = true
vim.o.relativenumber = true
vim.o.laststatus = 3
vim.o.signcolumn = 'yes'
vim.o.clipboard = 'unnamedplus'
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
local undodir = vim.fn.expand '~/.local/share/nvim/undodir'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
vim.o.undodir = undodir

vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' }

-- Cursor settings
vim.opt.guicursor =
  'n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'

-- Mise
vim.env.PATH = vim.env.HOME .. '/.local/share/mise/shims:' .. vim.env.PATH
-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin' .. (is_windows and ';' or ':') .. vim.env.PATH
