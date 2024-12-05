local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears") -- Pour la forme arrondie
local rubato = require("lib.rubato") -- Importation de Rubato
local naughty = require("naughty") -- Importation de naughty pour les notifications

local network_widget = require("widgets.bar.quick-settings.network")
local sound_widget = require("widgets.bar.quick-settings.sound")
local battery_widget = require("widgets.bar.quick-settings.battery")

-- Widget contenant uniquement le fond
local background_widget = wibox.widget {
    bg = "#282c34", -- Couleur de fond
    shape = gears.shape.rounded_rect, -- Bordures arrondies
    widget = wibox.container.background,
    visible = false, -- Par défaut, invisible
    opacity = 0 -- Initial opacity set to 0
}

-- Animateur Rubato pour le fondu
local fade_animation = rubato.timed {
    intro = 0.2,
    outro = 0.2,
    duration = 0.4,
    easing = rubato.easing.quadratic,
    subscribed = function(opacity)
        background_widget.opacity = opacity
        if opacity == 0 then
            background_widget.visible = false -- Cacher le fond après l'animation
        end
    end,
}

-- Widget final avec widgets internes et le fond superposé
local quick_settings_widget = wibox.widget {
    {
        -- Fond de couleur en arrière-plan
        {
            background_widget, -- Utilisation du widget de fond
            margins = 6, -- Marges uniquement pour le fond
            widget = wibox.container.margin,
        },
        layout = wibox.layout.stack, -- Superposition des deux widgets (fond + contenu)
    },
    {
        -- Widgets internes superposés au fond
        {
            layout = wibox.layout.fixed.vertical,
            {
                layout = wibox.container.margin,
                left = 8,
                right = 8,
                {
                    layout = wibox.layout.fixed.vertical,
                    {
                        network_widget,
                        top = 5,
                        bottom = 0,
                        widget = wibox.container.margin
                    },
                    {
                        sound_widget,
                        bottom = 8,
                        widget = wibox.container.margin
                    },
                    {
                        battery_widget,
                        bottom = 15,
                        widget = wibox.container.margin
                    }
                }
            }
        },
        layout = wibox.container.place, -- Centre les widgets internes si nécessaire
    },
    layout = wibox.layout.stack,
}

-- Gérer les événements de survol de la souris
quick_settings_widget:connect_signal("mouse::enter", function()
    background_widget.visible = true -- Afficher le fond
    fade_animation.target = 1 -- Lancer l'animation de fondu entrant
end)

quick_settings_widget:connect_signal("mouse::leave", function()
    fade_animation.target = 0 -- Lancer l'animation de fondu sortant
    if fade_animation.target == 0 then
        background_widget.visible = true -- Assurer que le fond reste visible pendant l'animation
    end
end)




local quick_settings_pane = require("widgets.bar.quick-settings.quick-settings-pane") -- Importer le panneau de réglages rapides

quick_settings_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then -- Clic gauche
        quick_settings_pane:toggle() -- Appeler la fonction toggle du rectangle
    end
end)

return quick_settings_widget
