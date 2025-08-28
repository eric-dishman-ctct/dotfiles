local act = require('wezterm').action
local M = {}
-- Key maps
M.keys = {
	 {
		key = 'f',
		mods = 'CTRL',
		action = act.SendKey {
				key = 'f',
				mods = 'CTRL'
		},
},
		{
		key = 'b',
		mods = 'CTRL',
		action = act.SendKey {
		key = 'b',
		mods = 'CTRL',
	},
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},

	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		mods = "CTRL|ALT|SHIFT",
		key = "l",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "CTRL|ALT|SHIFT",
		key = "j",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "CTRL|SHIFT",
		key = "g",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = act.QuitApplication
	},
	{
		key = "9",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{
		key = 'PageUp',
		mods = 'SHIFT',
		action = act.ScrollByPage(-1)
	},
	{
		key = 'PageDown',
		mods = 'SHIFT',
		action = act.ScrollByPage(1)
	},
	{
		key = 'Enter',
		mods = 'SHIFT',
		action = act.SendString '\x1b[13;2u'
	},
	{
		key = 'V',
		mods = 'CTRL',
		action = act.PasteFrom 'Clipboard',
	},
	{
	key = 'Enter',
	mods = 'CTRL',
	action = act.SendString('\x1b[13;5u')
	},
}

return M
