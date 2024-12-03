-- {{{ Global Variable Definitions
-- moved here in module as local variable
-- }}}

local home = os.getenv("HOME")

local _M = {
  home = home,
  terminal = "kitty",
  file_manager = "thunar",  
  modkey = "Mod4",
  wallpaper = home .. "/.config/awesome/theme/default/background-dark.png",
}

return _M

