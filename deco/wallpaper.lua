---@diagnostic disable: deprecated
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function set_wallpaper()
  -- Wallpaper
  local wallpaper
  if beautiful.current_scheme == "dark" and beautiful.wallpaper_dark then
    wallpaper = beautiful.wallpaper_dark
  elseif beautiful.current_scheme == "light" and beautiful.wallpaper_light then
    wallpaper = beautiful.wallpaper_light
  end

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
screen.connect_signal("property::geometry", set_wallpaper)
