-- Try loading tokyonight-moon, fall back to habamax if it fails
local theme = 'habamax'
if pcall(vim.cmd.colorscheme, 'tokyonight-moon') then
  theme = 'tokyonight'
end

require('lualine').setup { options = { theme = theme } }

-- Make background transparent for specified highlight groups
local transparent_groups = {
  'Normal',
  'NormalFloat',
  'LineNr',
  'SignColumn',
  'Directory',
}

for _, group in ipairs(transparent_groups) do
  vim.api.nvim_set_hl(0, group, { bg = 'none' })
end
