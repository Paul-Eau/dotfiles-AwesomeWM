local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local volume_service = require("services.volume")

local volume_slider = wibox.widget {
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

local volume_slider_container = wibox.widget {
  volume_slider,
  left = 30,  -- Set left margin
  right = 30, -- Set right margin
  widget = wibox.container.margin,
}

local current_volume = volume_service.get_volume()
if current_volume then
  volume_slider.value = current_volume
end

volume_slider:connect_signal("property::value", function(_, value)
  volume_service.set_volume(value)
end)

return volume_slider_container
