local kyri = {}
local gs = cloneref or function(o) return o end

local function svc(n)
    return gs(game:GetService(n))
end

kyri.svc = {
    tw = svc("TweenService"),
    inp = svc("UserInputService"),
    plr = svc("Players"),
    gui = svc("GuiService"),
    run = svc("RunService"),
    http = svc("HttpService")
}

kyri.theme = {
    bg = Color3.fromRGB(8, 8, 10),
    container = Color3.fromRGB(14, 14, 18),
    element = Color3.fromRGB(20, 20, 26),
    hover = Color3.fromRGB(28, 28, 36),
    active = Color3.fromRGB(32, 32, 42),
    accent = Color3.fromRGB(138, 116, 249),
    text = Color3.fromRGB(245, 245, 250),
    subtext = Color3.fromRGB(165, 165, 180),
    border = Color3.fromRGB(32, 32, 40)
}

local function make(c, p)
    local o = Instance.new(c)
    for k, v in pairs(p) do
        o[k] = v
    end
    if o:IsA("GuiObject") then
        o.BorderSizePixel = 0
    end
    return o
end

local CONFIG_FOLDER = "KyriLib"

local function save_config(game_name, config_name, data)
    local path = CONFIG_FOLDER .. "/" .. game_name
    if not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
    if not isfolder(path) then
        makefolder(path)
    end
    writefile(path .. "/" .. config_name .. ".json", kyri.svc.http:JSONEncode(data))
end

local function load_config(game_name, config_name)
    local path = CONFIG_FOLDER .. "/" .. game_name .. "/" .. config_name .. ".json"
    if isfile(path) then
        return kyri.svc.http:JSONDecode(readfile(path))
    end
    return nil
end

local function list_configs(game_name)
    local path = CONFIG_FOLDER .. "/" .. game_name
    if not isfolder(path) then
        return {}
    end
    local files = listfiles(path)
    local configs = {}
    for _, file in ipairs(files) do
        local name = file:match("([^/\\]+)%.json$")
        if name then
            table.insert(configs, name)
        end
    end
    return configs
end

local function delete_config(game_name, config_name)
    local path = CONFIG_FOLDER .. "/" .. game_name .. "/" .. config_name .. ".json"
    if isfile(path) then
        delfile(path)
    end
end

