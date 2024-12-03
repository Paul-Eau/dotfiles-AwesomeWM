local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local theme = require("theme.default.theme")

local home_button_widget = wibox.widget {
    {
        widget = wibox.container.margin,
        margins = 8, -- Ajouter des marges
        {
            widget = wibox.widget.imagebox,
            id = "home",
            image = gears.color.recolor_image(theme.logo, beautiful.fg_normal), -- Icône par défaut
            resize = true,

        },
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Définir le rectangle à afficher
local rectangle = wibox {
    ontop = true,
    width = 350,
    height = 1000,
    bg = beautiful.normal_fg, -- Couleur de fond
    visible = false, -- Masquer au démarrage
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 10) end, -- Coins arrondis
}

-- Variable pour suivre l'état ouvert/fermé
local is_open = false

-- Positionner le rectangle à droite de l'écran
local function position_rectangle(screen)
    local screen_geometry = screen.geometry
    rectangle.y = screen_geometry.y + 50
    -- Position initiale (hors écran) pour l'animation d'apparition
    rectangle.x = screen_geometry.x + screen_geometry.width - 10
end

-- Ajouter un événement de clic pour afficher/masquer le rectangle
home_button_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then -- Si clic gauche
        local screen = mouse.screen -- Détecter l'écran où le clic a eu lieu
        if not is_open then
            position_rectangle(screen) -- Positionner à droite de l'écran
            rectangle.visible = true -- Activer la visibilité avant l'animation
            rectangle.x = screen.geometry.x + screen.geometry.width - rectangle.width - 10 -- Positionner directement
        else
            rectangle.visible = false -- Masquer directement
            rectangle.x = screen.geometry.x + screen.geometry.width - 10 -- Réinitialiser la position
        end
        is_open = not is_open -- Basculer l'état
    end
end)

return home_button_widget
