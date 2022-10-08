--[[

     HRS
     widgets and utilities for Awesome WM

     Widgets section

     Licensed under GNU General Public License v3
      * (c) 2022, H.R. Shadhin

--]]
local wrequire = require("hrs.helpers").wrequire
local setmetatable = setmetatable

local widget = {_NAME = "hrs.widget"}

return setmetatable(widget, {__index = wrequire})
