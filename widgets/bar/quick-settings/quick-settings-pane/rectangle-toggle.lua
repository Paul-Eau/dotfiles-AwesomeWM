local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local function create_rectanglular_toggle_button(action, icon, left_text, right_icon, margins)
  -- Debug print to verify the icon path

  local button = wibox.widget {
    {
      {
        {
          {
            id = "icon",
            image = gears.color.recolor_image(icon or beautiful.wifi_0, beautiful.fg_normal),  -- Use the icon parameter
            resize = true,
            halign = "center",
            valign = "center",
            forced_height = 24,  -- Set the height of the icon
            forced_width = 24,   -- Set the width of the icon
            widget = wibox.widget.imagebox,
          },
          left = margins,  -- Add left margin
          right = margins, -- Add right margin
          widget = wibox.container.margin,
        },
        {
          id = "left_text",
          text = left_text,
          widget = wibox.widget.textbox,
        },
        {
          {
            id = "right_icon",
            image = gears.color.recolor_image(right_icon or beautiful.wifi_0, beautiful.fg_normal),  -- Use beautiful.chevron_right as an image
            resize = true,
            halign = "center",
            valign = "center",
            --forced_height = 32,  -- Set the height of the icon
            --forced_width = 32,   -- Set the width of the icon
            widget = wibox.widget.imagebox,
          },
          right = 4,  -- Add right margin
          widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
      },
      margins = 8,  -- Adjust margins to decrease the size
      widget = wibox.container.margin,
      forced_height = 50,  -- Augmenter la hauteur des boutons
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 6)  -- Use rounded rectangle shape with corner radius 6
    end,
    bg = "#234043",
    widget = wibox.container.background,
    forced_height = 50,  -- Augmenter la hauteur des boutons
    margins = 4,  -- Add margins to the main container
  }

  local is_toggled = false

  button:connect_signal("button::press", function()
    is_toggled = not is_toggled
    button.bg = is_toggled and "#554043" or "#234043"
    button:get_children_by_id("icon")[1].image = gears.color.recolor_image(icon or beautiful.wifi_0, is_toggled and "#ffFF00" or beautiful.fg_normal)  -- Change icon color on toggle
    if action then
      action(is_toggled)
    end
  end)

  return button
end

return create_rectanglular_toggle_button