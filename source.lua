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

local mt = {}
mt.__index = mt

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

function kyri.new(title)
    local w = {}
    setmetatable(w, mt)
    
    w.title = title or "kyri"
    w.tabs = {}
    w.active = nil
    w.accents = {}
    w.sounds = {}
    
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
    
    local drag, drag_start, start_pos = false, nil, nil
    
    top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            drag_start = inp.Position
            start_pos = main.Position
        end
    end)
    
    kyri.svc.inp.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - drag_start
            local vp = workspace.CurrentCamera.ViewportSize
            local sz = main.AbsoluteSize
            local new_x = math.clamp(start_pos.X.Offset + delta.X, 0, vp.X - sz.X)
            local new_y = math.clamp(start_pos.Y.Offset + delta.Y, 0, vp.Y - sz.Y)
            main.Position = UDim2.fromOffset(new_x, new_y)
        end
    end)
    
    kyri.svc.inp.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    
    w.gui.Parent = kyri.svc.plr.LocalPlayer.PlayerGui
    
    w.tab = function(self, name)
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
        
        tab.button = function(self, text, callback)
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
        
        tab.toggle = function(self, text, def, callback)
            local state = def or false
            
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
                Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.fromOffset(3, 0),
                AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
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
            
            tog_bg.MouseButton1Click:Connect(function()
                state = not state
                play(state and "toggle_on" or "toggle_off")
                
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
                    Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.fromOffset(3, 0),
                    AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                }):Play()
                kyri.svc.tw:Create(lbl, ti_tog, {
                    TextColor3 = state and t.text or t.subtext
                }):Play()
                
                if callback then callback(state) end
            end)
            
            return box
        end
        
        tab.slider = function(self, text, min, max, def, callback)
            local val = def or min
            
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
        
        tab.input = function(self, text, placeholder, callback)
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
        
        tab.label = function(self, text)
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
            btn.MouseButton1Click:Fire()
        end
        
        return tab
    end
    
    w.accent = function(self, color)
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
