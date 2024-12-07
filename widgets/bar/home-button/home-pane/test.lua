local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- Créer les widgets home et notification
local home_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "Bienvenue à la maison!",
    align = "center",
    valign = "center",
    font = "sans 14"
}

local notification_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "Vous avez des notifications!",
    align = "center",
    valign = "center",
    font = "sans 14"
}

-- Conteneur pour afficher le widget sélectionné
local display_widget = wibox.widget {
    home_widget,
    layout = wibox.layout.stack
}

-- Créer les boutons du selecteur
local home_button = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            text = "Home",
            align = "center",
            valign = "center",
            font = "sans 14"
        },
        widget = wibox.container.margin,
        margins = {
            top = 5,
            bottom = 5,
            left = 10,
            right = 10
        }
    },
    widget = wibox.container.background,
    border_width = 2,
    border_color = "#000000",
    shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, 5)
    end,
}

local notification_button = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            text = "Notification",
            align = "center",
            valign = "center",
            font = "sans 14"
        },
        widget = wibox.container.margin,
        margins = {
            top = 5,
            bottom = 5,
            left = 10,
            right = 10
        }
    },
    widget = wibox.container.background,
    border_width = 2,
    border_color = "#000000",
    shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 5)
    end,
}

-- Ajouter un style pour les boutons
local function style_button(button, selected)
    if selected then
        button.bg = "#ff0000"
        button.fg = "#ffffff"
    else
        button.bg = "#ffffff"
        button.fg = "#000000"
    end
end

-- Fonction pour mettre à jour le widget affiché
local function update_display(selected)
    if selected == "home" then
        display_widget:reset()
        display_widget:add(home_widget)
    else
        display_widget:reset()
        display_widget:add(notification_widget)
    end
    style_button(home_button, selected == "home")
    style_button(notification_button, selected == "notification")
end

-- Ajouter les actions aux boutons après la définition de update_display
home_button.buttons = gears.table.join(
    awful.button({}, 1, function()
        update_display("home")
    end)
)

notification_button.buttons = gears.table.join(
    awful.button({}, 1, function()
        update_display("notification")
    end)
)

-- Conteneur pour les boutons du selecteur
local selector_widget = wibox.widget {
    {
        home_button,
        notification_button,
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.place,
    halign = "center",
    forced_width = 200
}

-- Initialiser l'affichage
update_display("home")

-- Créer un conteneur pour le selecteur et le widget affiché
local main_widget = wibox.widget {
    selector_widget,
    display_widget,
    layout = wibox.layout.fixed.vertical
}

return main_widget
