local act = require('wezterm').action
local M = {}
-- Key maps
M.keys = {
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
    key = "9",
    mods = "ALT",
    action = act.ShowLauncherArgs({
      flags = "FUZZY|WORKSPACES",
    }),
  },
}

return M
