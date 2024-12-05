local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato") -- Importation de Rubato

-- Définir le rectangle à afficher

local screen_width = screen.primary.geometry.width
local border_size = 10 -- Taille des bords en pixels

local volume_slider = require("widgets.bar.quick-settings.quick-settings-pane.volume-slider")
local brightness_slider = require("widgets.bar.quick-settings.quick-settings-pane.brightness-slider")
local create_toggle_button = require("widgets.bar.quick-settings.quick-settings-pane.toggles")
local create_rectanglular_toggle_button = require("widgets.bar.quick-settings.quick-settings-pane.rectangle-toggle")

-- Configurer le widget vide
local quick_settings_pane_widget = wibox.widget {
  layout = wibox.layout.flex.vertical,
  {
    layout = wibox.layout.fixed.vertical,
    {
        layout = wibox.layout.fixed.horizontal, -- Horizontal layout
        {
            widget = wibox.container.constraint,
            strategy = "exact",
            width = 2/3 * 350, -- 2/3 of the total width (350)
            {
                create_rectanglular_toggle_button(nil, beautiful.wifi_0, "Wi-Fi"),
                widget = wibox.container.margin,
                margins = {
                    top = 15,
                    bottom = 2,
                    left = 15,
                    right = 15
                }
            }
        },
        {
            widget = wibox.container.constraint,
            strategy = "exact",
            width = 1/3 * 350, -- 1/3 of the total width (350)
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    create_rectanglular_toggle_button(nil, beautiful.wifi_0, "Wi-Fi"),
                    widget = wibox.container.margin,
                    margins = {
                        top = 15,
                        bottom = 2,
                        left = 2, -- Half of the remaining space
                        right = 2 -- Half of the remaining space
                    }
                },
                {
                    create_rectanglular_toggle_button(nil, beautiful.wifi_0, "Wi-Fi"),
                    widget = wibox.container.margin,
                    margins = {
                        top = 15,
                        bottom = 2,
                        left = 2, -- Half of the remaining space
                        right = 2 -- Half of the remaining space
                    }
                }
            }
        }
    },
    {
        widget = wibox.container.constraint,
        strategy = "exact",
        width = 1/3 * 350, -- 1/3 of the total width (350)
        {
            create_rectanglular_toggle_button(nil, beautiful.bluetooth_on, "Bluetooth"),
            margins = {
                top = 2,
                bottom = 10,
                left = 15,
                right = 15
            },
            widget = wibox.container.margin
        }
    },
  },
  {
    layout = wibox.layout.flex.vertical,
    volume_slider,
    brightness_slider,

  },
  {
    layout = wibox.layout.flex.horizontal,

  },
  margins = 0, -- Ajouter des marges autour du widget
}




local rectangle = wibox {
    ontop = true,
    width = 350,
    height = 500,
    bg = beautiful.normal_fg, -- Couleur de fond
    visible = false, -- Masquer au démarrage
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 10) end, -- Coins arrondis
    opacity = 0.85, -- Opacité
}

-- Ajouter le widget au rectangle
rectangle:setup {
    quick_settings_pane_widget,
    layout = wibox.layout.flex.vertical,
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
function quick_settings_pane_widget:toggle()
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


return quick_settings_pane_widget
