local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local battery_service = require("services.battery")

-- Créer le widget batterie
local battery_widget = wibox.widget {
    {

            widget = wibox.container.margin,
            margins = 2, -- Ajouter des marges pour centrer l'icône
            {
                widget = wibox.container.place,
                {
                    widget = wibox.widget.imagebox,
                    id = "icon",
                    halign = "center",
                    valign = "center",
                    image = beautiful.placeholder, -- Icône par défaut
                    resize = true,
                    forced_width = 32, -- Réduire la largeur de l'icône
                    forced_height = 32, -- Réduire la hauteur de l'icône
                },
        },
    },
    layout = wibox.layout.fixed.vertical,
}

-- Créer un tooltip pour afficher l'état de la batterie
local battery_tooltip = awful.tooltip {
    objects = { battery_widget },
    text = "Chargement des données...",
    timeout = 1,
    align = "left",
    mode = "outside",
    preferred_positions = { "bottom" }
}

-- Met à jour le widget batterie et le tooltip
local function update_battery_widget(data)
    if data then
        if data.bat_level then
            local icon = battery_service.get_battery_icon(data.bat_level, data.is_adapter_connected)
            local imagebox = battery_widget:get_children_by_id("icon")[1]

            if imagebox then
                local new_image = gears.color.recolor_image(icon, beautiful.fg_normal)
                if new_image ~= imagebox.image then
                    imagebox.image = nil
                    imagebox.image = new_image
                end
            end

            battery_tooltip.text = string.format(
                "Battery remaining: %.0f%% %s",
                data.bat_level,
                data.is_adapter_connected and "(charging)" or "(not charging)"
            )
        else
            battery_tooltip.text = "Unable to calculate battery level."
        end
    end
end

-- Connect to the battery::update signal
awesome.connect_signal("battery::update", update_battery_widget)


return battery_widget
