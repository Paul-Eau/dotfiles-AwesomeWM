RC = {} -- global namespace, on top before require any modules
RC.vars = require("main.user-variables")

home = RC.vars.home

pcall(require, "luarocks.loader")
require("main.error-handling")

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")


require("globals")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(home .. "/.config/awesome/theme/theme.lua")
beautiful.wallpaper = RC.vars.wallpaper


modkey = RC.vars.modkey


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
menubar.utils.terminal = RC.vars.terminal

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
require("deco.windows-borders")

local brightness_slider = require("widgets.bar.quick-settings.quick-settings-pane.brightness-slider")
local brightness_service = require("services.brightness")

awesome.connect_signal("brightness::current", function(brightness)
    brightness_slider.value = brightness
end)

brightness_service.watch()




