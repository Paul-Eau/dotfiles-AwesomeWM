local gears = require("gears")



client.connect_signal("request::manage", function(c)
    -- Appliquer une forme arrondie
    c.shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 10)
    end
end)


-- Don't apply to fullscreen windows

--[[ client.connect_signal("property::maximized", function(c)
    if c.maximized then
        c.shape = nil
    else
        c.shape = function(cr, width, height)
            rounded_rect(cr, width, height)
        end
    end
end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        c.shape = nil
    else
        c.shape = function(cr, width, height)
            rounded_rect(cr, width, height)
        end
    end
end)
 ]]