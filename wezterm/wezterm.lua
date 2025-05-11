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
-- config.colors = require('cyberdream')
config.color_scheme = "Eldritch"
config.force_reverse_video_cursor = true

-- Fonts
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", {weight="Medium", stretch="Normal", style="Normal"})
config.font_size = 14
config.line_height = 1.33

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
config.use_fancy_tab_bar = false
-- config.tab_and_split_indices_are_zero_based = true
-- config.unzoom_on_switch_pane = true
config.debug_key_events = false

local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local palette = config.resolved_palette.tab_bar
  local colors = {
    bg = palette.background,
    tab = tab.is_active and palette.active_tab.bg_color or palette.inactive_tab.bg_color,
    fg = tab.is_active and palette.active_tab.fg_color or palette.inactive_tab.fg_color,
  }

  local pane = tab.active_pane
  local title = basename(pane.foreground_process_name)
  final_title = title.gsub(title,'.exe','')
  return {
    { Background = { Color = colors.bg } },
    { Foreground = { Color = colors.tab } },
    { Text = wezterm.nerdfonts.ple_lower_right_triangle },
    { Background = { Color = colors.tab } },
    { Foreground = { Color = colors.fg } },
    { Text = ' ' .. final_title .. ' ' },
    { Background = { Color = colors.tab } },
    { Foreground = { Color = colors.bg } },
    { Text = wezterm.nerdfonts.ple_upper_right_triangle },
  }
end)

-- Custom commands
wezterm.on('augment-command-palette', function()
  return commands
end)

return config


-------------------------------------------------------------------------------
-- SOME STUFF I USED EARLIER
-------------------------------------------------------------------------------
-- wezterm.on(
--   'format-tab-title',
--   function(tab, tabs, panes, config, hover, max_width)
--
-- 		local pane = tab.active_pane
--     local title = basename(pane.foreground_process_name)
--
--     if tab.is_active then
--       return {
--         { Background = { Color = "#50fa7b" } },
--         { Text = ' ' .. title .. ' ' },
--       }
--     end
--     local has_unseen_output = false
--     for _, pane in ipairs(tab.panes) do
--       if pane.has_unseen_output then
--         has_unseen_output = true
--         break
--       end
--     end
--     if has_unseen_output then
--       return {
--         { Background = { Color = "#8BE9FD" } },
--         { Text = ' ' .. title .. ' ' },
--       }
--     end
--     return tab.active_pane.title
--   end
-- )
-- 
-- FONTS
-- config.font = wezterm.font("JetBrainsMono Nerd Font Mono", {weight="Medium", stretch="Normal", style="Italic"})
-- config.font = wezterm.font("JetBrainsMono Nerd Font Mono", {weight="Bold", stretch="Normal", style="Normal"})
-- config.font = wezterm.font("ShureTechMono Nerd Font Mono", {weight="Regular", stretch="Normal", style="Normal"})
-- config.font = wezterm.font("ProFontWindows Nerd Font Mono", {weight="Regular", stretch="Normal", style="Normal"})
-- config.font = wezterm.font("SpaceMono Nerd Font Mono", {weight="Regular", stretch="Normal", style="Normal"})
