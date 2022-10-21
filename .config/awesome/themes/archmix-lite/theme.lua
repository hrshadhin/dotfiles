-------------------------------
--  "Archmix Lite" awesome theme  --
--    By H.R. Shadhin        --
-------------------------------
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local hrs = require("hrs")

local math, string, os = math, string, os

local theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/themes/archmix-lite"
theme.wallpaper = theme.dir .. "/background.jpg"
theme.font = "Terminus 14"
theme.icon_font = "Source Code Pro 16"
theme.taglist_font = "Source Code Pro 22"
theme.bg_normal = "#0b4968"
theme.bg_focus = "#1793d1"
theme.bg_urgent = "#e53834"
theme.bg_minimize = "#444444"
theme.bg_systray = "#0b4968"
theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"
theme.taglist_fg_focus = theme.bg_focus
theme.taglist_bg_focus = "#000000"
theme.taglist_fg_occupied = "#0b4968"
theme.taglist_fg_urgent = theme.bg_urgent
theme.taglist_bg_urgent = ""
theme.taglist_fg_empty = "#828282"
theme.taglist_spacing = 3
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_normal = theme.fg_normal
theme.border_width = 2
theme.border_focus = theme.bg_focus
theme.border_normal = theme.bg_normal
theme.border_marked = theme.bg_focus
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_focus = theme.fg_focus
theme.titlebar_fg_normal = theme.fg_normal
theme.wibar_bg = "#222222"
theme.wibar_fg = "#1793d1"
theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = "#ffffff"
theme.hotkeys_border_color = theme.bg_focus
theme.hotkeys_modifiers_fg = "#AFAFAF"
theme.box_margin = 7
theme.box_unline = 2
theme.color00 = "#2c292d" -- # ----
theme.color01 = "#4a474a" -- # ---
theme.color02 = "#676568" -- # --
theme.color03 = "#858385" -- # -
theme.color04 = "#a3a2a2" -- # +
theme.color05 = "#c1c0bf" -- # ++
theme.color06 = "#dededd" -- # +++
theme.color07 = "#fcfcfa" -- # ++++
theme.color08 = "#ff6188" -- # red
theme.color09 = "#fc9867" -- # orange
theme.color0A = "#ffd866" -- # yellow
theme.color0B = "#a9dc76" -- # green
theme.color0C = "#78dce8" -- # cyan
theme.color0D = "#66d9ef" -- # blue
theme.color0E = "#ab9df2" -- # purple
theme.color0F = "#cc6633" -- # brown

theme.menu_height = 20
theme.menu_width = 140
theme.menu_submenu_icon = theme.dir .. "/icons/submenu.png"
theme.awesome_icon = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel = theme.dir .. "/icons/taglist/sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/taglist/unsel.png"
theme.layout_tile = theme.dir .. "/icons/layouts/tile.png"
theme.layout_tileleft = theme.dir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom = theme.dir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop = theme.dir .. "/icons/layouts/tiletop.png"
theme.layout_floating = theme.dir .. "/icons/layouts/floating.png"
theme.layout_fairv = theme.dir .. "/icons/layouts/fairv.png"
theme.layout_fairh = theme.dir .. "/icons/layouts/fairh.png"
theme.layout_spiral = theme.dir .. "/icons/layouts/spiral.png"
theme.layout_dwindle = theme.dir .. "/icons/layouts/dwindle.png"
theme.layout_max = theme.dir .. "/icons/layouts/max.png"
theme.layout_fullscreen = theme.dir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier = theme.dir .. "/icons/layouts/magnifier.png"
theme.lain_icons = os.getenv("HOME") .. "/.config/awesome/lain/icons/layout/zenburn/"
theme.layout_termfair = theme.lain_icons .. "termfair.png"
theme.layout_centerfair = theme.lain_icons .. "centerfair.png"
theme.layout_cascade = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png"
theme.layout_centerwork = theme.lain_icons .. "centerwork.png"
theme.layout_centerworkh = theme.lain_icons .. "centerworkh.png"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
theme.useless_gap = 4
theme.titlebar_close_button_focus = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.gnu_logo = theme.dir .. "/gnu.png"

local markup = lain.util.markup
local function mywidget(icon, wbox, colorLine, fgcolor, leftIn, rightIn, underLineSize, wiboxMargin)
    return {
        {
            {
                wibox.container.margin(wibox.widget {icon, wbox, layout = wibox.layout.align.horizontal}, leftIn,
                                       rightIn),
                fg = fgcolor,
                widget = wibox.container.background
            },
            bottom = underLineSize,
            color = colorLine,
            fg = fgcolor,
            layout = wibox.container.margin
        },
        left = wiboxMargin,
        right = wiboxMargin,
        bottom = 2,
        layout = wibox.container.margin
    }
end

