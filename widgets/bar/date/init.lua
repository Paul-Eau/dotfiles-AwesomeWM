local wibox = require("wibox")
local awful = require("awful")

local date_widget = wibox.widget {
  {
    {
      format = '%d-%m',
      widget = wibox.widget.textclock,
      align = 'center',
      font = 'Bahnschrift 11'
    },
    layout = wibox.layout.fixed.vertical
  },
  top = 2,  -- Adjust the value to set the desired space
  widget = wibox.container.margin
}

return date_widget