local wezterm            = require('wezterm')
local commands           = require('commands')
local constants          = require('constants')
local keymaps            = require('keymaps')
local status             = require('right_status')
local act                = wezterm.action
local mux                = wezterm.mux

-- This will hold the configuration.
local config             = wezterm.config_builder()

-- If you're running on Windows, it's often helpful to explicitly set the
-- default program to Powershell 7.x if it's not your system default.
-- You might need to adjust the path if pwsh.exe is not in your PATH.
config.default_prog      = { 'pwsh.exe', '-NoLog' }

-- Define the workspaces you want to create
local workspaces         = {
	{ name = 'Setup',              cwd = wezterm.home_dir },
	{ name = 'Configuration',      cwd = wezterm.home_dir .. '/AppData/Local/MiniNvim' },
	{ name = 'MATLAB',             cwd = 'D:/source/MATLAB' },
	{ name = 'OrgMode',            cwd = wezterm.home_dir .. '/OrgFiles' },
	{ name = 'Plugin Development', cwd = 'D:/source/nvim_plugins' },
	{ name = 'Oxidizer',           cwd = 'D:/source/rust_projects' },
	{ name = 'GNC',                cwd = 'D:/source/GNCPlugins' }
}

-- Set the default workspace name
config.default_workspace = 'Setup'

-- This event fires when the GUI first starts up
wezterm.on('gui-startup', function(cmd)
	-- Check if any windows already exist. If they do, it means we're likely
	-- connecting to an existing session, so we don't want to create new
	-- windows and interfere. We'll just ensure the 'Setup' workspace
	-- exists and is active.
	local all_windows = mux.all_windows()
	if #all_windows > 0 then
		local setup_exists = false
		for _, win in ipairs(all_windows) do
			if win:get_workspace() == 'Setup' then
				setup_exists = true
				break
			end
		end
		-- If 'Setup' doesn't exist for some reason, create it.
		if not setup_exists then
			local setup_win = mux.spawn_window({ workspace = 'Setup', cwd = wezterm.home_dir })
			setup_win:spawn_tab({ cwd = wezterm.home_dir })
		end
		-- Always switch to the Setup workspace on startup if windows exist
		mux.set_active_workspace('Setup')
		return
	end

	-- If no windows exist, this is likely the first launch.
	-- Let's create our desired workspaces.
	local setup_window = nil

	for _, ws in ipairs(workspaces) do
		local win = mux.spawn_window({
			workspace = ws.name,
			cwd = ws.cwd,
		})
		-- Keep track of the 'Setup' window
		if ws.name == 'Setup' then
			setup_window = win
		end
	end

	-- If the Setup window was created (it should have been),
	-- spawn an additional tab in it.
	if setup_window then
		setup_window:spawn_tab({ cwd = wezterm.home_dir })
	end

	-- Explicitly set the active workspace to 'Setup'.
	-- This ensures that 'Setup' is the focused window when Wezterm opens.
	mux.set_active_workspace('Setup')
end)

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

-- Set key maps
config.keys = keymaps.keys

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")


-- Color scheme
-- config.colors = require('cyberdream')
config.color_scheme = "Eldritch"
config.force_reverse_video_cursor = true

-- tabline.get_config()
-- tabline.apply_to_config(config)
tabline.setup({
	options = {
		theme = 'Eldritch',
	},
	sections = {
		tabline_a = { ' ' },
		tabline_b = { ' ' },
		tabline_c = { ' ' },
		tab_active = {
			'index',
			{ 'parent', padding = 0 },
			'/',
			{ 'cwd',    padding = { left = 0, right = 1 } },
			{ 'zoomed', padding = 0 },
		},
		tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
		tabline_x = { ' ' },
		tabline_y = { ' ' },
		tabline_z = { 'workspace' },
	},
})
-- Set up the UI --

