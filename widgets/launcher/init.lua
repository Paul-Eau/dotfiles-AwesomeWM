local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local launcher_widget = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = 10,
}

local function create_app_button(app)
  local button = wibox.widget {
    {
      {
        image = app.icon,
        resize = true,
        forced_width = 32,   -- Add this line back
        forced_height = 32,  -- Add this line back
        widget = wibox.widget.imagebox,
      },
      margins = 5,
      widget = wibox.container.margin,
    },
    {
      text = app.name,
      forced_height = 20,  -- Add this line
      widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
  }

  button:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.spawn(app.exec)
    end)
  ))

  return button
end

local function get_icon_path(icon_name)
  local icon_dirs = {
    '/usr/share/icons/hicolor/',
    '/usr/share/icons/',
    '/usr/share/pixmaps/',
  }
  local icon_extensions = { '.png', '.svg', '.xpm' }
  for _, dir in ipairs(icon_dirs) do
    for _, ext in ipairs(icon_extensions) do
      local path = dir .. '*/' .. icon_name .. ext
      local cmd = 'find ' .. dir .. ' -name "' .. icon_name .. ext .. '"'
      local handle = io.popen(cmd)
      local result = handle:read("*a")
      handle:close()
      local icon_file = result:match("[^\r\n]+")
      if icon_file and gears.filesystem.file_readable(icon_file) then
        return icon_file
      end
    end
  end
  return nil
end

local function load_applications()
  local apps = {}
  local handle = io.popen("ls /usr/share/applications/*.desktop")
  local result = handle:read("*a")
  handle:close()

  for desktop_file in result:gmatch("[^\r\n]+") do
    local app = {}
    for line in io.lines(desktop_file) do
      if line:match("^Name=") then
        app.name = line:sub(6)
      elseif line:match("^Exec=") then
        app.exec = line:sub(6)
      elseif line:match("^Icon=") then
        local icon_name = line:sub(6)
        app.icon = get_icon_path(icon_name)
      end
    end
    if app.name and app.exec and app.icon then
      table.insert(apps, app)
    end
  end

  return apps
end

local applications = load_applications()
for _, app in ipairs(applications) do
  launcher_widget:add(create_app_button(app))
end

local launcher_wibox

local function show_launcher()
  if not launcher_wibox then
    launcher_wibox = awful.popup {
      widget = launcher_widget,
      ontop = true,
      visible = false,
      shape = gears.shape.rectangle,
      border_width = 2,
      border_color = '#777777',
      maximum_height = 600,
      maximum_width = 800,
      placement = awful.placement.centered,
    }
  end
  launcher_wibox.visible = not launcher_wibox.visible
end

return {
  launcher_widget = launcher_widget,
  show_launcher = show_launcher,
}