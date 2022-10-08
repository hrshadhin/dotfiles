--[[

     Licensed under GNU General Public License v3
      * (c) 2022, H.R. Shadhin

--]]
local helpers = require("hrs.helpers")
local awful = require("awful")
local focused = require("awful.screen").focused
local wibox = require("wibox")
local naughty = require("naughty")
local os, string, math = os, string, math

-- Mail IMAP
-- hrs.widget.mail

local function factory(args)
    args = args or {}

    local mail = {widget = args.widget or wibox.widget.textbox()}
    local timeout = args.timeout or 3600
    local cmd = args.cmd or string.format("python3 %s/.config/awesome/hrs/widget/check_gmail.py", os.getenv("HOME"))
    local notification_preset = args.notification_preset or {}
    local settings = args.settings or function() end
    local notification_text = " N/A "

    mail.widget:set_markup(" N/A ")

    function mail.check()
        helpers.async(cmd, function(out)
            notification_text = out
            local sum = 0
            for d in out:gmatch("%d") do sum = sum + d end
            Totalmail = math.floor(sum)

            widget = mail.widget
            settings()
        end)
    end

    function mail.hide()
        if not mail.notification then return end
        naughty.destroy(mail.notification)
        mail.notification = nil
    end

    function mail.show(seconds)
        notification_preset.screen = focused()
        mail.notification = naughty.notify {preset = notification_preset, text = notification_text, timeout = seconds}
    end

    mail.widget:connect_signal('mouse::enter', function() mail.show(0) end)
    mail.widget:connect_signal('mouse::leave', function() mail.hide() end)

    helpers.newtimer("mail", timeout, mail.check)

    return mail
end

return factory
