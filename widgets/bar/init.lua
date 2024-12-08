local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")


local clock_widget = require("widgets.bar.clock")
local date_widget = require("widgets.bar.date")
local tasks_list_widget = require("widgets.bar.tasks-list")
local tags_list_widget = require("widgets.bar.tags-list")
local quick_settings_widget = require("widgets.bar.quick-settings")
local home_button_widget = require("widgets.bar.home-button")


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


awful.screen.connect_for_each_screen(function(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


  s.mywibox = awful.wibar({ position = "right", width = 52, screen = s })

  s.mywibox:setup {
    layout = wibox.layout.align.vertical,
    {
      layout = wibox.layout.fixed.vertical,
      {
        clock_widget,
        direction = 'north',
        widget = wibox.container.rotate
      },
      {
        widget = wibox.widget.separator,
        orientation = 'horizontal',
        forced_height = 10,
        span_ratio = 0.85,
        color = '#888888'
      },
      {
        date_widget,
        direction = 'north',
        widget = wibox.container.rotate
      },
      {
        tags_list_widget(s),
        direction = 'west',
        widget = wibox.container.rotate
      },
    },
    {
      layout = wibox.layout.flex.vertical, 
      {
        tasks_list_widget(s),
        direction = 'west',
        widget = wibox.container.rotate
      },
    },
    {
      layout = wibox.layout.fixed.vertical,
      {
        quick_settings_widget,
        direction = 'north',
        widget = wibox.container.rotate
      },
      {
        widget = wibox.widget.separator,
        orientation = 'horizontal',
        forced_height = 10,
        span_ratio = 0.85,
        color = '#888888'
      },
      {
        home_button_widget,
        direction = 'north',
        widget = wibox.container.rotate
      },
    },
  }
end)