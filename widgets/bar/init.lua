-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require("deco.wallpaper"),
  -- taglist   = require("deco.taglist"),
  -- tasklist  = require("deco.tasklist")
}

-- local taglist_buttons  = deco.taglist()
-- local tasklist_buttons = deco.tasklist()

local _M = {}

local tags_list_widget = require("widgets.bar.tags-list")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

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

  -- -- Create a taglist widget
  -- s.mytaglist = awful.widget.taglist {
  --   screen  = s,
  --   filter  = awful.widget.taglist.filter.all,
  --   buttons = taglist_buttons
  -- }

  -- -- Create a tasklist widget
  -- s.mytasklist = awful.widget.tasklist {
  --   screen  = s,
  --   filter  = awful.widget.tasklist.filter.currenttags,
  --   buttons = tasklist_buttons
  -- }



  local clock_widget = require("widgets.bar.clock")
  local date_widget = require("widgets.bar.date")
  local tasks_list_widget = require("widgets.bar.tasks-list")
  local quick_settings_widget = require("widgets.bar.quick-settings")
  local home_button_widget = require("widgets.bar.home-button")



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
      layout = wibox.layout.flex.vertical,  -- Change this line
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
      {
        s.mylayoutbox,
        direction = 'north',
        widget = wibox.container.rotate
      },
      {
        RC.launcher,
        direction = 'north',
        widget = wibox.container.rotate
      },
    },
  }
end)