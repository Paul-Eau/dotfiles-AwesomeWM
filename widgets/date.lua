local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local date_widget = wibox.widget {
    format = '%Y-%m-%d',
    align = "center",  -- Centré dans son conteneur
    font = "Bahnschrift" .. " 11",  -- Utilise la police du thème avec une taille réduite
    widget = wibox.widget.textclock
}

gears.timer {
    timeout = 60,
    autostart = true,
    callback = function()
        date_widget.text = os.date('%Y-%m-%d')
    end
}

return date_widget
