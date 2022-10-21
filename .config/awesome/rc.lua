local awesome, client, screen = awesome, client, screen
local string, os, tostring, type = string, os, tostring, type

-- Standard awesome library
local gears = require("gears") -- Utilities such as color parsing and objects
local awful = require("awful") -- Everything related to window managment
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 100

-- Custom layouts, widgets and utilities library
local lain = require("lain")

-- Freedesktop.org menu
local freedesktop = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

local themes = {
    "archmix", -- 1
    "archmix-lite" -- 2
}

-- choose your theme here
local chosen_theme = themes[2]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

local modkey = "Mod4"
local altkey = "Mod1"
local ctrlkey = "Control"
local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "vim"
local browser = "firefox"
local screenshot_save_path = "$HOME/Pictures/Screen\\ Shots/$(date +'%Y-%m-%d_%H%M%S').png"
local screenshot_full_cmd = "coreshot -f " .. screenshot_save_path
local screenshot_window_cmd = "coreshot -w " .. screenshot_save_path
local screenshot_selection_cmd = "coreshot -s " .. screenshot_save_path

-- awesome variables
awful.util.terminal = terminal
awful.util.tagnames = {"", "", "", "", "ﳜ", "", "", "", ""} -- use nerd fonts to view icons
-- awful.util.tagnames = {"TERM", "WWW", "DEV", "CHAT", "MEDIA", "FILES", "XYZ", "h@X0r", "vBox"}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.floating
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- lain.layout.cascade,
    -- lain.layout.cascade.tile,
    -- lain.layout.centerwork,
    -- lain.layout.centerwork.horizontal,
    -- lain.layout.termfair
    -- lain.layout.termfair.center
}

-- lain.layout.termfair.nmaster = 3
-- lain.layout.termfair.ncol = 1
-- lain.layout.termfair.center.nmaster = 3
-- lain.layout.termfair.center.ncol = 1
-- lain.layout.cascade.tile.offset_x = 2
-- lain.layout.cascade.tile.offset_y = 32
-- lain.layout.cascade.tile.extra_padding = 5
-- lain.layout.cascade.tile.nmaster = 5
-- lain.layout.cascade.tile.ncol = 2

