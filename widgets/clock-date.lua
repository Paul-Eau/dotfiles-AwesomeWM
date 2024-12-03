local wibox = require("wibox")
local beautiful = require("beautiful")
local clock_widget = require("widgets.clock")
local date_widget = require("widgets.date")
local awful = require("awful")  -- Add this line to require awful for tooltip

local function translate_day_to_french(day)
    local days = {
        Sunday = "dimanche",
        Monday = "lundi",
        Tuesday = "mardi",
        Wednesday = "mercredi",
        Thursday = "jeudi",
        Friday = "vendredi",
        Saturday = "samedi"
    }
    return days[day]
end

local function translate_month_to_french(month)
    local months = {
        January = "janvier",
        February = "février",
        March = "mars",
        April = "avril",
        May = "mai",
        June = "juin",
        July = "juillet",
        August = "août",
        September = "septembre",
        October = "octobre",
        November = "novembre",
        December = "décembre"
    }
    return months[month]
end

local function get_french_date()
    local day = translate_day_to_french(os.date("%A"))
    local date = os.date("%d")
    local month = translate_month_to_french(os.date("%B"))
    return day .. " " .. date .. " " .. month
end

local clock_date_widget = wibox.widget {
    {
        clock_widget,
        date_widget,
        align = "center",  -- Centré dans son conteneur
        layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.place,
    halign = "center",
    valign = "center",
}

local tooltip = awful.tooltip {
    objects = { clock_date_widget },
    timer_function = get_french_date,
}

return clock_date_widget
