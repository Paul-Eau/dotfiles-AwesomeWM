local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("theme.default.theme")
local beautiful = require("beautiful")

local function recolor_image(icon, color)
    return gears.color.recolor_image(icon, color)
end

-- Fonction pour récupérer la puissance du WiFi
local function get_wifi_signal(callback)
    awful.spawn.easy_async_with_shell(
        "nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d':' -f2",
        function(stdout, stderr, reason, exit_code)
            local signal = tonumber(stdout) or -1 -- Si aucun signal, retourne -1
            callback(signal)
        end
    )
end

-- Widget WiFi
local wifi_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
        resize = true,
        valign = "center",  -- Centré dans son conteneur
        halign = "center",  -- Centré dans son conteneur
        forced_height = 32, -- Set the desired height
        forced_width = 32   -- Set the desired width
    },
    layout = wibox.container.margin,
    margins = 5, -- Adjust margins to center the icon
    set_image = function(self, image)
        self:get_children_by_id("icon")[1].image = image
    end
}

local wifi_tooltip = awful.tooltip {
    objects = { wifi_widget },
    mode = "outside",
    align = "right",
    preferred_positions = { "right", "left", "top", "bottom" }
}

-- Mise à jour de l'icône en fonction du signal
local function update_wifi_widget()
    get_wifi_signal(function(signal)
        local icon
        if signal == -1 then
            icon = theme.wifi_fail
        elseif signal == 0 then
            icon = theme.wifi_0
        elseif signal > 0 and signal <= 33 then
            icon = theme.wifi_1
        elseif signal > 33 and signal <= 66 then
            icon = theme.wifi_2
        elseif signal > 66 then
            icon = theme.wifi_3
        end
        wifi_widget:set_image(recolor_image(icon, beautiful.fg_normal))
        wifi_tooltip.text = "Signal: " .. (signal == -1 and "No signal" or signal .. "%")
    end)
end

-- Actualisation périodique du widget
gears.timer {
    timeout = 10, -- Actualise toutes les 10 secondes
    autostart = true,
    callback = update_wifi_widget
}

-- Première mise à jour immédiate
update_wifi_widget()

-- Exporter le widget pour être utilisé ailleurs
return wifi_widget
