local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get ()
  local tags = {}

  awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    tags[s] = awful.tag(
      { "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, RC.layouts[2] -- Layout par défaut
    )

    -- External screen gap
    s.padding = {
      left = 10,
      right = 10,
      top = 10,
      bottom = 10
  }
  end)

  return tags
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get() end })
