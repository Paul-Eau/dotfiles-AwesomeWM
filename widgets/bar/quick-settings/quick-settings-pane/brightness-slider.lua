local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local brightness_service = require("services.brightness")

local brightness_slider = wibox.widget {
  bar_shape           = gears.shape.rounded_bar,
  bar_height          = 8,
  bar_color           = beautiful.bg_focus,
  handle_color        = beautiful.fg_normal,
  handle_shape        = gears.shape.circle,
  handle_border_color = beautiful.border_color,
  handle_border_width = 4,
  value               = 0,
  widget              = wibox.widget.slider,
  forced_width        = 200,  -- Set the width of the slider
  handle_width        = 24,   -- Set the width of the handle
  handle_height       = 24,   -- Set the height of the handle
  handle_margins      = 2,    -- Set the margins around the handle
  direction           = 'east', -- Invert the direction of the slider
}

local brightness_slider_container = wibox.widget {
  brightness_slider,
  left = 30,  -- Set left margin
  right = 30, -- Set right margin
  widget = wibox.container.margin,
}

local current_brightness = brightness_service.get_brightness()
if current_brightness then
  brightness_slider.value = current_brightness
end

brightness_slider:connect_signal("property::value", function(_, value)
  brightness_service.set_brightness(value)
end)

return brightness_slider_container