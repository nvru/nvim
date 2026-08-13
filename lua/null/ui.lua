if not pcall(vim.cmd.colorscheme, 'catppuccin') then
  vim.cmd.colorscheme 'habamax'

  vim.api.nvim_set_hl(0, 'StatusLine', {
    bg = '#181825', -- Catppuccin Mantle
    fg = '#cdd6f4', -- Catppuccin Text
  })

  vim.api.nvim_set_hl(0, 'StatusLineNC', {
    bg = '#11111b', -- Catppuccin Crust
    fg = '#6c7086', -- Catppuccin Overlay0
  })
end

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
