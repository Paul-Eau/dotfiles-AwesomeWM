local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato") -- Importation de Rubato

-- Définir le rectangle à afficher

local screen_width = screen.primary.geometry.width
local border_size = 10 -- Taille des bords en pixels

local brightness_slider = require("widgets.bar.quick-settings.quick-settings-pane.slider")
local volume_slider = require("widgets.bar.quick-settings.quick-settings-pane.slider")
local create_rectanglular_toggle_button = require("widgets.bar.quick-settings.quick-settings-pane.rectangle-toggle")

-- Configurer le widget vide
local quick_settings_pane_widget = wibox.widget {
    layout = wibox.layout.flex.vertical,
    {
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        {
            widget = wibox.container.margin,
            margins = { top = 12, bottom = 10, left = 10, right = 10 },
            {
                layout = wibox.layout.fixed.vertical,
                {
                    id = "first_row",
                    layout = wibox.layout.ratio.horizontal,
                    {
                        widget = wibox.container.margin,
                        margins = { top = 4, bottom = 4, left = 4, right = 4 },
                        create_rectanglular_toggle_button("", beautiful.wifi_0, "Wi-Fi", beautiful.chevron_right, 16)
                    },
                    {
                        widget = wibox.container.margin,
                        margins = { top = 4, bottom = 4, left = 4, right = 4 },
                        create_rectanglular_toggle_button("", beautiful.placeholder, "", "", 4)
                    },
                    {
                        widget = wibox.container.margin,
                        margins = { top = 4, bottom = 4, left = 4, right = 4 },
                        create_rectanglular_toggle_button("", beautiful.placeholder, "", "", 4)
                    }
                },
                {
                    id = "second_row",
                    layout = wibox.layout.ratio.horizontal,
                    {
                        widget = wibox.container.margin,
                        margins = { top = 4, bottom = 4, left = 4, right = 4 },
                        create_rectanglular_toggle_button("", beautiful.bluetooth_on, "BlueTooth", beautiful.chevron_right, 16)
                    },
                    {
                        widget = wibox.container.margin,
                        margins = { top = 4, bottom = 4, left = 4, right = 4 },
                        create_rectanglular_toggle_button("", beautiful.placeholder, "", "", 4)
                    },
                    {
                        widget = wibox.container.margin,
                        margins = { top = 4, bottom = 4, left = 4, right = 4 },
                        create_rectanglular_toggle_button("", beautiful.placeholder, "", "", 4)
                    }
                }
            }
            
        }
    },
    {
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        {
            widget = wibox.container.margin,
            margins = {
                top = -40,
                bottom = 0,
                left = 0,
                right = 0,
            },
            {
                widget = wibox.layout.flex.vertical,
                {
                    widget = volume_slider,
                },
                {
                    widget = wibox.container.margin,
                    margins = { top = -40 }, -- Adjust the value as needed
                    brightness_slider,
                },
            },
        },
        
    },

    {
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        {
            widget = wibox.container.margin,
            margins = 10,
            {
                widget = wibox.widget.textbox,
                text = "Ut laboris nisi ut aliquip ex ea commodo consequat.",
            }
        }
    }
}

-- Adjust the ratios for the text widgets
quick_settings_pane_widget:get_children_by_id("first_row")[1]:adjust_ratio(2, 0.66, 0.17, 0.17)
quick_settings_pane_widget:get_children_by_id("second_row")[1]:adjust_ratio(2, 0.66, 0.17, 0.17)














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
