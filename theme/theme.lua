RC = {} -- global namespace, on top before require any modules


---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
--local themes_path = gears.filesystem.get_themes_dir()
local themes_path = (os.getenv("HOME") .. "/.config/awesome/theme/")

local color_scheme = "dark" or "light"


local theme = {}

theme.font          = "Bahnschrift"
theme.font = theme.font or "sans"

theme.bg_normal     = "#1C1B1A"
theme.bg_focus      = "#AF3029"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap         = dpi(0)
theme.border_color_normal = "#000000"
theme.border_color_active = "#AF3029"
theme.border_color_marked = "#91231c"




if color_scheme == "dark" then
    -- Text color
    theme.fg_faint = "#575653"
    theme.fg_muted = "#878580"
    theme.fg_primary = "#CECDC3"
    -- Background color
    theme.bg_primary = "#100F0F"
    theme.bg_secondary = "#1C1B1A"
    -- UI color
    theme.ui_1 = "#282726"
    theme.ui_2 = "#343331"
    theme.ui_3 = "#403E3C"
    -- Colors
    theme.red = "#AF3029"
    theme.orange = "#BC5215"
    theme.yellow = "#AD8301"
    theme.green = "#66800B"
    theme.cyan = "#24837B"
    theme.blue = "#205EA6"
    theme.purple = "#5E409D"
    theme.mangenta = "#A02F6F"
    -- Wallpaper
    theme.wallpaper = theme.wallpaper_dark
else
    -- Text color
    theme.fg_faint = "#B7B5AC"
    theme.fg_muted = "#6F6E69"
    theme.fg_primary = "#100F0F"
    -- Background color
    theme.bg_primary = "#FFFCF0"
    theme.bg_secondary = "#F2F0E5"
    -- UI color
    theme.ui_1 = "#E6E4D9"
    theme.ui_2 = "#DAD8CE"
    theme.ui_3 = "#CECDC3"
    -- Colors
    theme.red = "#D14D41"
    theme.orange = "#DA702C"
    theme.yellow = "#D0A215"
    theme.green = "#879A39"
    theme.cyan = "#879A39"
    theme.blue = "#4385BE"
    theme.purple = "#8B7EC8"
    theme.mangenta = "#CE5D97"
    -- Wallpaper
    theme.wallpaper = theme.wallpaper_light
end

theme.accent = theme.red
theme.border_width = 3
theme.border_normal = theme.accent

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."wallpapers/background-dark.png"
theme.wallpaper_dark = themes_path.."wallpapers/background-dark.png"
theme.wallpaper_light = themes_path.."wallpapers/background-light.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."layouts/fairhw.png"
theme.layout_fairv = themes_path.."layouts/fairvw.png"
theme.layout_floating  = themes_path.."layouts/floatingw.png"
theme.layout_magnifier = themes_path.."layouts/magnifierw.png"
theme.layout_max = themes_path.."layouts/maxw.png"
theme.layout_fullscreen = themes_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."layouts/tileleftw.png"
theme.layout_tile = themes_path.."layouts/tilew.png"
theme.layout_tiletop = themes_path.."layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."layouts/spiralw.png"
theme.layout_dwindle = themes_path.."layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."layouts/cornernww.png"
theme.layout_cornerne = themes_path.."layouts/cornernew.png"
theme.layout_cornersw = themes_path.."layouts/cornersww.png"
theme.layout_cornerse = themes_path.."layouts/cornersew.png"


-- BATTERY
theme.battery_0 = themes_path.."bar/battery/battery-0.svg"
theme.battery_1 = themes_path.."bar/battery/battery-1.svg"
theme.battery_2 = themes_path.."bar/battery/battery-2.svg"
theme.battery_3 = themes_path.."bar/battery/battery-3.svg"
theme.battery_4 = themes_path.."bar/battery/battery-4.svg"
theme.battery_5 = themes_path.."bar/battery/battery-5.svg"
theme.battery_6 = themes_path.."bar/battery/battery-6.svg"
theme.battery_7 = themes_path.."bar/battery/battery-7.svg"
theme.battery_8 = themes_path.."bar/battery/battery-8.svg"
theme.battery_9 = themes_path.."bar/battery/battery-9.svg"
theme.battery_10 = themes_path.."bar/battery/battery-10.svg"

