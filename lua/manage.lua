local M = {}

-- Plugin installation directory
local plugin_dir = vim.fn.stdpath 'data' .. '/plugins'

-- Load your plugin list from plugins/plugins_list.lua
local plugin_list = require 'plugins_list'

-- Ensure a plugin is installed
local function ensure(spec)
  local repo = type(spec) == 'string' and spec or spec[1]
  local name = repo:match '.+/(.+)$'
  local path = plugin_dir .. '/' .. name

  if not vim.uv.fs_stat(path) then
    vim.fn.mkdir(plugin_dir, 'p')
    local cmd = { 'git', 'clone', '--depth=1' }
    if type(spec) == 'table' and spec.branch then
      table.insert(cmd, '-b')
      table.insert(cmd, spec.branch)
    end
    table.insert(cmd, 'https://github.com/' .. repo)
    table.insert(cmd, path)
    print('Installing ' .. name .. '...')
    vim.fn.system(cmd)
  end

  -- Add to runtime path
  vim.opt.rtp:append(path)

  -- Add Lua path
  local lua_path = path .. '/lua'
  if vim.uv.fs_stat(lua_path) then
    package.path = package.path .. ';' .. lua_path .. '/?.lua;' .. lua_path .. '/?/init.lua'
  end
end

-- Install all plugins
function M.setup()
  for _, spec in ipairs(plugin_list) do
    ensure(spec)
  end
end

-- Update plugins
function M.update()
  local handle = vim.uv.fs_scandir(plugin_dir)
  if not handle then
    return print 'No plugins installed'
  end
  while true do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if t == 'directory' then
      print('Updating ' .. name .. '...')
      vim.fn.system { 'git', '-C', plugin_dir .. '/' .. name, 'pull', '--ff-only' }
    end
  end
  print 'Done!'
end

-- List installed plugins
function M.list()
  local handle = vim.uv.fs_scandir(plugin_dir)
  if not handle then
    return print 'No plugins installed'
  end
  while true do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if t == 'directory' then
      print(name)
    end
  end
end

-- Remove plugins not in the plugin list
function M.clean()
  local installed = {}
  local handle = vim.uv.fs_scandir(plugin_dir)
  if handle then
    while true do
      local name, t = vim.uv.fs_scandir_next(handle)
      if not name then
        break
      end
      if t == 'directory' then
        installed[name] = true
      end
    end
  end

  local wanted = {}
  for _, spec in ipairs(plugin_list) do
    local repo = type(spec) == 'string' and spec or spec[1]
    wanted[repo:match '.+/(.+)$'] = true
  end

  for name in pairs(installed) do
    if not wanted[name] then
      print('Removing ' .. name .. '...')
      vim.fn.delete(plugin_dir .. '/' .. name, 'rf')
    end
  end
  print 'Done!'
end

-- User commands
vim.api.nvim_create_user_command('PlugUpdate', M.update, {})
vim.api.nvim_create_user_command('PlugList', M.list, {})
vim.api.nvim_create_user_command('PlugClean', M.clean, {})

return M
