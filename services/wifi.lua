-- Import necessary modules
local tonumber = tonumber
local gtimer = require("gears.timer")
local awful = require("awful")

-- CONFIG
local wifi_service = {
  config = {
    interval = 3,
    app = "nmcli",
  },
data = nil,
timer = nil,
}


-- COMMANDS
local commands = {}

-- Command to get signal strength data
function commands.get_signal_strenght_data()
  return ' -t -f ACTIVE,SIGNAL dev wifi | grep \'^yes\' | cut -d\':\' -f2'
end

function commands.get_networks_data()
  return ' -t -f SSID,MODE,SIGNAL dev wifi list'
end

function commands.connect_to_network(ssid, password)
  return ' device wifi connect ' .. ssid .. ' password ' .. password
end

function commands.disable_wifi()
  return ' radio wifi off'
end

function commands.enable_wifi()
  return ' radio wifi on'
end



local function parse_raw_signal_strenght_data(raw_data)
  local signal = tonumber(raw_data) or -1 -- Si aucun signal, retourne -1

  return {
      signal_strenght = signal,
  }
end


-- Process the command output to extract signal strength data and update the wifi data
local function update_signal_strenght_data(command, skip_osd)
    awful.spawn.easy_async_with_shell(command, function(stdout, stderr, exitreason, exitcode)
        local data = {}
        if exitreason == "exit" and exitcode == 0 then
            data = parse_raw_signal_strenght_data(stdout)
        end
        wifi_service.data = wifi_service.data or {}
        for k, v in pairs(data) do
            wifi_service.data[k] = v
        end
        wifi_service.data.skip_osd = skip_osd
        awesome.emit_signal("wifi::update", wifi_service.data)
    end)
end




-- DEBUG
local function print_wifi_data(data)
    data = data or {}
    for k, v in pairs(data) do
        print(k .. ": " .. tostring(v))
    end
    print("----------------------")
end


-- Fonctions à appeler à l'extérieur du service
function wifi_service.get_signal_strenght()
  update_signal_strenght_data(wifi_service.config.app .. commands.get_signal_strenght_data())  --update("acpi -b")
end

function wifi_service.get_networks()
end

function wifi_service.connect_to_network(ssid, password)
  update_signal_strenght_data(wifi_service.config.app .. commands.connect_to_network(ssid, password))  --update("acpi -b")
end

function wifi_service.disable_wifi()
  awful.spawn.easy_async_with_shell(wifi_service.config.app .. commands.disable_wifi())
end

function wifi_service.enable_wifi()
  awful.spawn.easy_async_with_shell(wifi_service.config.app .. commands.enable_wifi())
end





-- Start watching the wifi signal strength at regular intervals
function wifi_service.watch()
    wifi_service.timer = wifi_service.timer or gtimer {
        timeout = wifi_service.config.interval,
        call_now = true,
        callback = function()
            update_signal_strenght_data(wifi_service.config.app .. commands.get_signal_strenght_data(), true)
            print_wifi_data(wifi_service.data or {})
        end,
    }
    wifi_service.timer:again()
end


-- start battery service
wifi_service.watch()

-- Return the volume service
return wifi_service