-- GNU Logo
local gnulogo = wibox.widget {
    image = theme.gnu_logo,
    resize = true,
    valign = "center",
    halign = "center",
    widget = wibox.widget.imagebox
}

local separator = wibox.widget.textbox(" ⏽ ")

-- MEM
local memicon = wibox.widget.textbox()
memicon:set_markup(markup.fontfg(theme.icon_font, theme.color0B, ""))
local mem = lain.widget.mem({
    settings = function() widget:set_markup(markup.fontfg(theme.font, theme.wibar_fg, " " .. mem_now.used .. " MB")) end
})
local membox = mywidget(memicon, mem, theme.color0B, theme.wibar_fg, 0, 0, theme.box_unline, theme.box_margin)

-- CPU
local cpuicon = wibox.widget.textbox()
cpuicon:set_markup(markup.fontfg(theme.icon_font, theme.color0C, ""))
local cpu = lain.widget.cpu({
    settings = function() widget:set_markup(markup.fontfg(theme.font, theme.wibar_fg, " " .. cpu_now.usage .. "% ")) end
})
local cpubox = mywidget(cpuicon, cpu, theme.color0C, theme.wibar_fg, 0, 0, theme.box_unline, theme.box_margin)

-- CPU Temp
local ctempicon = wibox.widget.textbox();
ctempicon:set_markup(markup.fontfg("Source Code Pro 12", theme.color08, " "))
local ctemp = hrs.widget.temp({
    tempfile = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1/temp1_input",
    timeout = 60,
    settings = function() widget:set_markup(markup.font(theme.font, temp_now .. "°C")) end
})
local cputempbox = mywidget(ctempicon, ctemp.widget, theme.color08, theme.wibar_fg, 0, 0, theme.box_unline,
                            theme.box_margin)
-- NVME Temp
local ntempicon = wibox.widget.textbox();
ntempicon:set_markup(markup.fontfg("Source Code Pro 12", theme.color09, " "))
local ntemp = hrs.widget.temp({
    tempfile = "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/nvme/nvme0/hwmon0/temp1_input",
    timeout = 60,
    settings = function() widget:set_markup(markup.font(theme.font, temp_now .. "°C")) end
})
local nvmetempbox = mywidget(ntempicon, ntemp.widget, theme.color09, theme.wibar_fg, 0, 0, theme.box_unline,
                             theme.box_margin)

-- Net
local neticon = wibox.widget.textbox();
neticon:set_markup(markup.fontfg(theme.icon_font, theme.color0E, ""))
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, theme.wibar_fg,
                                        " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
    end
})
local netbox = mywidget(neticon, net.widget, theme.color0E, theme.wibar_fg, 0, 0, theme.box_unline, theme.box_margin)

-- Pulse volume
local volicon = wibox.widget.textbox();
volicon:set_markup(markup.fontfg(theme.icon_font, theme.color0D, "墳 "))
local volume = hrs.widget.pulse({settings = function() widget:set_markup(markup.font(theme.font, volume_now)) end})
theme.volume = volume
local volumebox = mywidget(volicon, volume.widget, theme.color0D, theme.wibar_fg, 0, 0, theme.box_unline,
                           theme.box_margin)

-- Mail IMAP check
local mailicon = wibox.widget.textbox();
mailicon:set_markup(markup.fontfg(theme.icon_font, theme.color0B, ""))
local mail = hrs.widget.mail({
    settings = function() widget:set_markup(markup.font(theme.font, " " .. Totalmail .. " ")) end
})
local mailbox = mywidget(mailicon, mail.widget, theme.color0B, theme.wibar_fg, 0, 0, theme.box_unline, theme.box_margin)

-- Textclock
local clockicon = wibox.widget.textbox()
clockicon:set_markup(markup.fontfg(theme.icon_font, theme.color0F, ""))
local clock = wibox.widget.textclock(markup.fontfg(theme.font, theme.wibar_fg, " %H:%M"), 1)
local clockbox = mywidget(clockicon, clock, theme.color0F, theme.wibar_fg, 0, 0, theme.box_unline, theme.box_margin)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = {clock},
    notification_preset = {font = theme.font, fg = theme.fg_normal, bg = theme.bg_normal}
})

function theme.at_screen_connect(s)

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- All tags open with layout 1
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(awful.button({}, 1, function() awful.layout.inc(1) end),
                                           awful.button({}, 3, function() awful.layout.inc(-1) end),
                                           awful.button({}, 4, function() awful.layout.inc(1) end),
                                           awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    -- s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({position = "top", screen = s, height = 24, bg = theme.wibar_bg .. "00"})

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            gnulogo,
            separator,
            s.mytaglist
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            netbox,
            membox,
            cpubox,
            cputempbox,
            nvmetempbox,
            mailbox,
            volumebox,
            clockbox,
            s.mylayoutbox
        }
    }
end

return theme
