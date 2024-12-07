local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local slider_setup = wibox.widget {
  bar_shape           = gears.shape.rounded_bar,
  bar_height          = 8,
  bar_color           = beautiful.bg_focus,
  handle_color        = beautiful.fg_normal,
  handle_shape        = gears.shape.circle,
  handle_border_color = beautiful.border_color,
  handle_border_width = 4,
  value               = 0,
  widget              = wibox.widget.slider,
  --forced_width        = 200,  -- Set the width of the slider
  handle_width        = 24,   -- Set the width of the handle
  handle_height       = 24,   -- Set the height of the handle
  handle_margins = { -- Set the margins around the handle
    left = 0,
    right = 0,
  },
  direction           = 'east', -- Invert the direction of the slider
}

local icon = wibox.widget {
  image  = beautiful.placeholder,  -- Replace with the actual icon path or variable
  resize = true,
  valign  = "center",
  halign  = "center",
  forced_width = 32,  -- Set the width of the icon
  forced_height = 32, -- Set the height of the icon
  widget = wibox.widget.imagebox,
}

local slider = wibox.widget {
  {
    {
      icon,
      right = 8,  -- Set right margin for the icon
      widget = wibox.container.margin,
    },
    {
      slider_setup,
      right = 8,  -- Set right margin for the slider
      widget = wibox.container.margin,
    },
    layout = wibox.layout.fixed.horizontal,
  },
  left = 0,  -- Set left margin
  right = 0, -- Set right margin
  widget = wibox.container.margin,
}

return slider