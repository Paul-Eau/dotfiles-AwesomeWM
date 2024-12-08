local gears = require("gears")
local awful = require("awful")
-- local titlebar = require("anybox.titlebar")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local clientkeys = gears.table.join(

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    awful.key({ "Mod4", }, "Return",
      function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      {description = "toggle fullscreen", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    awful.key({ "Mod4", }, "f",
      function (c)
        c.maximized = not c.maximized
        c:raise()
      end ,
      {description = "(un)maximize", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

      awful.key({ "Mod4", }, "n",
      function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end ,
      {description = "minimize", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  awful.key({ "Mod4", }, "c",
  function (c)
        c:kill()
      end,
      {description = "close", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    awful.key({ "Mod4", "Mod1" }, "space",
      awful.client.floating.toggle,
      {description = "toggle floating", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    awful.key({ "Mod4", "Mod1" }, "t",
      function (c)
        c.ontop = not c.ontop
      end,
      {description = "toggle keep on top", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  awful.key({ "Mod4", "Control" }, "f",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  awful.key({ "Mod4", "Mod1"   }, "f",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "CLIENT"}),

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Voir si utilisés
  awful.key({ "Mod4", "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),

  awful.key({ "Mod4",           }, "o",      function (c) c:move_to_screen() end,
    {description = "move to screen", group = "client"})

  )

  return clientkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get() end })