theme.battery_charging_0 = themes_path.."bar/battery/battery-charging-0.svg"
theme.battery_charging_1 = themes_path.."bar/battery/battery-charging-1.svg"
theme.battery_charging_2 = themes_path.."bar/battery/battery-charging-2.svg"
theme.battery_charging_3 = themes_path.."bar/battery/battery-charging-3.svg"
theme.battery_charging_4 = themes_path.."bar/battery/battery-charging-4.svg"
theme.battery_charging_5 = themes_path.."bar/battery/battery-charging-5.svg"
theme.battery_charging_6 = themes_path.."bar/battery/battery-charging-6.svg"
theme.battery_charging_7 = themes_path.."bar/battery/battery-charging-7.svg"
theme.battery_charging_8 = themes_path.."bar/battery/battery-charging-8.svg"
theme.battery_charging_9 = themes_path.."bar/battery/battery-charging-9.svg"
theme.battery_charging_10 = themes_path.."bar/battery/battery-charging-10.svg"


theme.headset_on = themes_path.."bar/sound/headset-on.svg"
theme.micro_on = themes_path.."bar/sound/micro-on.svg"
theme.sound_0 = themes_path.."bar/sound/speaker-0.svg"
theme.sound_1 = themes_path.."bar/sound/speaker-1.svg"
theme.sound_2 = themes_path.."bar/sound/speaker-2.svg"
theme.sound_3 = themes_path.."bar/sound/speaker-3.svg"
theme.sound_4 = themes_path.."bar/sound/speaker-4.svg"
theme.sound_mute = themes_path.."bar/sound/speaker-mute.svg"


theme.wifi_0 = themes_path.."bar/wifi/wifi-0.svg"
theme.wifi_1 = themes_path.."bar/wifi/wifi-1.svg"
theme.wifi_2 = themes_path.."bar/wifi/wifi-2.svg"
theme.wifi_fail = themes_path.."bar/wifi/wifi-fail.svg"
theme.wifi_off = themes_path.."bar/wifi/wifi-off.svg"


theme.ethernet_off = themes_path.."bar/ethernet/ethernet-off.svg"
theme.ethernet_on = themes_path.."bar/ethernet/ethernet-on.svg"


theme.bluetooth_off = themes_path.."bar/bluetooth/bluetooth-off.svg"
theme.bluetooth_on = themes_path.."bar/bluetooth/bluetooth-on.svg"
theme.bluetooth_fail = themes_path.."bar/bluetooth/bluetooth-fail.svg"

theme.chevron_right = themes_path.."misc/chevron-right.svg"



theme.logo = themes_path.."bar/home/logo.svg"

theme.tag_dot = themes_path.."bar/tags/tag-dot.svg"
theme.tag_dot_empty = themes_path.."bar/tags/tag-dot-empty.svg"



theme.wifi_icon = themes_path.."bar/wifi/wifi-3.svg"
theme.bluetooth_icon = themes_path.."bar/bluetooth/wifi-on.svg"

theme.brightness_icon = themes_path.."misc/brightness.svg"


theme.placeholder = themes_path.."misc/placeholder.svg"





theme.tag_preview_widget_border_radius = 4        -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = 4        -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 0.85              -- Opacity of each client
theme.tag_preview_client_bg = theme.bg_normal           -- The bg color of each client
theme.tag_preview_client_border_color = theme.bg_focus -- The border color of each client
theme.tag_preview_client_border_width = 2         -- The border width of each client
theme.tag_preview_widget_bg = theme.bg_normal           -- The bg color of the widget
theme.tag_preview_widget_border_color = theme.bg_focus -- The border color of the widget
theme.tag_preview_widget_border_width = 3         -- The border width of the widget
theme.tag_preview_widget_margin = 10               -- The margin of the widget


theme.task_preview_widget_border_radius = 4        -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = theme.bg_normal          -- The bg color of the widget
theme.task_preview_widget_border_color = theme.bg_focus -- The border color of the widget
theme.task_preview_widget_border_width = 2         -- The border width of the widget
theme.task_preview_widget_margin = 0               -- The margin of the widget



-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
