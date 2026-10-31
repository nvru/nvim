-- Colorscheme
local themes = {
  -- 'habamax',
  'tokyonight-moon',
  'gruber-darker',
}

local active_theme

for _, colorscheme in ipairs(themes) do
  if pcall(vim.cmd.colorscheme, colorscheme) then
    active_theme = colorscheme
    break
  end
end

-- Lualine
if active_theme == 'habamax' then
  require('lualine').setup {
    options = {
      theme = 'nightfly',
    },
  }
else
  require('lualine').setup {}
end

-- Transparent backgrounds
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
