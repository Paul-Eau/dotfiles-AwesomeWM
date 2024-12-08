local gears = require("gears")
local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get(globalkeys)
  -- Bind all key numbers to tags.
  -- Be careful: we use keycodes to make it work on any keyboard layout.
  -- This should map on the top row of your keyboard, usually 1 to 9.

  for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

      -- View tag only.
      awful.key({ "Mod4" }, "#" .. i + 9,
        function ()
          local screen = awful.screen.focused()
          local tag = screen and screen.tags[i]
          if tag then
            tag:view_only()
          end
        end,
        {description = "view tag #"..i, group = "TAG"}),

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

      -- Toggle tag display.
      awful.key({ "Mod4", "Control" }, "#" .. i + 9,
        function ()
          local screen = awful.screen.focused()
          local tag = screen and screen.tags[i]
          if tag then
            awful.tag.viewtoggle(tag)
          end
        end,
        {description = "toggle tag #" .. i, group = "TAG"}),

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

      -- Move client to tag.
      awful.key({ "Mod4", "Mod1" }, "#" .. i + 9,
        function ()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:move_to_tag(tag)
              --tag:view_only()
            end
          end
        end,
        {description = "move focused client to tag #"..i, group = "TAG"}),

      --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

      -- Toggle tag on focused client. Permet de "dupliquer" un client sur plusieurs tags
      awful.key({ "Mod4", "Control", "Shift" }, "#" .. i + 9,
        function ()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:toggle_tag(tag)
            end
          end
        end,
        {description = "toggle focused client on tag #" .. i, group = "TAG"})

    )
  end

  return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
