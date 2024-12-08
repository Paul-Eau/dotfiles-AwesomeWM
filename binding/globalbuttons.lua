-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  -- Mouse bindings on the root window ("desktop")
  local globalbuttons = gears.table.join(

    -- left mouse button
    awful.button({ }, 3, function () RC.mainmenu:toggle() end),
    -- mousewheel up
    awful.button({ }, 4, awful.tag.viewnext),
    -- mousewheel down
    awful.button({ }, 5, awful.tag.viewprev)
  )

  return globalbuttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get() end })
