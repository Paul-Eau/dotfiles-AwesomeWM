local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local rubato = require("lib.rubato") -- Add rubato for animations
local bling = require("lib.bling")


local bar_size = 64

bling.widget.tag_preview.enable {
    show_client_content = true,  -- Whether or not to show the client content
    scale = 0.25,                 -- The scale of the previews compared to the screen
    honor_padding = true,        -- Honor padding when creating widget size
    honor_workarea = true,       -- Honor work area when creating widget size
    placement_fn = function(c)    -- Place the widget using awful.placement (this overrides x & y)
        awful.placement.top_right(c, {
            margins = {
                top = 1.25 * bar_size,
                right = 1 * bar_size
            }
        })
    end,
    background_widget = wibox.widget {    -- Set a background image (like a wallpaper) for the widget 
        image = beautiful.wallpaper,
        horizontal_fit_policy = "fit",
        vertical_fit_policy   = "fit",
        widget = wibox.widget.imagebox
    }
}

local function tags_list_widget(s)
    return wibox.widget {
        {
            margins = 2,
            widget  = wibox.container.margin,
            -- Taglist
            awful.widget.taglist {
                screen  = s,
                filter  = function(t) return t.index <= 5 end, -- Display only the first 5 tags
                buttons = gears.table.join(
                    awful.button({}, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                        if client.focus then
                            client.focus:move_to_tag(t)
                        end
                    end),
                    awful.button({}, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                        if client.focus then
                            client.focus:toggle_tag(t)
                        end
                    end),
                    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
                ),
                layout = {
                    spacing = 10, -- Set spacing between tags
                    layout  = wibox.layout.fixed.horizontal,
                },

                widget_template = {
                    {
                        margins = 5,
                        widget  = wibox.container.margin,
                        -- Container for the icon
                        {
                            widget = wibox.container.place, -- Center the icon
                            {
                                id     = 'icon_role',
                                widget = wibox.widget.imagebox,
                                forced_height = 32,
                                forced_width = 32,
                            },
                        },
                    },
                    -- Custom container for the tag background
                    id     = 'background_container',
                    widget = wibox.container.background,
                    shape  = gears.shape.circle,
                    bg     = beautiful.tag_bg_normal or "#444444",
                    create_callback = function(self, tag, _, _)
                        local icon_widget = self:get_children_by_id('icon_role')[1]

                        -- Function to update the icon and background
                        local function update_tag()
                            if tag.selected then
                                self.bg = beautiful.bg_focus -- Red background when selected
                                self.forced_width = 32 -- Larger size for active tags
                                self.forced_height = 32
                            else
                                self.bg = beautiful.tag_bg_normal or "#444444" -- Default gray
                                self.forced_width = 32 -- Normal size for inactive tags
                                self.forced_height = 32
                            end

                            -- Update icon based on number of clients
                            local icon_path
                            if #tag:clients() > 0 then
                                icon_path = beautiful.tag_dot or gears.filesystem.get_configuration_dir() .. "theme/default/tags/tag-dot.svg"
                            else
                                icon_path = beautiful.tag_dot_empty or gears.filesystem.get_configuration_dir() .. "theme/default/tags/tag-dot-empty.svg"
                            end
                            icon_widget.image = gears.color.recolor_image(icon_path, beautiful.fg_normal)
                        end

                        -- Initial update
                        update_tag()

                        -- Connect signals to dynamically update
                        tag:connect_signal("property::selected", update_tag)
                        tag:connect_signal("tagged", update_tag)
                        tag:connect_signal("untagged", update_tag)
                        tag:connect_signal("property::urgent", update_tag)

                        -- BLING: Only show widget when there are clients in the tag
                        self:connect_signal('mouse::enter', function()
                            if #tag:clients() > 0 then
                                -- BLING: Update the widget with the new tag
                                awesome.emit_signal("bling::tag_preview::update", tag)
                                -- BLING: Show the widget
                                awesome.emit_signal("bling::tag_preview::visibility", s, true)
                            end
                        end)
                        self:connect_signal('mouse::leave', function()
                            -- BLING: Turn the widget off
                            awesome.emit_signal("bling::tag_preview::visibility", s, false)
                        end)
                    end,
                    update_callback = function(self, tag, _, _)
                        -- Ensure consistency during updates
                        local icon_widget = self:get_children_by_id('icon_role')[1]
                        if tag.selected then
                            self.bg = beautiful.bg_focus
                            self.forced_width = 32
                            self.forced_height = 32
                        else
                            self.bg = beautiful.tag_bg_normal or "#444444"
                            self.forced_width = 32
                            self.forced_height = 32
                        end

                        -- Update icon based on clients
                        local icon_path
                        if #tag:clients() > 0 then
                            icon_path = beautiful.tag_dot
                        else
                            icon_path = beautiful.tag_dot_empty
                        end
                        icon_widget.image = gears.color.recolor_image(icon_path, beautiful.fg_normal)
                    end,
                },
            },
            
        },
        -- Outer container with rounded corners
        {
            bg     =  "#444444",
            shape  = gears.shape.rounded_rect,
            widget = wibox.container.background,
        },
        margins = {
            top = 5,
            bottom = 5,
            left = 5,
            right = 5,
        },
        widget = wibox.container.margin,
    }
end

return tags_list_widget