-- Tag & tasklist mouse binding
-- LuaFormatter off
awful.util.taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({}, 3, function()
        local instance = nil

        return function()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

root.buttons(gears.table.join(
    awful.button({}, 3, function() awful.util.mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- LuaFormatter on

-- Build Menu
local myawesomemenu = {
    {"hotkeys", function() return false, hotkeys_popup.show_help end},
    {"manual", terminal .. " -e 'man awesome'"},
    {"edit config", terminal .. " -e " .. editor .. " " .. awesome.conffile},
    {"arandr", "arandr"},
    {"restart", awesome.restart}
}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {{"Awesome", myawesomemenu, beautiful.awesome_icon}},
    after = {
        {"Terminal", terminal},
        {"Log out", function() awesome.quit() end},
        {"Sleep", "systemctl suspend"},
        {"Restart", "systemctl reboot"},
        {"Exit", "systemctl poweroff"}
    }
})

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- Global Keybindings
-- LuaFormatter off
globalkeys = gears.table.join(
    -- Awesome keybindings
    awful.key({modkey}, "s", hotkeys_popup.show_help,
        {description = "show help", group = "awesome"}),
    awful.key({modkey}, "w", function() awful.util.mymainmenu:show() end,
        {description = "show main menu", group = "awesome"}),
    awful.key({modkey, ctrlkey}, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({modkey, "Shift"}, "q", awesome.quit,
        {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "Show/hide wibox (bar)", group = "awesome"}),

    -- Tag browsing with modkey
    awful.key({modkey}, "Left", awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({modkey}, "Right", awful.tag.viewnext,
            {description = "view next", group = "tag"}),
    awful.key({modkey}, "Escape", awful.tag.history.restore,
        {description = "go back", group = "tag"}),

    -- Tag browsing ALT+TAB (ALT+SHIFT+TAB)
    awful.key({ altkey,}, "Tab", awful.tag.viewnext,
        {description = "view next", group = "tag"}),
    awful.key({ altkey, "Shift" }, "Tab", awful.tag.viewprev,
        {description = "view previous", group = "tag"}),

    -- Non-empty tag browsing CTRL+TAB (CTRL+SHIFT+TAB)
    awful.key({ ctrlkey }, "Tab", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ ctrlkey, "Shift" }, "Tab", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),

    -- On the fly useless gaps change
    awful.key({ altkey, ctrlkey }, "j", function () lain.util.useless_gaps_resize(1) end,
        {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, ctrlkey }, "k", function () lain.util.useless_gaps_resize(-1) end,
        {description = "decrement useless gaps", group = "tag"}),

    -- Default client focus
    awful.key({modkey}, "j", function()awful.client.focus.byidx(1) end,
        {description = "focus next by index", group = "client"}),
    awful.key({modkey}, "k", function() awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}),
    awful.key({modkey, ctrlkey}, "n", function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "restore minimized", group = "client"}),

    -- By direction client focus
    awful.key({ altkey }, "j", function() awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end end,
        {description = "Focus down", group = "client"}),
    awful.key({ altkey }, "k", function() awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end end,
        {description = "Focus up", group = "client"}),
    awful.key({ altkey }, "h", function() awful.client.focus.global_bydirection("left")
        if client.focus then client.focus:raise() end end,
        {description = "Focus left", group = "client"}),
    awful.key({ altkey }, "l", function() awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end end,
        {description = "Focus right", group = "client"}),

    -- By direction client focus with arrows
    awful.key({ ctrlkey, modkey }, "Down", function() awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end end,
        {description = "Focus down", group = "client"}),
    awful.key({ ctrlkey, modkey }, "Up", function() awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end end,
        {description = "Focus up", group = "client"}),
    awful.key({ ctrlkey, modkey }, "Left", function() awful.client.focus.global_bydirection("left")
        if client.focus then client.focus:raise() end end,
        {description = "Focus left", group = "client"}),
    awful.key({ ctrlkey, modkey }, "Right", function() awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end end,
        {description = "Focus right", group = "client"}),

    -- Layout manipulation
    awful.key({modkey}, "space", function() awful.layout.inc(1) end,
        {description = "select next", group = "layout"}),
    awful.key({modkey, "Shift"}, "space", function() awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}),
    awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end,
        {description = "swap with next client by index", group = "client"}),
    awful.key({modkey, "Shift"}, "k", function() awful.client.swap.byidx(-1) end,
        {description = "swap with previous client by index", group = "client"}),
    awful.key({modkey, ctrlkey}, "j", function() awful.screen.focus_relative(1) end,
        {description = "focus the next screen", group = "screen"}),
    awful.key({modkey, ctrlkey}, "k", function() awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),
    awful.key({modkey}, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),
    awful.key({modkey}, "Tab", function() awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end end,
        {description = "go back", group = "client"}),
    awful.key({modkey}, "l", function() awful.tag.incmwfact(0.05) end,
        {description = "increase master width factor", group = "layout"}),
    awful.key({modkey}, "h", function() awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}),
    awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),
    awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),
    awful.key({modkey, ctrlkey}, "h", function() awful.tag.incncol(1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}),
    awful.key({modkey, ctrlkey}, "l", function() awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}),

    -- Widgets popups
    awful.key({ altkey, }, "c", function () lain.widget.cal.show(7) end,
        {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
        {description = "show filesystem", group = "widgets"}),
    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
        {description = "show weather", group = "widgets"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
        {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
        {description = "-10%", group = "hotkeys"}),

    -- audio control
    awful.key({}, "XF86AudioMute",
        function()
            beautiful.volume.togglemute()
        end),
    awful.key({}, "XF86AudioLowerVolume",
        function()
            beautiful.volume.decr(5)
        end),
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            beautiful.volume.incr(5)
        end),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
        {description = "copy terminal to gtk", group = "hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
        {description = "copy gtk to terminal", group = "hotkeys"}),

    -- Luncher
    awful.key({modkey}, "Return", function() awful.spawn(terminal) end,
        {description = "open a terminal", group = "hotkeys"}),
    awful.key({modkey}, "r", function() awful.util.spawn("dmenu_run -h 24") end,
        {description = "run demenu", group = "hotkeys"}),

    -- Applications
    awful.key({modkey}, "b", function() awful.util.spawn(browser) end,
        {description = "firefox", group = "applications"}),
    awful.key({modkey, altkey}, "b", function() awful.spawn.with_shell(string.format("%s/.config/awesome/riis.sh browser", os.getenv("HOME"))) end,
        {description = "chromium", group = "applications"}),
    awful.key({modkey, altkey}, "d", function() awful.spawn.with_shell(string.format("%s/.config/awesome/riis.sh browser-dev", os.getenv("HOME"))) end,
        {description = "chromium dev profile", group = "applications"}),
    awful.key({modkey, altkey}, "o", function() awful.spawn.with_shell(string.format("%s/.config/awesome/riis.sh browser-office", os.getenv("HOME"))) end,
        {description = "chromium office profile", group = "applications"}),

    -- Screenshot
    awful.key({}, "Print", function() awful.spawn.with_shell(screenshot_full_cmd) end,
        {description = "full screen", group = "screenshots"}),
    awful.key({altkey}, "Print", function() awful.spawn.with_shell(screenshot_window_cmd) end,
        {description = "active window", group = "screenshots"}),
    awful.key({altkey, ctrlkey}, "Print", function() awful.spawn.with_shell(screenshot_selection_cmd) end,
        {description = "selection area", group = "screenshots"})

)

