---@diagnostic disable: deprecated
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function set_wallpaper()
  local wallpaper = beautiful.wallpaper

  if wallpaper then
    if type(wallpaper) == "function" then
      wallpaper = wallpaper()
    end
    gears.wallpaper.maximized(wallpaper, screen.primary, true, {x = -32, y = 0})
  end
end

-- Call set_wallpaper on startup
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper()
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
awful.screen.connect_for_each_screen(function(s)
    s:connect_signal("property::geometry", set_wallpaper)
end)
