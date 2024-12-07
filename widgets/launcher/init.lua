local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local bling = require("lib.bling")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


local args = {


  terminal = "kitty",                                            -- Set default terminal
  search_commands = true,                                            -- Search by app name AND commandline command
  skip_names = { "Avahi VNC Server Browser",
                 "Avahi Zeroconf Browser",
                 "Avahi SSH Server Browser",
                 "CMake",
                 "Font Viewer",
                 "Electron 32",
                 "Qt V4L2 test Utility",
                 "Qt V4L2 video capture utility",
               },                                        -- List of apps to omit from launcher
  skip_commands = { "thunar" },                                      -- List of commandline commands to omit from launcher
  skip_empty_icons = true,                                           -- Skip applications without icons                                      -- When selecting by mouse, click once to select app, click once more to open the app.
  hide_on_left_clicked_outside = true,                               -- Hide launcher on left click outside the launcher popup
  hide_on_right_clicked_outside = true,                              -- Hide launcher on right click outside the launcher popup
  hide_on_launch = true,                                             -- Hide launcher when spawning application
  try_to_keep_index_after_searching = false,                         -- After a search, reselect the previously selected app
  reset_on_hide = true,                                              -- When you hide the launcher, reset search query
  save_history = true,                                               -- Save search history
  wrap_page_scrolling = true,                                        -- Allow scrolling to wrap back to beginning/end of launcher list
  wrap_app_scrolling = true,

  apps_per_row = 6,                                                  -- Set how many apps should appear in each row
  apps_per_column = 2,                                             -- Set how many apps should appear in each column
  apps_margin = {left = dpi(40), right = dpi(40), bottom = dpi(30)}, -- Margin between apps
  apps_spacing = dpi(10),

  icon_size = 24,

  type = "dock",                                                     -- awful.popup type ("dock", "desktop", "normal"...).  See awesomewm docs for more detail
  show_on_focused_screen = true,                                     -- Should app launcher show on currently focused screen
  screen = awful.screen,                                             -- Screen you want the launcher to launch to
  placement = function(c)
    awful.placement.right(c, { margins = { right = 64 } })  -- Adjust the right margin to shift left
  end,
  --rubato = { x = rubato_animation_x, y = rubato_animation_y },       -- Rubato animation to apply to launcher
  shrink_width = true,                                               -- Automatically shrink width of launcher to fit varying numbers of apps in list (works on apps_per_column)
  shrink_height = true,                                              -- Automatically shrink height of launcher to fit varying numbers of apps in list (works on apps_per_row)
  background = beautiful.bg_normal, -- Set bg color
  border_width = dpi(2),                                             -- Set border width of popup
  border_color = beautiful.bg_focus,                                          -- Set border color of popup


  prompt_height = dpi(50),                                           -- Prompt height
  prompt_margins = dpi(30),                                          -- Prompt margins
  prompt_paddings = dpi(15),                                         -- Prompt padding
  shape = function(cr, width, height)
    gears.shape.rectangle(cr, width, height)
  end,                                                               -- Set shape for prompt
  prompt_color = beautiful.bg_normal,                                          -- Prompt background color
  prompt_border_width = dpi(1),                                      -- Prompt border width
  prompt_border_color = "#000000",                                   -- Prompt border color
  prompt_text_halign = "center",                                     -- Prompt text horizontal alignment
  prompt_text_valign = "center",                                     -- Prompt text vertical alignment
  prompt_icon_text_spacing = dpi(10),                                -- Prompt icon text spacing
  prompt_show_icon = true,                                           -- Should prompt show icon (?)
  prompt_icon_font = "Comic Sans",                                   -- Prompt icon font
  prompt_icon_color = "#000000",                                     -- Prompt icon color
  prompt_icon = "",                                                 -- Prompt icon
  prompt_text = "<b>Search</b>:",                                    -- Prompt text
  prompt_start_text = "manager",                                     -- Set string for prompt to start with
  prompt_font = "Bahnschrift",                                        -- Prompt font
  prompt_text_color = "#FFFFFF",                                     -- Prompt text color
  prompt_cursor_color = "#000000",

  -- expand_apps = true,                                                -- Should apps expand to fill width of launcher
  -- app_width = dpi(400),                                              -- Width of each app
  -- app_height = dpi(40),                                              -- Height of each app
   app_shape = function(cr, width, height)
     gears.shape.rounded_rect(cr, width, height, dpi(4))
   end,                                                               -- Shape of each app
  -- app_normal_color = "#000000",                                      -- App normal color
  -- app_normal_hover_color = "#111111",                                -- App normal hover color
  app_selected_color = beautiful.bg_focus,                                    -- App selected color
  -- app_selected_hover_color = "#EEEEEE",                              -- App selected hover color
  -- app_content_padding = dpi(10),                                     -- App content padding
  -- app_content_spacing = dpi(10),                                     -- App content spacing
  app_show_icon = true,                                              -- Should show icon?
  -- app_icon_halign = "center",                                        -- App icon horizontal alignment
  app_icon_width = dpi(70),                                          -- App icon wigth
  app_icon_height = dpi(70),                                         -- App icon height
  app_show_name = true,                                              -- Should show app name?
  -- app_name_layout = wibox.layout.fixed.vertical,                     -- App name layout
  -- app_name_generic_name_spacing = dpi(0),                            -- Generic name spacing (If show_generic_name)
  -- app_name_halign = "center",                                        -- App name horizontal alignment
   app_name_font = "Bahnschrift",                                      -- App name font
  -- app_name_normal_color = "#FFFFFF",                                 -- App name normal color
  -- app_name_selected_color = "#000000",                               -- App name selected color
  -- app_show_generic_name = true, 


  sort_alphabetically = true,
  reverse_sort_alphabetically = false,
  select_before_spawn = false,
  favorites = { "firefox", "obsidian", "kitty" } 
}
-- set app_launcher with args_table
local app_launcher = bling.widget.app_launcher(args)

return app_launcher