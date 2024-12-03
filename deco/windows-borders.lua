local beautiful = require("beautiful")
local awful = require("awful")


beautiful.border_width = 3
beautiful.useless_gap = 10

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = 3, -- Ajustez la largeur ici
            border_color = beautiful.border_normal,
        }
    }
}