function kyri.new(title, options)
    options = options or {}
    
    local existing = kyri.svc.plr.LocalPlayer.PlayerGui:FindFirstChild("Kyri")
    if existing then
        existing:Destroy()
    end
    
    local load_gui = make("ScreenGui", {
        Name = "KyriLoad",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999,
        Parent = kyri.svc.plr.LocalPlayer.PlayerGui
    })
    
    local load_bg = make("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        Parent = load_gui
    })
    
    local logo = make("ImageLabel", {
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "",
        ImageTransparency = 1,
        Parent = load_bg
    })
    
    task.spawn(function()
        local url = "https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/kyriliblogo.png"
        local path = "kyrilib_logo.png"
        
        if not isfile(path) then
            local success, data = pcall(function()
                return game:HttpGet(url)
            end)
            if success then
                writefile(path, data)
            end
        end
        
        if isfile(path) then
            logo.Image = getcustomasset(path)
        end
        
        kyri.svc.tw:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        task.wait(3)
        kyri.svc.tw:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        kyri.svc.tw:Create(load_bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        load_gui:Destroy()
    end)
    
    local w = {}
    
    w.title = title or "kyri"
    w.tabs = {}
    w.active = nil
    w.accents = {}
    w.sounds = {}
    w.flags = {}
    w.game_name = options.GameName or "Default"
    
    local t = kyri.theme
    
    w.gui = make("ScreenGui", {
        Name = "Kyri",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999
    })
    
    local sound_ids = {
        click = "rbxassetid://7249904928",
        hover = "rbxassetid://7249903719",
        toggle_on = "rbxassetid://7249904928",
        toggle_off = "rbxassetid://7249903719"
    }
    
    for name, id in pairs(sound_ids) do
        w.sounds[name] = make("Sound", {
            SoundId = id,
            Volume = 0.3,
            Parent = w.gui
        })
    end
    
    local function play(name)
        if w.sounds[name] then
            w.sounds[name]:Play()
        end
    end
    
    local main = make("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(520, 400),
        Position = UDim2.new(0.5, -260, 0.5, -200),
        BackgroundColor3 = t.bg,
        ClipsDescendants = true,
        Parent = w.gui
    })
    
    make("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = main
    })
    
    local resize_handle = make("ImageButton", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6023426962",
        ImageColor3 = t.subtext,
        ZIndex = 100,
        Parent = main
    })
    
    local resizing = false
    local resize_start = nil
    local size_start = nil
    local min_size = Vector2.new(400, 300)
    
    resize_handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resize_start = inp.Position
            size_start = main.Size
        end
    end)
    
    kyri.svc.inp.InputChanged:Connect(function(inp)
        if resizing and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - resize_start
            local new_x = math.max(size_start.X.Offset + delta.X, min_size.X)
            local new_y = math.max(size_start.Y.Offset + delta.Y, min_size.Y)
            main.Size = UDim2.fromOffset(new_x, new_y)
        end
    end)
    
    kyri.svc.inp.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    resize_handle.MouseEnter:Connect(function()
        kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.text}):Play()
    end)
    
    resize_handle.MouseLeave:Connect(function()
        kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.subtext}):Play()
    end)
    
    local glow = make("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = t.accent,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = main
    })
    
    table.insert(w.accents, {obj = glow, prop = "ImageColor3"})
    
    local top = make("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = t.container,
        Parent = main
    })
    
    make("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = top
    })
    
    local top_cover = make("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = t.container,
        BorderSizePixel = 0,
        Parent = top
    })
    
    local title_txt = make("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(20, 0),
        BackgroundTransparency = 1,
        Text = w.title,
        TextColor3 = t.text,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = top
    })
    
    local accent_bar = make("Frame", {
        Size = UDim2.new(0, 3, 0, 24),
        Position = UDim2.fromOffset(8, 14),
        BackgroundColor3 = t.accent,
        BorderSizePixel = 0,
        Parent = top
    })
    
    table.insert(w.accents, {obj = accent_bar, prop = "BackgroundColor3"})
    
    make("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = accent_bar
    })
    
    local minimize = make("ImageButton", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6026568240",
        ImageColor3 = t.subtext,
        Parent = top
    })
    
    local minimized = false
    local pre_min_size = nil
    
    minimize.MouseEnter:Connect(function()
        play("hover")
        kyri.svc.tw:Create(minimize, TweenInfo.new(0.2), {ImageColor3 = t.text}):Play()
    end)
    
    minimize.MouseLeave:Connect(function()
        kyri.svc.tw:Create(minimize, TweenInfo.new(0.2), {ImageColor3 = t.subtext}):Play()
    end)
    
    minimize.MouseButton1Click:Connect(function()
        play("click")
        minimized = not minimized
        
        if minimized then
            pre_min_size = main.Size
            kyri.svc.tw:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, main.Size.X.Offset, 0, 52)
            }):Play()
        else
            kyri.svc.tw:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = pre_min_size
            }):Play()
        end
        
        kyri.svc.tw:Create(minimize, TweenInfo.new(0.25), {
            Rotation = minimized and 180 or 0
        }):Play()
    end)
    
    local sidebar = make("Frame", {
        Size = UDim2.new(0, 140, 1, -64),
        Position = UDim2.fromOffset(12, 58),
        BackgroundTransparency = 1,
        Parent = main
    })
    
    local tab_holder = make("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = sidebar
    })
    
    local tab_list = make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tab_holder
    })
    
    tab_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab_holder.CanvasSize = UDim2.new(0, 0, 0, tab_list.AbsoluteContentSize.Y)
    end)
    
    local content = make("Frame", {
        Size = UDim2.new(1, -168, 1, -70),
        Position = UDim2.fromOffset(158, 58),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = main
    })
    
    local drag, drag_input, drag_start, input_start = false, nil, nil, nil
    
    local function update_input(input)
        local delta = input.Position - drag_start
        local position = UDim2.new(
            input_start.X.Scale,
            input_start.X.Offset + delta.X,
            input_start.Y.Scale, 
            input_start.Y.Offset + delta.Y
        )
        
        kyri.svc.tw:Create(main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = position
        }):Play()
    end
    
    top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            drag_start = inp.Position
            input_start = main.Position
            drag_input = inp
            
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    drag = false
                end
            end)
        end
    end)
    
    top.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            drag_input = inp
        end
    end)
    
    kyri.svc.run.Heartbeat:Connect(function()
        if drag and drag_input then
            update_input(drag_input)
        end
    end)
    
    w.gui.Parent = kyri.svc.plr.LocalPlayer.PlayerGui
    
    function w:tab(name)
        local tab = {}
        tab.name = name
        tab.elements = {}
        
        local btn = make("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = t.element,
            Text = "",
            AutoButtonColor = false,
            Parent = tab_holder
        })
        
        make("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = btn
        })
        
        local txt = make("TextLabel", {
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = t.subtext,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btn
        })
        
        local indicator = make("Frame", {
            Size = UDim2.new(0, 0, 0, 38),
            Position = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = t.accent,
            BorderSizePixel = 0,
            Parent = btn
        })
        
        table.insert(w.accents, {obj = indicator, prop = "BackgroundColor3"})
        
        make("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = indicator
        })
        
        local page = make("ScrollingFrame", {
            Name = name,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = t.accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = content
        })
        
        table.insert(w.accents, {obj = page, prop = "ScrollBarImageColor3"})
        
        local page_list = make("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page
        })
        
        make("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 8),
            Parent = page
        })
        
        page_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, page_list.AbsoluteContentSize.Y + 12)
        end)
        
        local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        btn.MouseButton1Click:Connect(function()
            play("click")
            
            for _, tb in pairs(w.tabs) do
                tb.page.Visible = false
                kyri.svc.tw:Create(tb.btn, ti, {BackgroundColor3 = t.element}):Play()
                kyri.svc.tw:Create(tb.txt, ti, {TextColor3 = t.subtext}):Play()
                kyri.svc.tw:Create(tb.indicator, ti, {Size = UDim2.new(0, 0, 0, 38)}):Play()
            end
            
            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = UDim2.new(0, 3, 0, 38)}):Play()
            w.active = tab
        end)
        
        btn.MouseEnter:Connect(function()
            play("hover")
            if w.active ~= tab then
                kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            end
        end)
        
        btn.MouseLeave:Connect(function()
            if w.active ~= tab then
                kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.element}):Play()
            end
        end)
        
        tab.btn = btn
        tab.txt = txt
        tab.indicator = indicator
        tab.page = page
        
        function tab:button(text, callback)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = box
            })
            
            local click = make("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                Parent = box
            })
            
            make("TextLabel", {
                Size = UDim2.new(1, -24, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })
            
            local ripple = make("ImageLabel", {
                Size = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = "rbxassetid://4560909609",
                ImageTransparency = 1,
                ImageColor3 = t.accent,
                ZIndex = 2,
                Parent = box
            })
            
            table.insert(w.accents, {obj = ripple, prop = "ImageColor3"})
            
            click.MouseButton1Click:Connect(function()
                play("click")
                ripple.Size = UDim2.fromScale(0, 0)
                ripple.ImageTransparency = 0.5
                kyri.svc.tw:Create(ripple, TweenInfo.new(0.4), {
                    Size = UDim2.fromScale(1.5, 1.5),
                    ImageTransparency = 1
                }):Play()
                if callback then callback() end
            end)
            
            click.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            
            click.MouseLeave:Connect(function()
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
            end)
            
            return box
        end
        
        function tab:toggle(text, def, callback, flag)
            local state = def or false
            
            if flag then
                w.flags[flag] = state
            end
            
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = box
            })
            
            local lbl = make("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = state and t.text or t.subtext,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })
            
            local tog_bg = make("TextButton", {
                Size = UDim2.fromOffset(46, 24),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = state and t.accent or t.container,
                Text = "",
                AutoButtonColor = false,
                Parent = box
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = tog_bg
            })
            
            local knob = make("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(state and 1 or 0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tog_bg
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = knob
            })
            
            if state then
                table.insert(w.accents, {obj = tog_bg, prop = "BackgroundColor3", is_toggle = true, get_state = function() return state end})
            end
            
            local ti_tog = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
            
            local function set_state(new_state, run_callback)
                state = new_state
                
                if flag then
                    w.flags[flag] = state
                end
                
                for i, v in ipairs(w.accents) do
                    if v.obj == tog_bg and v.is_toggle then
                        table.remove(w.accents, i)
                        break
                    end
                end
                
                if state then
                    table.insert(w.accents, {obj = tog_bg, prop = "BackgroundColor3", is_toggle = true, get_state = function() return state end})
                end
                
                local color = state and t.accent or t.container
                kyri.svc.tw:Create(tog_bg, ti_tog, {BackgroundColor3 = color}):Play()
                kyri.svc.tw:Create(knob, ti_tog, {
                    Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(state and 1 or 0, 0.5)
                }):Play()
                kyri.svc.tw:Create(lbl, ti_tog, {
                    TextColor3 = state and t.text or t.subtext
                }):Play()
                
                if run_callback and callback then
                    callback(state)
                end
            end
            
            if flag then
                w.flags[flag .. "_set"] = set_state
            end
            
            tog_bg.MouseButton1Click:Connect(function()
                play(state and "toggle_off" or "toggle_on")
                set_state(not state, true)
            end)
            
            return box
        end
        
        function tab:slider(text, min, max, def, callback, flag)
            local val = def or min
            
            if flag then
                w.flags[flag] = val
            end
            
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 58),
                BackgroundColor3 = t.element,
                Parent = page
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = box
            })
            
            make("TextLabel", {
                Size = UDim2.new(1, -90, 0, 20),
                Position = UDim2.fromOffset(16, 10),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })
            
            local val_lbl = make("TextLabel", {
                Size = UDim2.fromOffset(60, 20),
                Position = UDim2.new(1, -16, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextColor3 = t.accent,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = box
            })
            
            table.insert(w.accents, {obj = val_lbl, prop = "TextColor3"})
            
            local track = make("Frame", {
                Size = UDim2.new(1, -32, 0, 5),
                Position = UDim2.fromOffset(16, 40),
                BackgroundColor3 = t.container,
                Parent = box
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = track
            })
            
            local fill = make("Frame", {
                Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = t.accent,
                Parent = track
            })
            
            table.insert(w.accents, {obj = fill, prop = "BackgroundColor3"})
            
            make("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = fill
            })
            
            local handle = make("Frame", {
                Size = UDim2.fromOffset(13, 13),
                Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = t.text,
                Parent = track
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = handle
            })
            
            local dragging = false
            
            local function update(inp)
                local pct = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * pct)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                handle.Position = UDim2.new(pct, 0, 0.5, 0)
                val_lbl.Text = tostring(val)
                
                if flag then
                    w.flags[flag] = val
                end
                
                if callback then callback(val) end
            end
            
            track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    play("toggle_on")
                    update(inp)
                end
            end)
            
            kyri.svc.inp.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    update(inp)
                end
            end)
            
            kyri.svc.inp.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    if dragging then
                        play("toggle_off")
                    end
                    dragging = false
                end
            end)
            
            return box
        end
        
        function tab:input(text, placeholder, callback)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 68),
                BackgroundColor3 = t.element,
                Parent = page
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = box
            })
            
            make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 20),
                Position = UDim2.fromOffset(16, 10),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })
            
            local inp = make("TextBox", {
                Size = UDim2.new(1, -32, 0, 30),
                Position = UDim2.fromOffset(16, 34),
                BackgroundColor3 = t.container,
                Text = "",
                PlaceholderText = placeholder or "enter text",
                PlaceholderColor3 = t.subtext,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = box
            })
            
            make("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = inp
            })
            
            make("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = inp
            })
            
            inp.FocusLost:Connect(function(enter)
                if callback and enter then
                    play("click")
                    callback(inp.Text)
                end
            end)
            
            return box
        end
        
        function tab:label(text)
            local lbl = make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = page
            })
            
            make("UIPadding", {
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 16),
                Parent = lbl
            })
            
            return lbl
        end
        
        w.tabs[name] = tab
        
        if not w.active then
            task.wait()
            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = UDim2.new(0, 3, 0, 38)}):Play()
            w.active = tab
        end
        
        return tab
    end
    
    function w:create_settings()
        local settings = self:tab("Settings")
        
        settings:label("config management")
        
        local config_name_box = settings:input("config name", "MyConfig", function() end)
        
        local config_list_container = settings:label("")
        
        local function refresh_configs()
            for _, child in ipairs(settings.page:GetChildren()) do
                if child.Name:match("^load:") or child.Name:match("^delete:") then
                    child:Destroy()
                end
            end
            
            local configs = list_configs(w.game_name)
            for _, cfg_name in ipairs(configs) do
                settings:button("load: " .. cfg_name, function()
                    local data = load_config(w.game_name, cfg_name)
                    if data then
                        for flag, value in pairs(data) do
                            w.flags[flag] = value
                            
                            local set_func = w.flags[flag .. "_set"]
                            if set_func then
                                set_func(value, true)
                            end
                        end
                        print("loaded config:", cfg_name)
                    end
                end)
                
                settings:button("delete: " .. cfg_name, function()
                    delete_config(w.game_name, cfg_name)
                    print("deleted config:", cfg_name)
                    refresh_configs()
                end)
            end
        end
        
        settings:button("save config", function()
            local input_box = config_name_box:FindFirstChild("TextBox", true)
            if input_box and input_box.Text ~= "" then
                local data = {}
                for flag, value in pairs(w.flags) do
                    data[flag] = value
                end
                save_config(w.game_name, input_box.Text, data)
                print("saved config:", input_box.Text)
                refresh_configs()
            end
        end)
        
        settings:label("saved configs")
        
        refresh_configs()
        
        return settings
    end
    
    task.spawn(function()
        task.wait(0.1)
        w:create_settings()
    end)
    
    function w:accent(color)
        t.accent = color
        for _, d in ipairs(w.accents) do
            if d.obj and d.obj.Parent then
                if d.is_toggle then
                    if d.get_state() then
                        d.obj[d.prop] = color
                    end
                else
                    d.obj[d.prop] = color
                end
            end
        end
    end
    
    return w
end

return kyri
