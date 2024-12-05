local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local function create_toggle_button(action, icon)
  local button = wibox.widget {
    {
      {
        id = "icon",
        image = icon,  -- Use the icon parameter here
        resize = true,
        widget = wibox.widget.imagebox,
      },
      margins = 4,  -- Adjust margins to decrease the size
      widget = wibox.container.margin,
    },
    shape = gears.shape.circle,
    bg = "#234043",
    widget = wibox.container.background,
    margins = 4,  -- Add margins to the main container
  }

  local is_toggled = false

  button:connect_signal("button::press", function()
    is_toggled = not is_toggled
    button.bg = is_toggled and "#554043" or "#234043"
    if action then
      action(is_toggled)
    end
  end)

  return button
end

return create_toggle_button