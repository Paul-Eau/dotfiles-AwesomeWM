local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local volume_service = require("services.volume")
local rubato = require("lib.rubato")

local volume_osd = {}

function volume_osd:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.widget = wibox {
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    border_width = 2,
    border_color = beautiful.border_color,
    width = 100,
    height = 500,
    widget = {
      {
        {
          layout = wibox.container.margin,
          top = 20,
          {
            id = "volume_icon",
            widget = wibox.widget.imagebox,
            resize = true,
            forced_width = 48,
            forced_height = 48,
            halign = "center",
            valign = "top",
          },
        },
        {
          widget = wibox.container.rotate,
          direction = "east",
          {
            id = "volume_bar",
            shape = gears.shape.rounded_bar,
            color = beautiful.bg_focus,
            background_color = beautiful.bg_normal,
            forced_height = 15,
            forced_width  = 375,
            paddings      = {top = 16, bottom = 16},
            border_width  = 8,
            max_value = 100,
            value = 25,
            widget = wibox.widget.progressbar,
          },
        },
        {
          id = "volume_text",
          widget = wibox.widget.textbox,
          align = "center",
          valign = "bottom",
          font = beautiful.font .. " 16",
          margins = { bottom = 0 },
        },
        layout = wibox.layout.fixed.vertical,
        spacing = 10,
      },
      layout = wibox.layout.fixed.vertical,
    },
  }

  obj.hide_animation = rubato.timed {
    intro = 0.1,
    outro = 0.1,
    duration = 0.3,
    rate = 60,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
      obj.widget.x = pos
    end,
    complete = function()
      obj.widget.visible = false
    end
  }

  obj.hide_timer = gears.timer({
    timeout = 2,
    autostart = false,
    single_shot = true,
    callback = function()
      obj.hide_animation.target = -obj.widget.width - 30  -- Adjust target to move completely off screen
    end
  })

  local bouncy = {
    F = (20*math.sqrt(3)*math.pi-30*math.log(2)-6147) /
      (10*(2*math.sqrt(3)*math.pi-6147*math.log(2))),
    easing = function(t) return
      (4096*math.pi*math.pow(2, 10*t-10)*math.cos(20/3*math.pi*t-43/6*math.pi)
      +6144*math.pow(2, 10*t-10)*math.log(2)*math.sin(20/3*math.pi*t-43/6*math.pi)
      +2*math.sqrt(3)*math.pi-3*math.log(2)) /
      (2*math.pi*math.sqrt(3)-6147*math.log(2))
    end
  }

  obj.volume_animation = rubato.timed {
    intro = 0,
    outro = 0.1,
    duration = 0.15,
    rate = 60,
    easing = bouncy,
    subscribed = function(pos)
      local volume_bar = obj.widget:get_children_by_id("volume_bar")[1]
      volume_bar.value = pos
    end
  }

  obj.show_animation = rubato.timed {
    intro = 0.1,
    outro = 0.1,
    duration = 0.3,
    rate = 60,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
      obj.widget.x = pos
    end
  }

  awesome.connect_signal("volume::update", function(data)
    obj:show(data)
  end)

  return obj
end

function volume_osd:show(data)
  if data.skip_osd == false then
    local volume_text = self.widget:get_children_by_id("volume_text")[1]
    local volume_icon = self.widget:get_children_by_id("volume_icon")[1]
    volume_text.text = tostring(data.volume) .. " %"
    local icon = gears.color.recolor_image(volume_service.get_volume_icon(data.volume, data.muted), beautiful.fg_normal) 
    volume_icon.image = icon
    local volume_bar = self.widget:get_children_by_id("volume_bar")[1]
    self.volume_animation.target = data.volume
    self.widget.visible = true
    self.widget.screen = awful.screen.focused()
    self.widget.x = -self.widget.width
    self.show_animation.target = 30
    awful.placement.left(self.widget, { honor_workarea = true, margins = { left = 30 }, 
      prefer_horizontal = "left", 
      prefer_vertical = "center" })

    self.hide_animation.target = 30  -- Reset hide animation target
    self.hide_timer:stop()
    self.hide_timer:start()
  else
    self.hide_timer:start()
  end
end

return volume_osd:new()
