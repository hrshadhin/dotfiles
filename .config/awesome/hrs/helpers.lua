--[[

     Licensed under GNU General Public License v3
      * (c) 2022, H.R. Shadhin

--]]
local spawn = require("awful.spawn")
local timer = require("gears.timer")
local debug = require("debug")
local io = {lines = io.lines, open = io.open}
local rawget = rawget

-- HRS helper functions for internal use
-- hrs.helpers
local helpers = {}

-- {{{ Modules loader

function helpers.wrequire(t, k) return rawget(t, k) or require(t._NAME .. '.' .. k) end

-- }}}

-- {{{ Timer maker

helpers.timer_table = {}

function helpers.newtimer(name, timeout, fun, nostart, stoppable)
    if not name or #name == 0 then return end
    name = (stoppable and name) or timeout
    if not helpers.timer_table[name] then
        helpers.timer_table[name] = timer({timeout = timeout})
        helpers.timer_table[name]:start()
    end
    helpers.timer_table[name]:connect_signal("timeout", fun)
    if not nostart then helpers.timer_table[name]:emit_signal("timeout") end
    return stoppable and helpers.timer_table[name]
end

-- }}}

-- {{{ Pipe operations

-- run a command and execute a function on its output (asynchronous pipe)
-- @param cmd the input command
-- @param callback function to execute on cmd output
-- @return cmd PID
function helpers.async(cmd, callback)
    return spawn.easy_async(cmd, function(stdout, _, _, exit_code) callback(stdout, exit_code) end)
end

-- like above, but call spawn.easy_async with a shell
function helpers.async_with_shell(cmd, callback)
    return spawn.easy_async_with_shell(cmd, function(stdout, _, _, exit_code) callback(stdout, exit_code) end)
end

-- }}}

return helpers
