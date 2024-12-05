-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
local wibox = require("wibox")


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal(
          "request::activate",
          "tasklist",
          {raise = true}
        )
      end
    end),
    awful.button({ }, 2, function (c)
      c:kill()
    end),
    awful.button({ }, 3, function()
      awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
    end)
  )




local function tasklist_widget(s)
  -- Create a tasklist widget
  return awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }
end

awful.screen.connect_for_each_screen(function(s)
  s.mytasklist = tasklist_widget(s)
end)



return tasklist_widget