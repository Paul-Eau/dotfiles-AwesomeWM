RC = {} -- global namespace, on top before require any modules
--RC.vars = require("main.user-variables")


pcall(require, "luarocks.loader")
require("main.error-handling")

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")



-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme/theme.lua")


local main = {
  layouts = require("main.layouts"),
  tags    = require("main.tags"),
  menu    = require("main.menu"),
  rules   = require("main.rules"),
}

local binding = {
  globalbuttons = require("binding.globalbuttons"),
  clientbuttons = require("binding.clientbuttons"),
  globalkeys    = require("binding.globalkeys"),
  bindtotags    = require("binding.bindtotags"),
  clientkeys    = require("binding.clientkeys")
}

RC.layouts = main.layouts()
RC.tags = main.tags()
RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys
-- a variable needed in statusbar (helper)
RC.launcher = awful.widget.launcher(
  { image = beautiful.awesome_icon, menu = RC.mainmenu }
)

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = "alacritty"

awful.layout.layouts = RC.layouts


-- Set root
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)



awful.rules.rules = main.rules(
  binding.clientkeys(),
  binding.clientbuttons()
)

require("widgets.bar")
require("main.signals")
require("deco.rounded-corners")
--require("deco.windows-borders")

require("services.wifi")
require("services.battery")




require("widgets.osd.volume")
require("widgets.osd.brightness")

require("deco.wallpaper")

-- ...existing code...



--    require("widgets.launcher")




