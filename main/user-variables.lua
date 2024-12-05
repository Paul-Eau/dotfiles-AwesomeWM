-- {{{ Global Variable Definitions
-- moved here in module as local variable
-- }}}

local home = os.getenv("HOME")

local _M = {
  home = home,
  terminal = "kitty",
  file_manager = "thunar",  
  modkey = "Mod4",
}

return _M

