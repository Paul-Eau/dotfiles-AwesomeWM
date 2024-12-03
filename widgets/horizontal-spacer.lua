local wibox = require("wibox")

local function horizontal_spacer(size)
    return wibox.widget {
        forced_width = size,
        layout = wibox.layout.fixed.horizontal
    }
end

return horizontal_spacer
