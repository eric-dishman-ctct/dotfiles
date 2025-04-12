local wezterm     = require('wezterm')
local commands    = require('commands')
local constants   = require('constants')
local keymaps     = require('keymaps')

-- This will hold the configuration.
local config      = wezterm.config_builder()
local launch_menu = {}

-- Available shells
table.insert(launch_menu, {
  label = "PowerShell",
  args = { "powershell.exe", "-NoLogo" },
})

table.insert(launch_menu, {
  label = "Pwsh",
  args = { "pwsh.exe", "-NoLogo" },
})

-- Create the launch menu
config.launch_menu = launch_menu

-- Set the default shell
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- Set key maps
config.keys = keymaps.keys

-- Set up the UI --

-- Remove full path from window title and set a custom title
---@diagnostic disable-next-line: unused-local
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  local index = string.format("%02d", tab.tab_index + 1) -- Format as 01, 02, etc.
  local title = "⚡ WɞzŦɞɾɱ - " .. index .. " ⚡" -- Add some ASCII style

  return title
end)

config.window_padding = {
  left = "1cell",
  right = "1cell",
  top = "0.0cell",
  bottom = "0.0cell",
}

-- Color scheme
config.colors = require('cyberdream')

-- Fonts
config.font = wezterm.font {
  family = 'JetBrainsMono Nerd Font',
  weight = 'DemiBold',
}
config.font_size = 14
config.line_height = 1.3

config.term = "wezterm"

-- Background
config.window_background_opacity = 1
config.window_background_image = constants.bg_image
config.win32_system_backdrop = "Tabbed"
config.window_decorations = "RESIZE"

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

-- Tab bar
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.tab_and_split_indices_are_zero_based = true
config.unzoom_on_switch_pane = true
config.debug_key_events = true

-- Custom commands
wezterm.on('augment-command-palette', function()
  return commands
end)

return config
