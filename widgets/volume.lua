local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local theme = require("theme.default.theme")
local volume_service = require("services.volume") -- Assurez-vous que le chemin vers le fichier est correct

-- Créer le widget son
local volume_widget = wibox.widget {
    {
        {
            widget = wibox.widget.imagebox,
            id = "icon",
            resize = true,
            image = beautiful.sound_0, -- Icône par défaut
        },
        margins = 8,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Créer le tooltip
local volume_tooltip = awful.tooltip {
    objects = { volume_widget },
    timer_function = function()
        if volume_service.data then
            return "Volume: " .. volume_service.data.volume .. "%"
        else
            return "Volume: N/A"
        end
    end,
}

-- Fonction pour mettre à jour l'icône du widget
local function update_widget_icon(data)
    local icon
    if data.muted then
        icon = beautiful.sound_mute
    elseif data.volume <= 20 then
        icon = beautiful.sound_0
    elseif data.volume <= 45 then
        icon = beautiful.sound_1
    elseif data.volume <= 70 then
        icon = beautiful.sound_2
    else -- si sup. à 70
        icon = beautiful.sound_3
    end
    local colored_icon = gears.color.recolor_image(icon, beautiful.fg_normal)
    volume_widget:get_children_by_id("icon")[1].image = colored_icon
end

-- Connexion au signal émis par le service de volume
awesome.connect_signal("volume::update", function(data)
    update_widget_icon(data)
end)

-- Démarrer la surveillance du service
volume_service.watch()

-- Retourne le widget
return volume_widget
