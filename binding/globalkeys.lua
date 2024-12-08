-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local app_launcher = require("widgets.launcher")

local volume_service = require("services.volume")
local brightness_service = require("services.brightness")



local _M = {}

-- reading
-- https://awesomewm.org/wiki/Global_Keybindings

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local globalkeys = gears.table.join(

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    awful.key({ "Mod4", }, "h",
        hotkeys_popup.show_help,
        {description="show help", group="AWESOME"}),

    awful.key({ "Mod4", "Control" }, "r",
        awesome.restart,
        {description = "reload awesome", group = "AWESOME"}),

    awful.key({ "Mod4", "Shift"   }, "q",
        awesome.quit,
        {description = "quit awesome", group = "AWESOME"}),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Tag browsing
    awful.key({ "Mod4", }, "Up",
    awful.tag.viewprev,
        {description = "previous tag", group = "TAG"}),

    awful.key({ "Mod4", }, "Down",
        awful.tag.viewnext,
        {description = "next tag", group = "TAG"}),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Client browsing
    awful.key({ "Mod4", }, "d",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "CLIENT"}),

    awful.key({ "Mod4", }, "q",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "CLIENT"}),

    awful.key({ "Mod4", }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "CLIENT"}),

    -- Restore minimized client one by one
    awful.key({ "Mod4", "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
            end
        end,
        {description = "restore minimized", group = "CLIENT"}),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Apps
    awful.key({ "Mod4",}, "space",
        function ()
            app_launcher:toggle()
        end,
        {description = "Toggle app launcher", group = "APP"}),

    awful.key({ "Mod4", }, "t",
        function ()
            awful.spawn("alacritty")
        end,
        {description = "open terminal", group = "APP"}),

    awful.key({ "Mod4", }, "e",
        function ()
            awful.spawn("thunar")
        end,
        {description = "open file-manager", group = "APP"}),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Layout manipulation
    awful.key({ "Mod4", "Control" }, "space",
        function ()
            awful.layout.inc( 1)
        end,
        {description = "next layout", group = "LAYOUT"}),

    awful.key({ "Mod4", "Mod1" }, "d",
        function ()
            awful.tag.incmwfact( 0.05)
        end,
        {description = "increase master width factor", group = "LAYOUT"}),

    awful.key({ "Mod4", "Mod1" }, "q",
        function ()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "LAYOUT"}),




    awful.key({ "Mod4", "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
        {description = "swap with next client by index", group = "client"}),

    awful.key({ "Mod4", "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
        {description = "swap with previous client by index", group = "client"}),

    awful.key({ "Mod4", "Control" }, "j", function () awful.screen.focus_relative( 1) end,
        {description = "focus the next screen", group = "screen"}),

    awful.key({ "Mod4", "Control" }, "k", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),

    awful.key({ "Mod4",           }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),


    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


    awful.key({ "Mod4", "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),

    awful.key({ "Mod4", "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ "Mod4", "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
        {description = "increase the number of columns", group = "layout"}),

    awful.key({ "Mod4", "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
        {description = "decrease the number of columns", group = "layout"}),


    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Resize for floating windows
    awful.key({ "Mod4", "Mod1" }, "Down",
        function () awful.client.moveresize( 0, 0, 0, -10) end),

    awful.key({ "Mod4", "Mod1" }, "Up",
        function () awful.client.moveresize( 0, 0, 0,  10) end),

    awful.key({ "Mod4", "Mod1" }, "Left",
        function () awful.client.moveresize( 0, 0, -10, 0) end),

    awful.key({ "Mod4", "Mod1" }, "Right",
        function () awful.client.moveresize( 0, 0,  10, 0) end),

    -- Move
    awful.key({ "Mod4", "Control"   }, "Down",
              function () awful.client.moveresize(  0,  10,   0,   0) end),

    awful.key({ "Mod4", "Control"   }, "Up",
              function () awful.client.moveresize(  0, -10,   0,   0) end),

    awful.key({ "Mod4", "Control"   }, "Left",
              function () awful.client.moveresize(-10,   0,   0,   0) end),

    awful.key({ "Mod4", "Control"   }, "Right",
              function () awful.client.moveresize( 10,   0,   0,   0) end),


    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Fn-keys
    awful.key({ }, "#121", function () volume_service.toggle_mute() end),
    awful.key({ }, "#122", function () volume_service.change_volume(-5, false) end),
    awful.key({ }, "#123", function () volume_service.change_volume(5, false) end),

    awful.key({ }, "#198", function () awful.util.spawn("volume --in-mute") end),

    awful.key({ }, "#232", function () brightness_service.adjust_brightness("dec", 1.25, false) end),
    awful.key({ }, "#233", function () brightness_service.adjust_brightness("inc", 1.25, false) end)

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  )

  return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_) return _M.get() end })
