local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")


-- Fonction pour choisir l'icône en fonction du niveau de batterie et de l'état de charge
local function get_battery_icon(battery_level, charging)
    if charging then
        if battery_level >= 90 then
            return beautiful.battery_charging_10
        elseif battery_level >= 80 then
            return beautiful.battery_charging_9
        elseif battery_level >= 70 then
            return beautiful.battery_charging_8
        elseif battery_level >= 60 then
            return beautiful.battery_charging_7
        elseif battery_level >= 50 then
            return beautiful.battery_charging_6
        elseif battery_level >= 40 then
            return beautiful.battery_charging_5
        elseif battery_level >= 30 then
            return beautiful.battery_charging_4
        elseif battery_level >= 20 then
            return beautiful.battery_charging_3
        elseif battery_level >= 10 then
            return beautiful.battery_charging_2
        else
            return beautiful.battery_charging_1
        end
    else
        if battery_level >= 90 then
            return beautiful.battery_10
        elseif battery_level >= 80 then
            return beautiful.battery_9
        elseif battery_level >= 70 then
            return beautiful.battery_8
        elseif battery_level >= 60 then
            return beautiful.battery_7
        elseif battery_level >= 50 then
            return beautiful.battery_6
        elseif battery_level >= 40 then
            return beautiful.battery_5
        elseif battery_level >= 30 then
            return beautiful.battery_4
        elseif battery_level >= 20 then
            return beautiful.battery_3
        elseif battery_level >= 10 then
            return beautiful.battery_2
        else
            return beautiful.battery_1
        end
    end
end



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
            local icon = get_battery_icon(data.bat_level, data.is_adapter_connected)
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
