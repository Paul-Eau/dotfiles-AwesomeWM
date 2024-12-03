local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato") -- Importation de Rubato
local volume_widget = require("widgets.volume")
local wifi_widget = require("widgets.wifi")
local battery_widget = require("widgets.battery")

-- Définir le rectangle à afficher
local rectangle = wibox {
    ontop = true,
    width = 350,
    height = 600,
    bg = beautiful.normal_fg, -- Couleur de fond
    visible = false, -- Masquer au démarrage
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 10) end, -- Coins arrondis
}

-- Variable pour suivre l'état ouvert/fermé
local is_open = false

-- Animateur Rubato pour le mouvement vertical
local y_animation = rubato.timed {
    intro = 0.2,
    outro = 0.2,
    duration = 0.4,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        rectangle.y = pos
    end,
    -- Assurez-vous de mettre à jour l'état à la fin des animations
    ended = function()
        if not is_open then
            rectangle.visible = false
        end
    end
}

-- Positionner le rectangle en haut à droite de l'écran
local function position_rectangle(screen)
    local screen_geometry = screen.geometry
    rectangle.x = screen_geometry.x + screen_geometry.width - rectangle.width - 75
    -- Position initiale (hors écran) pour l'animation d'apparition
    rectangle.y = screen_geometry.y - rectangle.height
end

-- Configurer le widget avec les widgets enfants
local quick_settings_widget = wibox.widget {
    {
        volume_widget,
        wifi_widget,
        battery_widget,
        layout = wibox.layout.fixed.horizontal,
        spacing = 0, -- Ajuster l'espacement entre les widgets
    },
    layout = wibox.container.margin,
    margins = 0, -- Ajouter des marges autour du widget
}

-- Ajouter un événement de clic pour afficher/masquer le rectangle
quick_settings_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then -- Si clic gauche
        local screen = mouse.screen -- Détecter l'écran où le clic a eu lieu
        if not is_open then
            position_rectangle(screen) -- Positionner en haut à droite de l'écran
            rectangle.visible = true -- Activer la visibilité avant l'animation
            y_animation.target = screen.geometry.y + 50 -- Lancer l'animation d'apparition
        else
            y_animation.target = screen.geometry.y - rectangle.height -- Lancer l'animation de fermeture
        end
        is_open = not is_open -- Basculer l'état
    end
end)

return quick_settings_widget
