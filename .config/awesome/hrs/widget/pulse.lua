--[[

     Licensed under GNU General Public License v3
      * (c) 2022, H.R. Shadhin

--]]
local helpers = require("hrs.helpers")
local awful = require("awful")
local wibox = require("wibox")
local os, string = os, string

-- PulseAudio volume
-- hrs.widget.pulse

local function factory(args)
    args = args or {}

    local volume = {widget = args.widget or wibox.widget.textbox()}
    local timeout = args.timeout or 30
    local getcmd = args.getcmd or "pamixer --get-volume-human"
    local incrcmd = args.incrcmd or "pamixer -i"
    local decrcmd = args.decrcmd or "pamixer -d"
    local mutecmd = args.mutecmd or "pamixer -t"
    local setmaxcmd = args.setmaxcmd or "pamixer --set-volume 100"
    local settings = args.settings or function() end

    volume.widget:set_markup("N/A")

    function volume.update()
        helpers.async(getcmd, function(out)
            volume_now = out

            widget = volume.widget
            settings()
        end)
    end

    function volume.incr(step)
        os.execute(string.format("%s %s", incrcmd, step))
        volume.update()
    end

    function volume.decr(step)
        os.execute(string.format("%s %s", decrcmd, step))
        volume.update()
    end

    function volume.togglemute()
        os.execute(mutecmd)
        volume.update()
    end

    function volume.setmax()
        os.execute(setmaxcmd)
        volume.update()
    end

    volume.widget:buttons(awful.util.table.join(awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end), awful.button({}, 2, function() -- middle click
        volume.setmax()
    end), awful.button({}, 3, function() -- right click
        volume.togglemute()
    end), awful.button({}, 4, function() -- scroll up
        volume.incr(5)
    end), awful.button({}, 5, function() -- scroll down
        volume.decr(5)
    end)))

    helpers.newtimer("pulse", timeout, volume.update)

    return volume
end

return factory
