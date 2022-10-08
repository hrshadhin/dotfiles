--[[

     Licensed under GNU General Public License v3
      * (c) 2022, H.R. Shadhin

--]]
local helpers = require("hrs.helpers")
local wibox = require("wibox")
local tonumber = tonumber

-- {thermal,core,gpu,ssd,motherboard} temperature info
-- hrs.widget.temp

local function factory(args)
    args = args or {}

    local temp = {widget = args.widget or wibox.widget.textbox()}
    local timeout = args.timeout or 30
    local tempfile = args.tempfile or ""
    local tempcmd = args.tempcmd or ""
    local format = args.format or "%.1f"
    local na_markup = args.na_markup or " N/A "
    local settings = args.settings or function() end

    temp.widget:set_markup(na_markup)

    function temp.update()
        if string.len(tempfile) > 0 then
            helpers.async({"cat", tempfile}, function(out)
                temp_value = tonumber(out)
                temp_value = temp_value and temp_value / 1e3 or temp_value
                temp_now = string.format(format, temp_value)

                widget = temp.widget
                settings()
            end)
        elseif string.len(tempcmd) > 0 then
            helpers.async(tempcmd, function(out)
                temp_now = string.format(format, out)

                widget = temp.widget
                settings()
            end)
        end
    end

    helpers.newtimer("thermal", timeout, temp.update)

    return temp
end

return factory
