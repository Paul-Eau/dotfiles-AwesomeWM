-- Import necessary modules
local capi = Capi
local tonumber = tonumber
local string = string
local gtimer = require("gears.timer")
local awful = require("awful")

-- CONFIG
local battery_service = {
  config = {
    interval = 3,
    app = "acpi",
  },
data = nil,
timer = nil,
}


-- COMMANDS
local commands = {}

-- Command to get volume and mute status
function commands.get_batteries_data()
  return " -b"
end

-- Command to get volume and mute status
function commands.get_adapter_connected()
  return " -a"
end


-- A mettre en commande bash :  " -a | grep -q \"on-line\" && echo 1 || echo 0"
local function parse_raw_adapter_connected_data(raw_data)
  local adapter_connected = 0

  for line in string.gmatch(raw_data, "([^\n]*)\n?") do
    if line:match("on-line") then
      adapter_connected = 1
    else
      adapter_connected = 0
    end
  end

  return {
    is_adapter_connected = adapter_connected,
  }
end


local function parse_raw_batteries_data(raw_data)
  local battery1_percentage = nil
  local battery2_percentage = nil
  local batteries_percentage = nil
  local time_until_charged = nil

  for line in string.gmatch(raw_data, "([^\n]*)\n?") do
      -- Parse Battery 0 percentage and time until charged
      if line:match("^Battery 0:") then
          battery1_percentage = tonumber(line:match("Battery 0: [%a%s,]+(%d+)%%"))
          time_until_charged = line:match("until charged") and line:match("(%d+:%d+:%d+)") or 0
      end

      -- Parse Battery 1 percentage
      if line:match("^Battery 1:") then
          battery2_percentage = tonumber(line:match("Battery 1: [%a%s,]+(%d+)%%"))
      end

  end

  -- Calculate average battery percentage
  if battery1_percentage and battery2_percentage then
      batteries_percentage = (battery1_percentage + battery2_percentage) / 2
  end

  return {
      bat0_level = battery1_percentage,
      bat1_level = battery2_percentage,
      bat_level = batteries_percentage,
      time_until_charged = time_until_charged,
  }
end


-- Process the command output to extract volume data and update the battery data
local function update_batteries_data(command, skip_osd)
    awful.spawn.easy_async(command, function(stdout, stderr, exitreason, exitcode)
        local data = {}
        if exitreason == "exit" and exitcode == 0 then
            data = parse_raw_batteries_data(stdout)
        end
        battery_service.data = battery_service.data or {}
        for k, v in pairs(data) do
            battery_service.data[k] = v
        end
        battery_service.data.skip_osd = skip_osd
        capi.awesome.emit_signal("battery::update", battery_service.data)
    end)
end


local function update_adapater_connected(command, skip_osd)
    awful.spawn.easy_async(command, function(stdout, stderr, exitreason, exitcode)
        local data = {}
            data = parse_raw_adapter_connected_data(stdout)
        battery_service.data = battery_service.data or {}
        for k, v in pairs(data) do
            battery_service.data[k] = v
        end
        battery_service.data.skip_osd = skip_osd
        capi.awesome.emit_signal("battery::update", battery_service.data)
    end)
end


-- DEBUG
local function print_battery_data(data)
    data = data or {}
    for k, v in pairs(data) do
        print(k .. ": " .. tostring(v))
    end
end


-- Fonctions à appeler à l'extérieur du service
function battery_service.get_battery_data()
  update_batteries_data(battery_service.config.app .. commands.get_batteries_data())  --update("acpi -b")
end

function battery_service.get_adapter_connected()
  update_adapater_connected(battery_service.config.app .. commands.get_adapter_connected())
end



-- Start watching the volume status at regular intervals
function battery_service.watch()
    battery_service.timer = battery_service.timer or gtimer {
        timeout = battery_service.config.interval,
        call_now = true,
        callback = function()
            update_batteries_data(battery_service.config.app .. commands.get_batteries_data(), true)
            update_adapater_connected(battery_service.config.app .. commands.get_adapter_connected(), true)
            --print_battery_data(battery_service.data or {})
        end,
    }
    battery_service.timer:again()
end



-- Return the volume service
return battery_service