-- Remove full path from window title and set a custom title
---@diagnostic disable-next-line: unused-local
-- wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
--   local index = string.format("%02d", tab.tab_index + 1) -- Format as 01, 02, etc.
--   local title = "⚡ WɞzŦɞɾɱ - " .. index .. " ⚡" -- Add some ASCII style
--
--   return title
-- end)

-- config.window_padding = {
--   left = "1cell",
--   right = "1cell",
--   top = "0.0cell",
--   bottom = "0.0cell",
-- }

-- Fonts
-- config.font = wezterm.font("JetBrainsMono Nerd Font Mono", {weight="Medium", stretch="Normal", style="Normal"})
config.font_size = 15
config.line_height = 1
config.custom_block_glyphs = false
config.anti_alias_custom_block_glyphs = false

-- config.term = "wezterm"
config.term = "wezterm"

-- Background
config.window_background_opacity = 1
-- config.window_background_image = constants.bg_image
config.win32_system_backdrop = "Tabbed"
config.window_decorations = "RESIZE"

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

-- Tab bar
config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
-- config.tab_and_split_indices_are_zero_based = true
-- config.unzoom_on_switch_pane = true
config.debug_key_events = false

local function basename(s)
	return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
--   local palette = config.resolved_palette.tab_bar
--   local colors = {
--     bg = palette.background,
--     tab = tab.is_active and palette.active_tab.bg_color or palette.inactive_tab.bg_color,
--     fg = tab.is_active and palette.active_tab.fg_color or palette.inactive_tab.fg_color,
--   }
-- 	local LIGHTHOUSE_WHITE = "#ebfafa"
--
--   local pane = tab.active_pane
--   local title = basename(pane.foreground_process_name)
--   final_title = title.gsub(title,'.exe','')
--   return {
-- 		--   { Background = { Color = colors.bg } },
-- 		--   { Foreground = { Color = colors.tab } },
-- 		-- { Text = wezterm.nerdfonts.ple_left_half_circle_thick },
--     -- { Text = wezterm.nerdfonts.ple_lower_right_triangle },
--     { Background = { Color = colors.bg } },
--     { Foreground = { Color = LIGHTHOUSE_WHITE } },
--     { Text = ' ' .. final_title .. ' ' },
--     { Background = { Color = colors.bg } },
--     { Foreground = { Color = colors.tab } },
-- 		{ Text = wezterm.nerdfonts.ple_right_half_circle_thick },
--     -- { Background = { Color = colors.tab } },
--     -- { Foreground = { Color = colors.bg } },
--     -- { Text = wezterm.nerdfonts.ple_upper_right_triangle },
--   }
-- end)

-- wezterm.on('update-status',status.workspace)
-- wezterm.on('update-status',status.directory(window,tab.active_pane))
-- wezterm.on('update-status', function(window)
--
-- local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
--
-- local color_scheme = window:effective_config().resolved_palette
-- local bg = color_scheme.background
-- local LOVECRAFT_PURPLE = "#a48cf2"
-- local WATERY_TOMB_BLUE = "#04d1f9"
-- local LIGHTHOUSE_WHITE = "#ebfafa"
-- local fg = color_scheme.foreground
--
-- -- Workspace label
-- window:set_right_status(wezterm.format({
--     { Background = { Color = bg } },
--     { Foreground = { Color = LOVECRAFT_PURPLE } },
-- 		{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
--     -- Then we draw our text
--     -- { Background = { Color = LOVECRAFT_PURPLE } },
--     { Foreground = { Color = LIGHTHOUSE_WHITE } },
--     { Text = ' ' .. window:active_workspace() .. ' ' },
-- 		-- { Background = { Color = 'none' } },
-- 		--   { Foreground  = { Color = LOVECRAFT_PURPLE } },
-- 		-- { Text = wezterm.nerdfonts.ple_right_half_circle_thick },
-- }))
-- end)
--
-- -- Custom commands
wezterm.on('augment-command-palette', function()
	return commands
end)

wezterm.on('user-var-changed', function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while (number_value > 0) do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
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