clientkeys = gears.table.join(
    awful.key({modkey}, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({modkey, "Shift"}, "c", function(c) c:kill() end,
        {description = "close", group = "client"}),
    awful.key({modkey, ctrlkey}, "space", awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),
    awful.key({modkey, ctrlkey}, "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}),
    awful.key({modkey}, "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}),
    awful.key({modkey}, "t", function(c) c.ontop = not c.ontop end,
        {description = "toggle keep on top", group = "client"}),
    awful.key({modkey}, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}),
    awful.key({modkey}, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({modkey}, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then tag:view_only() end
            end,
            {description = "view tag #" .. i, group = "tag"}), 
        -- Toggle tag display.
        awful.key({modkey, ctrlkey}, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then awful.tag.viewtoggle(tag) end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({modkey, "Shift"}, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({modkey, ctrlkey, "Shift"}, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:toggle_tag(tag) end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({modkey}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({modkey}, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- LuaFormatter on

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },
    -- Titlebars
    {rule_any = {type = {"dialog", "normal"}}, properties = {titlebars_enabled = false}},

    -- Set applications to always map on the tag 1 on screen 1.
    -- find class or role via xprop command

    -- { rule = { class = "Firefox" },  properties = { screen = 1, tag = awful.util.tagnames[2] }},

    {rule = {class = "Gimp", role = "gimp-image-window-1"}, properties = {maximized = true}},

    {rule = {class = "inkscape"}, properties = {maximized = true}},

    {rule = {class = "Vlc"}, properties = {maximized = true}},

    {rule = {class = "VirtualBox Manager"}, properties = {maximized = true}},

    {rule = {class = "VirtualBox Machine"}, properties = {maximized = true}},
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA" -- Firefox addon DownThemAll.
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "clipit",
                "Galculator",
                "Gpick",
                "Font-manager",
                "Kruler",
                "MessageWin", -- kalarm.
                "Oblogout",
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    }
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    -- LuaFormatter off
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
    -- LuaFormatter on

    awful.titlebar(c, {size = 21}):setup{
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("mouse::enter", function(c) c:emit_signal("request::activate", "mouse_enter", {raise = false}) end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("property::maximized", function(c) c.border_width = 0 end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart applications
awful.spawn.with_shell(string.format("%s/.config/awesome/autorun.sh", os.getenv("HOME")))
