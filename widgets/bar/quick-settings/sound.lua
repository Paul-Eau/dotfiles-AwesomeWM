local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local volume_service = require("services.volume")  -- Add this line


-- Create the sound widget
local volume_widget = wibox.widget {
    {
        widget = wibox.container.margin,
        margins = 6,
        {
            widget = wibox.container.place,
            {
                widget = wibox.widget.imagebox,
                id = "icon",
                halign = "center",
                valign = "center",
                image = beautiful.placeholder,
                resize = true,
            },
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Update the sound widget and tooltip
local function update_volume_widget(data)
    if data then
        local icon = volume_service.get_volume_icon(data.volume, data.muted)  -- Modify this line
        local imagebox = volume_widget:get_children_by_id("icon")[1]

        if imagebox then
            local new_image = gears.color.recolor_image(icon, beautiful.fg_normal)
            if new_image ~= imagebox.image then
                imagebox.image = nil
                imagebox.image = new_image
            end
        end

    end
end

-- Connect to the volume::update signal
awesome.connect_signal("volume::update", update_volume_widget)

-- Start watching the volume service

-- Return the widget
return volume_widget
