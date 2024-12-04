local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato") -- Importation de Rubato

-- Définir le rectangle à afficher

local screen_width = screen.primary.geometry.width
local border_size = 10 -- Taille des bords en pixels
local wibar_height = 30 -- Hauteur de la wibar (ajustez si nécessaire)


local rectangle = wibox {
    ontop = true,
    width = 350,
    height = 500,
    bg = beautiful.normal_fg, -- Couleur de fond
    visible = false, -- Masquer au démarrage
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 10) end, -- Coins arrondis
    opacity = 0.85, -- Opacité
}



-- Position initiale (hors écran à droite)
rectangle.x = screen_width
rectangle.y = 420 -- Position verticale avec bord supérieur et wibar

-- Créer l'animation Rubato pour la position X
local x_anim = rubato.timed {
    duration = 0.5, -- Durée de l'animation
    pos = rectangle.x, -- Position initiale (hors écran à droite)
    subscribed = function(pos)
        rectangle.x = pos -- Mise à jour de la position X du rectangle
    end
}



-- Variable pour suivre l'état ouvert/fermé
local is_open = false

-- Fonction pour basculer l'affichage avec animation
local function toggle_rectangle()
    if is_open then
        -- Si visible, on anime la disparition vers la droite
        x_anim.target = screen_width
        gears.timer.start_new(0.5, function() -- Timer de 0.5 seconde (la durée de l'animation)
            rectangle.visible = false -- Masquer le rectangle après l'animation
        end)
    else
        -- Si invisible, rendre visible et animer vers la gauche
        rectangle.visible = true
        -- Réinitialiser la position avant de commencer l'animation
        x_anim.target = screen_width - rectangle.width - border_size - 50 -- Position de destination
    end
    is_open = not is_open -- Basculer l'état
end



-- Configurer le widget vide
local quick_settings_pane_widget = wibox.widget {
    layout = wibox.container.margin,
    margins = 0, -- Ajouter des marges autour du widget
}



-- Ajouter un événement de clic pour afficher/masquer le rectangle
quick_settings_pane_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then -- Si clic gauche
        toggle_rectangle()
    end
end)

return quick_settings_pane_widget
