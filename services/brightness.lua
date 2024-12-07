-- DEPENDENCIES: brightnessctl

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

function commands.change_brightness(direction, step)
    step = step or 1.25
    return " set " .. (direction == "inc" and "+" or "") .. string.format("%.0f", step) .. (direction == "inc" and "%" or "%-")
end

local function parse_raw_data(raw_data)
    local brightness = nil
    local max_brightness = 6818  -- Maximum brightness level

    local l = 1
    for line in string.gmatch(raw_data, "([^\n]*)\n?") do
        if l == 1 then
            local brightness_text = line:match("(%d+)")
            brightness = tonumber(brightness_text)
            if brightness then
                brightness = math.floor((brightness / max_brightness) * 100 + 0.5)  -- Round to nearest integer
            end
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
    print("Executing command:", command)
    awful.spawn.easy_async(command, function(...)
        brightness_service.data = process_command_output(...) or {}
        brightness_service.data.skip_osd = skip_osd
        awesome.emit_signal("brightness::update", brightness_service.data)
    end)
end

function brightness_service.get_brightness_icon(brightness)
    if brightness > 75 then
        return "/path/to/brightness_high_icon.png"
    elseif brightness > 50 then
        return "/path/to/brightness_medium_icon.png"
    elseif brightness > 25 then
        return "/path/to/brightness_low_icon.png"
    else
        return "/path/to/brightness_very_low_icon.png"
    end
end

function brightness_service.set_brightness(brightness, skip_osd)
    update(brightness_service.config.app .. commands.set_brightness(brightness) .. commands.get_data(), skip_osd)
end


function brightness_service.change_brightness(step, skip_osd)
    update(brightness_service.config.app .. commands.change_brightness(step), skip_osd)
end


function brightness_service.get_brightness()
    awful.spawn.easy_async(brightness_service.config.app .. commands.get_data(), function(stdout)
        local data = process_command_output(stdout)
        if data and data.brightness then
            awesome.emit_signal("brightness::current", data.brightness)
        end
    end)
end

function brightness_service.adjust_brightness(direction, step, skip_osd)
    if brightness_service.timer_adjust and brightness_service.timer_adjust.started then
        -- Brightness adjustment already in progress
        return
    end

    local I = 0
    local max_iterations = 10

    local function adjust_step()
        if I >= max_iterations then
            brightness_service.timer_adjust:stop()
            brightness_service.timer_adjust = nil
            return
        end

        local cmd = brightness_service.config.app .. commands.change_brightness(direction, step)
        print("Executing adjust_brightness command:", cmd)
        awful.spawn.easy_async(
            cmd,
            function(stdout, stderr, reason, exit_code)
                if exit_code == 0 then
                    brightness_service.get_brightness()
                    brightness_service.data.skip_osd = skip_osd
                    awesome.emit_signal("brightness::update", brightness_service.data)
                else
                    print("Brightness adjustment failed:", stderr)
                end
            end
        )
        I = I + 1
    end

    brightness_service.timer_adjust = gtimer {
        timeout = 0.025,  -- Increased timeout to prevent rapid spamming
        autostart = true,
        callback = adjust_step,
    }
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

brightness_service.watch()

return brightness_service
