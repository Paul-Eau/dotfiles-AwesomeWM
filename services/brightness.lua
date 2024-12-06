-- DEPENDENCIES: brightnessctl

local capi = Capi
local tonumber = tonumber
local string = string
local gtimer = require("gears.timer")
local awful = require("awful")

local brightness_service = {
    config = {
        interval = 3,
        app = "brightnessctl",
    },
    data = nil,
    timer = nil,
}

local commands = {}

function commands.get_data()
    return " get"
end

function commands.set_brightness(brightness)
    return " set " .. string.format("%.0f", brightness) .. "%"
end

function commands.change_brightness(step)
    step = step or 1
    return " set " .. (step > 0 and "+" or "") .. string.format("%.0f", step) .. "%"
end

local function parse_raw_data(raw_data)
    local brightness = nil

    local l = 1
    for line in string.gmatch(raw_data, "([^\n]*)\n?") do
        if l == 1 then
            local brightness_text = line:match("(%d+)")
            brightness = tonumber(brightness_text)
        else
            break
        end
        l = l + 1
    end

    return {
        brightness = brightness,
    }
end

local function process_command_output(stdout, stderr, exitreason, exitcode)
    local data = nil
    if exitreason == "exit" and exitcode == 0 then
        data = parse_raw_data(stdout)
    end
    return data
end

local function update(command, skip_osd)
    awful.spawn.easy_async(command, function(...)
        brightness_service.data = process_command_output(...) or {}
        brightness_service.data.skip_osd = skip_osd
        capi.awesome.emit_signal("brightness::update", brightness_service.data)
    end)
end

function brightness_service.set_brightness(brightness, skip_osd)
    update(brightness_service.config.app .. commands.set_brightness(brightness) .. commands.get_data(), skip_osd)
end

function brightness_service.change_brightness(step, skip_osd)
    update(brightness_service.config.app .. commands.change_brightness(step) .. commands.get_data(), skip_osd)
end

function brightness_service.get_brightness()
    awful.spawn.easy_async(brightness_service.config.app .. commands.get_data(), function(stdout)
        local data = process_command_output(stdout)
        if data and data.brightness then
            capi.awesome.emit_signal("brightness::current", data.brightness)
        end
    end)
end

function brightness_service.watch()
    brightness_service.timer = brightness_service.timer or gtimer {
        timeout = brightness_service.config.interval,
        call_now = true,
        callback = function()
            update(brightness_service.config.app .. commands.get_data(), true)
        end,
    }
    brightness_service.timer:again()
end

function brightness_service.brightness_on_battery()
    brightness_service.timer = brightness_service.timer or gtimer {
        timeout = 4,
        call_now = true,
        callback = function()
            brightness_service.set_brightness(10, true) -- Set brightness to 10% after 60 seconds of inactivity
        end,
    }
    brightness_service.timer:again()
end



brightness_service.watch()
brightness_service.get_brightness()
brightness_service.brightness_on_battery() -- Call the function to start monitoring inactivity

return brightness_service
