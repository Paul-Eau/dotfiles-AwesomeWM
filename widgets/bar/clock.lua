local wibox = require("wibox")
local gears = require("gears")

local clock_widget = wibox.widget {
  {
    {
      format = '%H',
      widget = wibox.widget.textclock,
      align = 'center',
      font = 'Bahnschrift Static 20'
    },
    {
      format = '%M',
      widget = wibox.widget.textclock,
      align = 'center',
      font = 'Bahnschrift Static 20'
    },
    layout = wibox.layout.fixed.vertical
  },
  top = 10, -- Adjust the value to add more or less space
  widget = wibox.container.margin
}

return clock_widget