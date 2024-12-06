local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
local wifi_service = require("services.wifi")

-- Fonction pour choisir l'icône en fonction du signal WiFi
local function get_wifi_icon(signal)
    if signal == -1 then
        return beautiful.wifi_off
    elseif signal == 0 then
        return beautiful.wifi_0
    elseif signal > 0 and signal <= 45 then
        return beautiful.wifi_1
    elseif signal > 45 and signal <= 66 then
        return beautiful.wifi_2
    elseif signal > 66 then
        return beautiful.wifi_2
    end
end

-- Créer le widget WiFi
local wifi_widget = wibox.widget {
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

-- Créer un tooltip pour afficher l'état du WiFi
local wifi_tooltip = awful.tooltip {
    objects = { wifi_widget },
    text = "Chargement des données...",
    timeout = 1,
    align = "left",
    mode = "outside",
    preferred_positions = { "bottom" }
}

-- Met à jour le widget WiFi et le tooltip
local function update_wifi_widget(data)
    if data then
        local signal = data.signal_strenght
        local icon = get_wifi_icon(signal)
        local imagebox = wifi_widget:get_children_by_id("icon")[1]

        if imagebox then
            local new_image = gears.color.recolor_image(icon, beautiful.fg_normal)
            if new_image ~= imagebox.image then
                imagebox.image = nil
                imagebox.image = new_image
            end
        end

        wifi_tooltip.text = string.format("Signal strength: %d%%", signal)
    else
        wifi_tooltip.text = "Unable to retrieve WiFi signal strength."
    end
end

-- Connect to the wifi service signal
awesome.connect_signal("wifi::update", update_wifi_widget)

-- Première mise à jour immédiate
wifi_service.get_signal_strenght()

-- Exporter le widget pour être utilisé ailleurs
return wifi_widget
