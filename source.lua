local kyri_lib = {}
local gs = cloneref or function(obj) return obj end

local function get_service(name)
    return gs(game:GetService(name))
end

kyri_lib.services = {
    tween = get_service("TweenService"),
    input = get_service("UserInputService"),
    players = get_service("Players"),
    gui = get_service("GuiService"),
    run = get_service("RunService"),
    http = get_service("HttpService")
}

kyri_lib.config = {
    title = "kyrilib",
    bg = Color3.fromRGB(12, 12, 12),
    primary = Color3.fromRGB(18, 18, 18),
    secondary = Color3.fromRGB(28, 28, 28),
    tertiary = Color3.fromRGB(38, 38, 38),
    accent = Color3.fromRGB(120, 120, 255),
    text = Color3.fromRGB(255, 255, 255),
    dim_text = Color3.fromRGB(140, 140, 140),
    border = Color3.fromRGB(45, 45, 45),
    font = Enum.Font.Gotham,
    radius = UDim.new(0, 6),
    padding = UDim.new(0, 10),
    gap = 6,
    anim_time = 0.2
}

kyri_lib.core = {}
kyri_lib.core.__index = kyri_lib.core

local function make_instance(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if obj:IsA("GuiObject") then
        obj.BorderSizePixel = 0
    end
    return obj
end

local config_dir = "KyriLibData"

local function get_save_path(name)
    return config_dir .. "/" .. name .. ".json"
end

local function save_data(name, data)
    if not isfolder(config_dir) then
        makefolder(config_dir)
    end
    
    local success = pcall(function()
        writefile(get_save_path(name), kyri_lib.services.http:JSONEncode(data))
    end)
    
    if not success then
        warn("kyrilib save failed")
    end
end

local function load_data(name)
    local path = get_save_path(name)
    
    if not isfile(path) then
        return nil
    end
    
    local success, result = pcall(function()
        return kyri_lib.services.http:JSONDecode(readfile(path))
    end)
    
    if not success then
        warn("kyrilib load failed")
        return nil
    end
    
    return result
end

kyri_lib.core.new = function(title)
    local win = {}
    setmetatable(win, kyri_lib.core)
    
    win.title = title or kyri_lib.config.title
    win.elements = {}
    win.accent_objs = {}
    win.tabs = {}
    win.current_tab = nil
    
    local cfg = kyri_lib.config
    local width = 480
    local height = 380
    
    win.gui = make_instance("ScreenGui", {
        Name = "KyriLib",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999
    })
    
    local drag_container = make_instance("Frame", {
        Name = "Container",
        Size = UDim2.fromOffset(width, height),
        Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2),
        BackgroundTransparency = 1,
        Parent = win.gui
    })
    
    local main = make_instance("Frame", {
        Name = "Main",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = cfg.bg,
        ClipsDescendants = true,
        Parent = drag_container
    })
    
    make_instance("UICorner", {
        CornerRadius = cfg.radius,
        Parent = main
    })
    
    make_instance("UIStroke", {
        Color = cfg.border,
        Thickness = 1,
        Transparency = 0.3,
        Parent = main
    })
    
    local topbar = make_instance("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.fromOffset(10, 10),
        BackgroundColor3 = cfg.primary,
        Parent = main
    })
    
    make_instance("UICorner", {
        CornerRadius = cfg.radius,
        Parent = topbar
    })
    
    make_instance("UIStroke", {
        Color = cfg.border,
        Thickness = 1,
        Parent = topbar
    })
    
    make_instance("TextLabel", {
        Name = "Title",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = win.title,
        TextColor3 = cfg.text,
        Font = cfg.font,
        TextSize = 16,
        Parent = topbar
    })
    
    local tab_bar = make_instance("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 120, 1, -70),
        Position = UDim2.fromOffset(10, 60),
        BackgroundColor3 = cfg.primary,
        Parent = main
    })
    
    make_instance("UICorner", {
        CornerRadius = cfg.radius,
        Parent = tab_bar
    })
    
    make_instance("UIStroke", {
        Color = cfg.border,
        Thickness = 1,
        Parent = tab_bar
    })
    
    local tab_list = make_instance("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tab_bar
    })
    
    make_instance("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = tab_bar
    })
    
    local content_holder = make_instance("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -150, 1, -70),
        Position = UDim2.fromOffset(140, 60),
        BackgroundTransparency = 1,
        Parent = main
    })
    
    local dragging = false
    local drag_start = nil
    local start_pos = nil
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            drag_start = input.Position
            start_pos = drag_container.Position
        end
    end)
    
    kyri_lib.services.input.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - drag_start
            local viewport = workspace.CurrentCamera.ViewportSize
            local size = drag_container.AbsoluteSize
            
            local new_x = start_pos.X.Offset + delta.X
            local new_y = start_pos.Y.Offset + delta.Y
            
            new_x = math.clamp(new_x, 0, viewport.X - size.X)
            new_y = math.clamp(new_y, 0, viewport.Y - size.Y)
            
            drag_container.Position = UDim2.fromOffset(new_x, new_y)
        end
    end)
    
    kyri_lib.services.input.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    win.gui.Parent = kyri_lib.services.players.LocalPlayer.PlayerGui
    
    win.add_tab = function(self, name)
        local tab = {}
        tab.name = name
        tab.elements = {}
        
        local tab_btn = make_instance("TextButton", {
            Name = "Tab_" .. name,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = cfg.secondary,
            Text = name,
            TextColor3 = cfg.text,
            Font = cfg.font,
            TextSize = 14,
            AutoButtonColor = false,
            Parent = tab_bar
        })
        
        make_instance("UICorner", {
            CornerRadius = cfg.radius,
            Parent = tab_btn
        })
        
        local tab_content = make_instance("ScrollingFrame", {
            Name = "TabContent_" .. name,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = cfg.accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = content_holder
        })
        
        table.insert(win.accent_objs, {
            obj = tab_content,
            prop = "ScrollBarImageColor3"
        })
        
        local content_list = make_instance("UIListLayout", {
            Padding = UDim.new(0, cfg.gap),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tab_content
        })
        
        make_instance("UIPadding", {
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6),
            Parent = tab_content
        })
        
        content_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab_content.CanvasSize = UDim2.new(0, 0, 0, content_list.AbsoluteContentSize.Y + 12)
        end)
        
        tab_btn.MouseButton1Click:Connect(function()
            for _, t in pairs(win.tabs) do
                t.content.Visible = false
                t.button.BackgroundColor3 = cfg.secondary
            end
            
            tab_content.Visible = true
            tab_btn.BackgroundColor3 = cfg.tertiary
            win.current_tab = tab
        end)
        
        tab.button = tab_btn
        tab.content = tab_content
        
        tab.add_button = function(self, text, callback)
            local btn = make_instance("TextButton", {
                Name = "Btn_" .. text,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = cfg.secondary,
                Text = text,
                TextColor3 = cfg.text,
                Font = cfg.font,
                TextSize = 13,
                AutoButtonColor = false,
                Parent = tab_content
            })
            
            make_instance("UICorner", {
                CornerRadius = cfg.radius,
                Parent = btn
            })
            
            make_instance("UIStroke", {
                Color = cfg.border,
                Thickness = 1,
                Parent = btn
            })
            
            local tween_info = TweenInfo.new(cfg.anim_time, Enum.EasingStyle.Quad)
            
            btn.MouseEnter:Connect(function()
                kyri_lib.services.tween:Create(btn, tween_info, {BackgroundColor3 = cfg.tertiary}):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                kyri_lib.services.tween:Create(btn, tween_info, {BackgroundColor3 = cfg.secondary}):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            table.insert(tab.elements, btn)
            return btn
        end
        
        tab.add_toggle = function(self, text, default, callback)
            local state = default or false
            
            local toggle_frame = make_instance("Frame", {
                Name = "Toggle_" .. text,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = cfg.secondary,
                Parent = tab_content
            })
            
            make_instance("UICorner", {
                CornerRadius = cfg.radius,
                Parent = toggle_frame
            })
            
            make_instance("UIStroke", {
                Color = cfg.border,
                Thickness = 1,
                Parent = toggle_frame
            })
            
            make_instance("TextLabel", {
                Name = "Label",
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = cfg.text,
                Font = cfg.font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggle_frame
            })
            
            local toggle_btn = make_instance("TextButton", {
                Name = "ToggleBtn",
                Size = UDim2.fromOffset(40, 20),
                Position = UDim2.new(1, -12, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = state and cfg.accent or cfg.primary,
                Text = "",
                AutoButtonColor = false,
                Parent = toggle_frame
            })
            
            table.insert(win.accent_objs, {
                obj = toggle_btn,
                prop = "BackgroundColor3",
                is_toggle = true,
                state_ref = function() return state end
            })
            
            make_instance("UICorner", {
                CornerRadius = UDim.new(0.5, 0),
                Parent = toggle_btn
            })
            
            local indicator = make_instance("Frame", {
                Name = "Indicator",
                Size = UDim2.fromOffset(14, 14),
                Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
                BackgroundColor3 = cfg.text,
                Parent = toggle_btn
            })
            
            make_instance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = indicator
            })
            
            local tween_info = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
            
            toggle_btn.MouseButton1Click:Connect(function()
                state = not state
                
                kyri_lib.services.tween:Create(toggle_btn, tween_info, {
                    BackgroundColor3 = state and cfg.accent or cfg.primary
                }):Play()
                
                kyri_lib.services.tween:Create(indicator, tween_info, {
                    Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                }):Play()
                
                if callback then
                    callback(state)
                end
            end)
            
            table.insert(tab.elements, toggle_frame)
            return toggle_frame
        end
        
        tab.add_slider = function(self, text, min, max, default, callback)
            local value = default or min
            
            local slider_frame = make_instance("Frame", {
                Name = "Slider_" .. text,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = cfg.secondary,
                Parent = tab_content
            })
            
            make_instance("UICorner", {
                CornerRadius = cfg.radius,
                Parent = slider_frame
            })
            
            make_instance("UIStroke", {
                Color = cfg.border,
                Thickness = 1,
                Parent = slider_frame
            })
            
            local label = make_instance("TextLabel", {
                Name = "Label",
                Size = UDim2.new(1, -24, 0, 20),
                Position = UDim2.fromOffset(12, 6),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = cfg.text,
                Font = cfg.font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = slider_frame
            })
            
            local value_label = make_instance("TextLabel", {
                Name = "Value",
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -12, 0, 6),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = cfg.accent,
                Font = cfg.font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = slider_frame
            })
            
            table.insert(win.accent_objs, {
                obj = value_label,
                prop = "TextColor3"
            })
            
            local slider_bg = make_instance("Frame", {
                Name = "SliderBg",
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.fromOffset(12, 34),
                BackgroundColor3 = cfg.primary,
                Parent = slider_frame
            })
            
            make_instance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = slider_bg
            })
            
            local slider_fill = make_instance("Frame", {
                Name = "Fill",
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = cfg.accent,
                Parent = slider_bg
            })
            
            table.insert(win.accent_objs, {
                obj = slider_fill,
                prop = "BackgroundColor3"
            })
            
            make_instance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = slider_fill
            })
            
            local dragging = false
            
            local function update_slider(input)
                local pos = (input.Position.X - slider_bg.AbsolutePosition.X) / slider_bg.AbsoluteSize.X
                pos = math.clamp(pos, 0, 1)
                value = math.floor(min + (max - min) * pos)
                
                slider_fill.Size = UDim2.new(pos, 0, 1, 0)
                value_label.Text = tostring(value)
                
                if callback then
                    callback(value)
                end
            end
            
            slider_bg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update_slider(input)
                end
            end)
            
            kyri_lib.services.input.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update_slider(input)
                end
            end)
            
            kyri_lib.services.input.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            table.insert(tab.elements, slider_frame)
            return slider_frame
        end
        
        tab.add_textbox = function(self, text, placeholder, callback)
            local textbox_frame = make_instance("Frame", {
                Name = "Textbox_" .. text,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = cfg.secondary,
                Parent = tab_content
            })
            
            make_instance("UICorner", {
                CornerRadius = cfg.radius,
                Parent = textbox_frame
            })
            
            make_instance("UIStroke", {
                Color = cfg.border,
                Thickness = 1,
                Parent = textbox_frame
            })
            
            make_instance("TextLabel", {
                Name = "Label",
                Size = UDim2.new(1, -24, 0, 20),
                Position = UDim2.fromOffset(12, 6),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = cfg.text,
                Font = cfg.font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = textbox_frame
            })
            
            local input_box = make_instance("TextBox", {
                Name = "Input",
                Size = UDim2.new(1, -24, 0, 26),
                Position = UDim2.fromOffset(12, 28),
                BackgroundColor3 = cfg.primary,
                Text = "",
                PlaceholderText = placeholder or "Enter text...",
                PlaceholderColor3 = cfg.dim_text,
                TextColor3 = cfg.text,
                Font = cfg.font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = textbox_frame
            })
            
            make_instance("UICorner", {
                CornerRadius = cfg.radius,
                Parent = input_box
            })
            
            make_instance("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = input_box
            })
            
            input_box.FocusLost:Connect(function(enter)
                if callback and enter then
                    callback(input_box.Text)
                end
            end)
            
            table.insert(tab.elements, textbox_frame)
            return textbox_frame
        end
        
        tab.add_label = function(self, text)
            local label = make_instance("TextLabel", {
                Name = "Label_" .. text,
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = cfg.dim_text,
                Font = cfg.font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = tab_content
            })
            
            make_instance("UIPadding", {
                PaddingLeft = UDim.new(0, 12),
                Parent = label
            })
            
            table.insert(tab.elements, label)
            return label
        end
        
        win.tabs[name] = tab
        
        if not win.current_tab then
            tab_btn.MouseButton1Click:Fire()
        end
        
        return tab
    end
    
    win.set_accent = function(self, color)
        cfg.accent = color
        for _, data in ipairs(win.accent_objs) do
            if data.obj and data.obj.Parent then
                if data.is_toggle then
                    if data.state_ref() then
                        data.obj[data.prop] = color
                    end
                else
                    data.obj[data.prop] = color
                end
            end
        end
    end
    
    return win
end

return kyri_lib
