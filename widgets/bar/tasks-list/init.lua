-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
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
      awful.menu.client_list({ theme = { width = 550 } })
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
    buttons = tasklist_buttons,
    layout   = {
        spacing = 5,
        layout  = wibox.layout.flex.horizontal -- Changed from fixed to flex
    },
    widget_template = {
      {
        {
          {
            {
              {
                id     = 'clienticon',
                widget = awful.widget.clienticon,
              },
              margins = 5,
              widget  = wibox.container.margin
            },
            {
              id     = 'text_role',
              widget = wibox.widget.textbox,
              font   = beautiful.font, -- Ensure space between font name and size
            },
            layout = wibox.layout.fixed.horizontal,
          },
          id     = 'background_role',
          widget = wibox.container.background,
          create_callback = function(self, c, index, objects) --luacheck: no unused args
            self:get_children_by_id('clienticon')[1].client = c
          end,
          update_callback = function(self, c, index, objects) -- Ensure the callback is updated
            self:get_children_by_id('clienticon')[1].client = c
          end,
        },
        widget = wibox.container.margin,
        margins = {bottom = 5, top = 5},
      },
      widget = wibox.container.background,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 20) -- Changed radius from default to 20
      end,
    },
  }
end

awful.screen.connect_for_each_screen(function(s)
  s.mytasklist = tasklist_widget(s)
end)

return tasklist_widget