local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local theme = require("theme.default.theme")

-- Fonction pour calculer le niveau moyen de batterie
local function calculate_average_battery_level(acpi_output)
    local total_percent = 0
    local battery_count = 0
    local is_charging = false

    -- Parcourt chaque ligne de la sortie `acpi`
    for line in acpi_output:gmatch("[^\r\n]+") do
        -- Vérifie si une batterie est en charge
        if line:match("Charging") then
            is_charging = true
        end

        -- Extrait le pourcentage avec une expression régulière
        local percent = line:match("(%d+)%%")
        if percent then
            total_percent = total_percent + tonumber(percent)
            battery_count = battery_count + 1
        end
    end

    -- Calcul de la moyenne si on a au moins une batterie
    if battery_count > 0 then
        return total_percent / battery_count, is_charging
    else
        return nil, is_charging
    end
end

-- Fonction pour choisir l'icône en fonction du niveau de batterie et de l'état de charge
local function get_battery_icon(battery_level, charging)
    if charging then
        return theme.battery_charging
    elseif battery_level >= 80 then
        return theme.battery_4
    elseif battery_level >= 60 then
        return theme.battery_3
    elseif battery_level >= 40 then
        return theme.battery_2
    elseif battery_level >= 20 then
        return theme.battery_1
    else
        return theme.battery_0
    end
end

-- Fonction pour choisir la couleur en fonction du niveau de batterie et de l'état de charge
local function get_battery_color(battery_level, charging)
    if charging then
        return beautiful.fg_normal
    elseif battery_level < 20 then
        return beautiful.fg_urgent
    else
        return beautiful.fg_normal
    end
end

-- Créer le widget batterie
local battery_widget = wibox.widget {
    {
        widget = wibox.container.rotate,
        direction = "west",
        {
            widget = wibox.container.margin,
            margins = 2, -- Ajouter des marges pour centrer l'icône
            {
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                {
                    widget = wibox.widget.imagebox,
                    id = "icon",
                    image = theme.battery_4, -- Icône par défaut
                    resize = true,
                    forced_width = 32, -- Réduire la largeur de l'icône
                    forced_height = 32, -- Réduire la hauteur de l'icône
                },
            },
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Créer un tooltip pour afficher l'état de la batterie
local battery_tooltip = awful.tooltip {
    objects = { battery_widget },
    text = "Chargement des données...",
    timeout = 1,
    align = "left",
    mode = "outside",
    preferred_positions = { "bottom" }
}

-- Met à jour le widget batterie et le tooltip
local function update_battery_widget()
    local command = "acpi"

    awful.spawn.easy_async_with_shell(command, function(stdout, stderr, reason, exit_code)
        if exit_code == 0 and stdout ~= nil and stdout ~= "" then
            local average, charging = calculate_average_battery_level(stdout)

            if average then
                local icon_path = get_battery_icon(average, charging)
                local icon_color = get_battery_color(average, charging)
                local imagebox = battery_widget:get_children_by_id("icon")[1]

                if imagebox then
                    local new_image = gears.color.recolor_image(icon_path, icon_color)
                    if new_image ~= imagebox.image then
                        imagebox.image = nil
                        imagebox.image = new_image
                    end
                end

                battery_tooltip.text = string.format(
                    "Battery remaining: %.0f%% %s",
                    average,
                    charging and "(charging)" or "(not charging)"
                )
            else
                battery_tooltip.text = "Unable to calculate battery level."
            end
        else
            battery_tooltip.text = "Unable to retrieve battery state."
        end
    end)
end

gears.timer {
    timeout = 1,
    autostart = true,
    callback = update_battery_widget,
}

update_battery_widget()

return battery_widget
