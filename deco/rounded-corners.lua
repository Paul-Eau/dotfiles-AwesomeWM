local gears = require("gears")


client.connect_signal("request::manage", function(c)
    -- Appliquer une forme arrondie
    c.shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 10)
    end
end)