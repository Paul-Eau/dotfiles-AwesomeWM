local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("lib.rubato")

-- Charger le rectangle
local home_pane = require("widgets.bar.home-button.home-pane")

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
        else
            background_widget.visible = true -- Assurer que le fond est visible pendant l'animation
        end
    end,
}




local home_button = wibox.widget {
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
        {
            widget = wibox.container.margin,
            margins = 8, -- Ajouter des marges
            {
                widget = wibox.widget.imagebox,
                id = "home",
                image = gears.color.recolor_image(beautiful.logo, beautiful.fg_normal), -- Icône par défaut
                resize = true,  
            },
        },
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.stack,
}




-- Gérer les événements de survol de la souris
local function show_background()
    background_widget.visible = true -- Assurer que le fond est visible avant l'animation
    fade_animation.target = 1 -- Lancer l'animation de fondu entrant
end

local function hide_background()
    fade_animation.target = 0 -- Lancer l'animation de fondu sortant
end


home_button:connect_signal("mouse::enter", show_background)
home_button:connect_signal("mouse::leave", hide_background)





-- Ajouter une interaction au clic
home_button:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then -- Clic gauche
        home_pane:toggle() -- Appeler la fonction toggle du rectangle
    end
end)

return home_button
