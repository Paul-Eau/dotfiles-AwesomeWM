local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Charger le rectangle
local home_pane = require("widgets.bar.home-pane.init")

-- Créer un bouton
local home_button = wibox.widget {
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
}

-- Ajouter une interaction au clic
home_button:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then -- Clic gauche
        home_pane:toggle() -- Appeler la fonction toggle du rectangle
    end
end)

return home_button
