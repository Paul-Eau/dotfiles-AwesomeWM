local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local theme = require("theme.default.theme")

-- Créer le widget de l'horloge
local clock_widget = wibox.widget {
    {
        widget = wibox.widget.textclock,
        format = "%H:%M",  -- Format de l'heure (par exemple, 14:30)
        refresh = 60,      -- Actualisation toutes les 60 secondes
        align = "center",  -- Centré dans son conteneur
        font = "Bahnschrift" .. " 12.5",   -- Utilise la police du thème avec une taille réduite
        id = "clock",      -- ID pour le widget
    },
    bottom = 0,  -- Réduit l'espace en bas du widget
    top = 3,
    widget = wibox.container.margin
}

return clock_widget
