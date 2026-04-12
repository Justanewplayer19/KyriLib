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
    http = svc("HttpService"),
    cas = svc("ContextActionService")
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

local function encode_val(v)
    if typeof(v) == "Color3" then
        return {__type = "Color3", r = v.R, g = v.G, b = v.B}
    end
    return v
end

local function decode_val(v)
    if type(v) == "table" and v.__type == "Color3" then
        return Color3.new(v.r, v.g, v.b)
    end
    return v
end

local function save_config(game_name, config_name, data)
    local path = CONFIG_FOLDER .. "/" .. game_name
    if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    if not isfolder(path) then makefolder(path) end
    local encoded = {}
    for k, v in pairs(data) do encoded[k] = encode_val(v) end
    writefile(path .. "/" .. config_name .. ".json", kyri.svc.http:JSONEncode(encoded))
end

local function load_config(game_name, config_name)
    local path = CONFIG_FOLDER .. "/" .. game_name .. "/" .. config_name .. ".json"
    if isfile(path) then
        local raw = kyri.svc.http:JSONDecode(readfile(path))
        local out = {}
        for k, v in pairs(raw) do out[k] = decode_val(v) end
        return out
    end
    return nil
end

local function list_configs(game_name)
    local path = CONFIG_FOLDER .. "/" .. game_name
    if not isfolder(path) then return {} end
    local files = listfiles(path)
    local configs = {}
    for _, file in ipairs(files) do
        local name = file:match("([^/\\]+)%.json$")
        if name then table.insert(configs, name) end
    end
    return configs
end

local function delete_config(game_name, config_name)
    local path = CONFIG_FOLDER .. "/" .. game_name .. "/" .. config_name .. ".json"
    if isfile(path) then delfile(path) end
end

function kyri.new(title, options)
    options = options or {}

    if getgenv then
        if getgenv().__kyri_inst then
            pcall(function() getgenv().__kyri_inst:destroy() end)
            getgenv().__kyri_inst = nil
        end
    end

    local localPlayer = kyri.svc.plr.LocalPlayer

    local existing = localPlayer.PlayerGui:FindFirstChild("Kyri")
    if existing then existing:Destroy() end

    local load_gui = make("ScreenGui", {
        Name = "KyriLoad",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999,
        Parent = localPlayer.PlayerGui
    })

    local logo = make("ImageLabel", {
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "",
        ImageTransparency = 1,
        Parent = load_gui
    })

    local loaded = false

    task.spawn(function()
        local url = "https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/kyriliblogo.png"
        local path = "kyrilib_logo.png"

        if not isfile(path) then
            local success, data = pcall(function()
                return game:HttpGet(url)
            end)
            if success then writefile(path, data) end
        end

        if isfile(path) then
            logo.Image = getcustomasset(path)
        end

        kyri.svc.tw:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        task.wait(3)
        kyri.svc.tw:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        task.wait(0.5)
        load_gui:Destroy()
        loaded = true
    end)

    repeat task.wait() until loaded

    local w = {}
    local conns = {}

    w.title = title or "kyri"
    w.tabs = {}
    w.active = nil
    w.accents = {}
    w.sounds = {}
    w.flags = {}
    w.game_name = options.GameName or "Default"
    w.is_mobile = kyri.svc.inp.TouchEnabled and not kyri.svc.inp.KeyboardEnabled

    local t = {
        bg = (options.Theme and options.Theme.bg) or kyri.theme.bg,
        container = (options.Theme and options.Theme.container) or kyri.theme.container,
        element = (options.Theme and options.Theme.element) or kyri.theme.element,
        hover = (options.Theme and options.Theme.hover) or kyri.theme.hover,
        active = (options.Theme and options.Theme.active) or kyri.theme.active,
        accent = (options.Theme and options.Theme.accent) or kyri.theme.accent,
        text = (options.Theme and options.Theme.text) or kyri.theme.text,
        subtext = (options.Theme and options.Theme.subtext) or kyri.theme.subtext,
        border = (options.Theme and options.Theme.border) or kyri.theme.border
    }

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
        toggle_on = "rbxassetid://6026984224",
        toggle_off = "rbxassetid://6026984224"
    }

    for name, id in pairs(sound_ids) do
        w.sounds[name] = make("Sound", {
            SoundId = id,
            Volume = 0.3,
            Parent = w.gui
        })
    end

    local function play(name)
        if w.sounds[name] then w.sounds[name]:Play() end
    end

    local main = make("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(520, 400),
        Position = UDim2.new(0.5, -260, 0.5, -200),
        BackgroundColor3 = t.bg,
        ClipsDescendants = true,
        Visible = not w.is_mobile,
        Parent = w.gui
    })

    make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = main})

    local resize_handle = make("ImageButton", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6023426962",
        ImageColor3 = t.subtext,
        ZIndex = 100,
        Visible = not w.is_mobile,
        Parent = main
    })

    local minimized = false
    local pre_min_size = nil
    local sidebar, content

    if not w.is_mobile then
        local resizing = false
        local resize_start = nil
        local size_start = nil
        local min_size = Vector2.new(400, 300)

        resize_handle.InputBegan:Connect(function(inp)
            if minimized then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resize_start = inp.Position
                size_start = main.Size
            end
        end)

        table.insert(conns, kyri.svc.inp.InputChanged:Connect(function(inp)
            if resizing and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = inp.Position - resize_start
                local new_x = math.max(size_start.X.Offset + delta.X, min_size.X)
                local new_y = math.max(size_start.Y.Offset + delta.Y, min_size.Y)
                main.Size = UDim2.fromOffset(new_x, new_y)
            end
        end))

        table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end))

        resize_handle.MouseEnter:Connect(function()
            kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.text}):Play()
        end)
        resize_handle.MouseLeave:Connect(function()
            kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.subtext}):Play()
        end)
    end

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

    make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = top})

    make("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = t.container,
        BorderSizePixel = 0,
        Parent = top
    })

    make("TextLabel", {
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
    make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = accent_bar})

    local minimize = make("ImageButton", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6026568240",
        ImageColor3 = t.subtext,
        Parent = top
    })

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
            resize_handle.Visible = false
            sidebar.Visible = false
            content.Visible = false
            kyri.svc.tw:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, main.Size.X.Offset, 0, 52)
            }):Play()
        else
            kyri.svc.tw:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = pre_min_size
            }):Play()
            task.delay(0.25, function()
                if not minimized then
                    resize_handle.Visible = true
                    sidebar.Visible = true
                    content.Visible = true
                end
            end)
        end

        kyri.svc.tw:Create(minimize, TweenInfo.new(0.25), {
            Rotation = minimized and 180 or 0
        }):Play()
    end)

    sidebar = make("Frame", {
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

    content = make("Frame", {
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
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or (w.is_mobile and inp.UserInputType == Enum.UserInputType.Touch) then
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
        if inp.UserInputType == Enum.UserInputType.MouseMovement or (w.is_mobile and inp.UserInputType == Enum.UserInputType.Touch) then
            drag_input = inp
        end
    end)

    table.insert(conns, kyri.svc.run.Heartbeat:Connect(function()
        if drag and drag_input then update_input(drag_input) end
    end))

    w.gui.Parent = localPlayer.PlayerGui
    w.localPlayer = localPlayer

    local function toggle_gui()
        main.Visible = not main.Visible
    end

    if w.is_mobile then
        kyri.svc.cas:BindAction("KyriToggle", function(name, state, input)
            if state == Enum.UserInputState.Begin then toggle_gui() end
        end, true, Enum.KeyCode.ButtonR3)
        kyri.svc.cas:SetTitle("KyriToggle", "Kyri")
        kyri.svc.cas:SetPosition("KyriToggle", UDim2.new(1, -70, 1, -70))
    else
        table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.RightControl then toggle_gui() end
        end))
    end

    local function make_colorpicker_popup(current, on_change)
        local popup_gui = make("ScreenGui", {
            Name = "KyriColorPicker",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 1000000001,
            Parent = localPlayer.PlayerGui
        })

        local overlay = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = popup_gui
        })

        local picker = make("Frame", {
            Size = UDim2.fromOffset(260, 230),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = t.bg,
            Parent = overlay
        })
        make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = picker})

        local h, s, v = Color3.toHSV(current)

        local sv_frame = make("ImageLabel", {
            Size = UDim2.fromOffset(220, 140),
            Position = UDim2.fromOffset(20, 16),
            BackgroundColor3 = Color3.fromHSV(h, 1, 1),
            Image = "rbxassetid://4155801252",
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = sv_frame})

        local sv_cursor = make("Frame", {
            Size = UDim2.fromOffset(10, 10),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(s, 0, 1 - v, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            ZIndex = 2,
            Parent = sv_frame
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sv_cursor})

        local hue_bar = make("ImageLabel", {
            Size = UDim2.fromOffset(220, 14),
            Position = UDim2.fromOffset(20, 164),
            Image = "rbxassetid://698052001",
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = hue_bar})

        local hue_cursor = make("Frame", {
            Size = UDim2.fromOffset(10, 14),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(h, 0, 0.5, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            ZIndex = 2,
            Parent = hue_bar
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = hue_cursor})

        local preview = make("Frame", {
            Size = UDim2.fromOffset(40, 24),
            Position = UDim2.fromOffset(20, 188),
            BackgroundColor3 = current,
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = preview})

        local done_btn = make("TextButton", {
            Size = UDim2.fromOffset(100, 24),
            Position = UDim2.new(1, -20, 1, -12),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = t.accent,
            Text = "done",
            TextColor3 = t.text,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            AutoButtonColor = false,
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = done_btn})

        local function refresh()
            local c = Color3.fromHSV(h, s, v)
            sv_frame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            sv_cursor.Position = UDim2.new(s, 0, 1 - v, 0)
            hue_cursor.Position = UDim2.new(h, 0, 0.5, 0)
            preview.BackgroundColor3 = c
            if on_change then on_change(c) end
        end

        local dragging_sv = false
        local dragging_hue = false

        sv_frame.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_sv = true
                s = math.clamp((inp.Position.X - sv_frame.AbsolutePosition.X) / sv_frame.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((inp.Position.Y - sv_frame.AbsolutePosition.Y) / sv_frame.AbsoluteSize.Y, 0, 1)
                refresh()
            end
        end)

        hue_bar.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_hue = true
                h = math.clamp((inp.Position.X - hue_bar.AbsolutePosition.X) / hue_bar.AbsoluteSize.X, 0, 1)
                refresh()
            end
        end)

        local pc_conn = kyri.svc.inp.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if dragging_sv then
                s = math.clamp((inp.Position.X - sv_frame.AbsolutePosition.X) / sv_frame.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((inp.Position.Y - sv_frame.AbsolutePosition.Y) / sv_frame.AbsoluteSize.Y, 0, 1)
                refresh()
            elseif dragging_hue then
                h = math.clamp((inp.Position.X - hue_bar.AbsolutePosition.X) / hue_bar.AbsoluteSize.X, 0, 1)
                refresh()
            end
        end)

        local pe_conn = kyri.svc.inp.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_sv = false
                dragging_hue = false
            end
        end)

        overlay.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                local pos = inp.Position
                local ap = picker.AbsolutePosition
                local as = picker.AbsoluteSize
                if pos.X < ap.X or pos.X > ap.X + as.X or pos.Y < ap.Y or pos.Y > ap.Y + as.Y then
                    pc_conn:Disconnect()
                    pe_conn:Disconnect()
                    popup_gui:Destroy()
                end
            end
        end)

        done_btn.MouseButton1Click:Connect(function()
            pc_conn:Disconnect()
            pe_conn:Disconnect()
            popup_gui:Destroy()
        end)
    end

    function w:tab(name, icon)
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
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})

        local has_icon = icon ~= nil
        local text_offset = has_icon and 36 or 12

        if has_icon then
            local icon_map = {
                sword = "rbxassetid://7733674079",
                move = "rbxassetid://7743871002",
                user = "rbxassetid://7743875962",
                music = "rbxassetid://7734042071",
                settings = "rbxassetid://7734053495"
            }

            local icon_id = icon_map[icon] or (type(icon) == "string" and icon:find("rbxassetid://") and icon) or "rbxassetid://7743875962"

            local icon_img = make("ImageLabel", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.fromOffset(11, 10),
                BackgroundTransparency = 1,
                Image = icon_id,
                ImageColor3 = t.subtext,
                Parent = btn
            })
            tab.icon = icon_img
        end

        local txt = make("TextLabel", {
            Size = UDim2.new(1, -text_offset - 12, 1, 0),
            Position = UDim2.fromOffset(text_offset, 0),
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
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = indicator})

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
                if tb.icon then
                    kyri.svc.tw:Create(tb.icon, ti, {ImageColor3 = t.subtext}):Play()
                end
            end

            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = UDim2.new(0, 3, 0, 38)}):Play()
            if tab.icon then
                kyri.svc.tw:Create(tab.icon, ti, {ImageColor3 = t.text}):Play()
            end
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

        function tab:section(text)
            local frame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Parent = page
            })

            make("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.fromScale(0, 0.5),
                BackgroundColor3 = t.border,
                Parent = frame
            })

            make("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.fromOffset(16, 0),
                BackgroundColor3 = t.bg,
                Text = " " .. text .. " ",
                TextColor3 = t.subtext,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                Parent = frame
            })

            return frame
        end

        function tab:space(height)
            make("Frame", {
                Size = UDim2.new(1, 0, 0, height or 8),
                BackgroundTransparency = 1,
                Parent = page
            })
        end

        function tab:paragraph(title, text)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})
            make("UIPadding", {
                PaddingTop = UDim.new(0, 12),
                PaddingBottom = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 16),
                Parent = box
            })
            make("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = box
            })

            local title_lbl = make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = t.text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = box
            })

            local body_lbl = make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = box
            })

            local api = {box = box}
            function api:set(new_title, new_body)
                if new_title then title_lbl.Text = new_title end
                if new_body then body_lbl.Text = new_body end
            end
            return api
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

            local api = {lbl = lbl}
            function api:set(new_text)
                lbl.Text = new_text
            end
            return api
        end

        function tab:button(text, callback)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            local lbl = make("TextLabel", {
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

            local click = make("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
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

            local api = {box = box}
            function api:set(new_text) lbl.Text = new_text end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:toggle(text, def, callback, flag)
            local state = def or false
            if flag then w.flags[flag] = state end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

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
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = tog_bg})

            local knob = make("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(state and 1 or 0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tog_bg
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})

            local accent_entry = nil
            if state then
                accent_entry = {obj = tog_bg, prop = "BackgroundColor3", is_toggle = true}
                table.insert(w.accents, accent_entry)
            end

            local ti_tog = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

            local function set_state(new_state, run_callback)
                state = new_state
                if flag then w.flags[flag] = state end

                if accent_entry then
                    for i, v in ipairs(w.accents) do
                        if v == accent_entry then
                            table.remove(w.accents, i)
                            break
                        end
                    end
                    accent_entry = nil
                end

                if state then
                    accent_entry = {obj = tog_bg, prop = "BackgroundColor3", is_toggle = true}
                    table.insert(w.accents, accent_entry)
                end

                kyri.svc.tw:Create(tog_bg, ti_tog, {BackgroundColor3 = state and t.accent or t.container}):Play()
                kyri.svc.tw:Create(knob, ti_tog, {
                    Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(state and 1 or 0, 0.5)
                }):Play()
                kyri.svc.tw:Create(lbl, ti_tog, {TextColor3 = state and t.text or t.subtext}):Play()

                if run_callback and callback then callback(state) end
            end

            if flag then w.flags[flag .. "_set"] = set_state end

            tog_bg.MouseButton1Click:Connect(function()
                play(state and "toggle_off" or "toggle_on")
                set_state(not state, true)
            end)

            local api = {box = box}
            function api:set(new_state) set_state(new_state, false) end
            function api:get() return state end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:slider(text, min, max, def, callback, flag, step)
            local val = def or min
            if flag then w.flags[flag] = val end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, w.is_mobile and 78 or 58),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

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

            local set_val_fn = nil

            if w.is_mobile then
                local btn_container = make("Frame", {
                    Size = UDim2.new(1, -32, 0, 36),
                    Position = UDim2.fromOffset(16, 38),
                    BackgroundTransparency = 1,
                    Parent = box
                })
                make("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = btn_container
                })

                local minus_btn = make("TextButton", {
                    Size = UDim2.new(0.3, 0, 1, 0),
                    BackgroundColor3 = t.container,
                    Text = "-",
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 20,
                    AutoButtonColor = false,
                    Parent = btn_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = minus_btn})

                local input_box = make("TextBox", {
                    Size = UDim2.new(0.4, -16, 1, 0),
                    BackgroundColor3 = t.container,
                    Text = tostring(val),
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 16,
                    Parent = btn_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = input_box})

                local plus_btn = make("TextButton", {
                    Size = UDim2.new(0.3, 0, 1, 0),
                    BackgroundColor3 = t.container,
                    Text = "+",
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 20,
                    AutoButtonColor = false,
                    Parent = btn_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = plus_btn})

                local function update_val(new_val)
                    val = math.clamp(new_val, min, max)
                    val_lbl.Text = tostring(val)
                    input_box.Text = tostring(val)
                    if flag then w.flags[flag] = val end
                    if callback then callback(val) end
                end

                set_val_fn = update_val

                minus_btn.MouseButton1Click:Connect(function()
                    play("click")
                    update_val(val - (step or 1))
                end)
                plus_btn.MouseButton1Click:Connect(function()
                    play("click")
                    update_val(val + (step or 1))
                end)
                input_box.FocusLost:Connect(function()
                    local num = tonumber(input_box.Text)
                    if num then update_val(math.floor(num))
                    else input_box.Text = tostring(val) end
                end)

                minus_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(minus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                minus_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(minus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
                end)
                plus_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(plus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                plus_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(plus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
                end)
            else
                local track = make("Frame", {
                    Size = UDim2.new(1, -32, 0, 5),
                    Position = UDim2.fromOffset(16, 40),
                    BackgroundColor3 = t.container,
                    Parent = box
                })
                make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

                local fill = make("Frame", {
                    Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = t.accent,
                    Parent = track
                })
                table.insert(w.accents, {obj = fill, prop = "BackgroundColor3"})
                make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})

                local handle = make("Frame", {
                    Size = UDim2.fromOffset(13, 13),
                    Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = t.text,
                    Parent = track
                })
                make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = handle})

                local dragging = false

                local function update(inp)
                    local pct = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local raw = min + (max - min) * pct
                    if step then
                        val = math.floor(raw / step + 0.5) * step
                        val = math.floor(val * 1000 + 0.5) / 1000
                    else
                        val = math.floor(raw)
                    end
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    handle.Position = UDim2.new(pct, 0, 0.5, 0)
                    val_lbl.Text = tostring(val)
                    if flag then w.flags[flag] = val end
                    if callback then callback(val) end
                end

                local function set_direct(new_val)
                    if step then
                        new_val = math.floor(new_val / step + 0.5) * step
                        new_val = math.floor(new_val * 1000 + 0.5) / 1000
                    else
                        new_val = math.floor(new_val)
                    end
                    val = math.clamp(new_val, min, max)
                    local pct = (val - min) / (max - min)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    handle.Position = UDim2.new(pct, 0, 0.5, 0)
                    val_lbl.Text = tostring(val)
                    if flag then w.flags[flag] = val end
                end

                set_val_fn = set_direct

                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        play("toggle_on")
                        update(inp)
                    end
                end)

                table.insert(conns, kyri.svc.inp.InputChanged:Connect(function(inp)
                    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        update(inp)
                    end
                end))

                table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        if dragging then play("toggle_off") end
                        dragging = false
                    end
                end))
            end

            local api = {box = box}
            function api:set(new_val) if set_val_fn then set_val_fn(new_val) end end
            function api:get() return val end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:input(text, placeholder, callback, flag)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 68),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

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
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = inp})
            make("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = inp
            })

            if flag then w.flags[flag] = inp.Text end

            inp.FocusLost:Connect(function(enter)
                if flag then w.flags[flag] = inp.Text end
                if callback and enter then
                    play("click")
                    callback(inp.Text)
                end
            end)

            inp:GetPropertyChangedSignal("Text"):Connect(function()
                if flag then w.flags[flag] = inp.Text end
            end)

            local api = {box = box, input = inp}
            function api:set(new_text)
                inp.Text = new_text
                if flag then w.flags[flag] = new_text end
            end
            function api:get() return inp.Text end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:dropdown(text, options, def, callback, flag)
            local selected = def or (options[1] or "none")
            local open = false

            if flag then w.flags[flag] = selected end

            local container = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})

            make("TextLabel", {
                Size = UDim2.new(1, -110, 0, 42),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = container
            })

            local dropdown_btn = make("TextButton", {
                Size = UDim2.fromOffset(100, 28),
                Position = UDim2.new(1, -16, 0, 7),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = t.container,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 3,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = dropdown_btn})

            local selected_lbl = make("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = selected,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropdown_btn
            })

            local arrow = make("TextLabel", {
                Size = UDim2.fromOffset(20, 28),
                Position = UDim2.new(1, -5, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 10,
                Parent = dropdown_btn
            })

            local list_frame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 46),
                BackgroundColor3 = t.bg,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 2,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = list_frame})

            local search_box = make("TextBox", {
                Size = UDim2.new(1, -16, 0, 26),
                Position = UDim2.fromOffset(8, 4),
                BackgroundColor3 = t.element,
                Text = "",
                PlaceholderText = "search...",
                PlaceholderColor3 = t.subtext,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ZIndex = 3,
                Parent = list_frame
            })
            make("UICorner", {CornerRadius = UDim.new(0, 5), Parent = search_box})
            make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = search_box})

            local list_container = make("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, -34),
                Position = UDim2.fromOffset(0, 34),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = t.accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y,
                BorderSizePixel = 0,
                Parent = list_frame
            })
            table.insert(w.accents, {obj = list_container, prop = "ScrollBarImageColor3"})

            local list_layout = make("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = list_container
            })

            make("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = list_container
            })

            list_layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list_container.CanvasSize = UDim2.new(0, 0, 0, list_layout.AbsoluteContentSize.Y + 8)
            end)

            local opt_refs = {}
            local selected_accent = nil

            local function close_dropdown()
                open = false
                search_box.Text = ""
                for _, ref in ipairs(opt_refs) do ref.btn.Visible = true end
                kyri.svc.tw:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.wait(0.2)
                if list_frame and list_frame.Parent then
                    list_frame.Visible = false
                end
            end

            for i, option in ipairs(options) do
                local opt_btn = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = t.element,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = list_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = opt_btn})

                local opt_lbl = make("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = option == selected and t.accent or t.text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = opt_btn
                })

                table.insert(opt_refs, {btn = opt_btn, lbl = opt_lbl, text = option})

                if option == selected then
                    selected_accent = {obj = opt_lbl, prop = "TextColor3"}
                    table.insert(w.accents, selected_accent)
                end

                opt_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                opt_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
                end)

                opt_btn.MouseButton1Click:Connect(function()
                    play("click")
                    selected = option
                    selected_lbl.Text = option
                    if flag then w.flags[flag] = selected end

                    if selected_accent then
                        for i2, v in ipairs(w.accents) do
                            if v == selected_accent then
                                table.remove(w.accents, i2)
                                break
                            end
                        end
                        selected_accent.obj.TextColor3 = t.text
                        selected_accent = nil
                    end

                    opt_lbl.TextColor3 = t.accent
                    selected_accent = {obj = opt_lbl, prop = "TextColor3"}
                    table.insert(w.accents, selected_accent)

                    task.spawn(close_dropdown)
                    if callback then callback(option) end
                end)
            end

            search_box:GetPropertyChangedSignal("Text"):Connect(function()
                local q = search_box.Text:lower()
                for _, ref in ipairs(opt_refs) do
                    ref.btn.Visible = q == "" or ref.text:lower():find(q, 1, true) ~= nil
                end
            end)

            dropdown_btn.MouseButton1Click:Connect(function()
                play("click")
                open = not open

                if open then
                    local content_height = list_layout.AbsoluteContentSize.Y + 8
                    local max_list = math.min(content_height, 166)
                    list_frame.Visible = true
                    kyri.svc.tw:Create(container, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 42 + 34 + max_list + 4)
                    }):Play()
                    kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 34 + max_list)
                    }):Play()
                    kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    task.spawn(close_dropdown)
                end
            end)

            table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(inp, gpe)
                if not open then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                local pos = inp.Position
                local ap = container.AbsolutePosition
                local as = container.AbsoluteSize
                if pos.X < ap.X or pos.X > ap.X + as.X or pos.Y < ap.Y or pos.Y > ap.Y + as.Y then
                    task.spawn(close_dropdown)
                end
            end))

            dropdown_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            dropdown_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
            end)

            local api = {container = container}
            function api:set(option)
                selected = option
                selected_lbl.Text = option
                if flag then w.flags[flag] = selected end
                if selected_accent then
                    for i2, v in ipairs(w.accents) do
                        if v == selected_accent then
                            table.remove(w.accents, i2)
                            break
                        end
                    end
                    selected_accent.obj.TextColor3 = t.text
                    selected_accent = nil
                end
                for _, child in ipairs(list_container:GetChildren()) do
                    if child:IsA("TextButton") then
                        local lbl = child:FindFirstChildOfClass("TextLabel")
                        if lbl and lbl.Text == option then
                            lbl.TextColor3 = t.accent
                            selected_accent = {obj = lbl, prop = "TextColor3"}
                            table.insert(w.accents, selected_accent)
                        end
                    end
                end
            end
            function api:get() return selected end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:multiselect(text, options, def, callback, flag)
            local selected = {}
            if def then
                for _, v in ipairs(def) do selected[v] = true end
            end
            local open = false

            local function get_list()
                local out = {}
                for k, v in pairs(selected) do
                    if v then table.insert(out, k) end
                end
                return out
            end

            local function display_text()
                local list = get_list()
                if #list == 0 then return "none" end
                if #list == 1 then return list[1] end
                return #list .. " selected"
            end

            if flag then w.flags[flag] = get_list() end

            local container = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})

            make("TextLabel", {
                Size = UDim2.new(1, -110, 0, 42),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = container
            })

            local dropdown_btn = make("TextButton", {
                Size = UDim2.fromOffset(100, 28),
                Position = UDim2.new(1, -16, 0, 7),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = t.container,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 3,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = dropdown_btn})

            local selected_lbl = make("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = display_text(),
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropdown_btn
            })

            local arrow = make("TextLabel", {
                Size = UDim2.fromOffset(20, 28),
                Position = UDim2.new(1, -5, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 10,
                Parent = dropdown_btn
            })

            local list_frame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 46),
                BackgroundColor3 = t.bg,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 2,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = list_frame})

            local list_container = make("ScrollingFrame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = t.accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y,
                BorderSizePixel = 0,
                Parent = list_frame
            })
            table.insert(w.accents, {obj = list_container, prop = "ScrollBarImageColor3"})

            local list_layout = make("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = list_container
            })

            make("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = list_container
            })

            list_layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list_container.CanvasSize = UDim2.new(0, 0, 0, list_layout.AbsoluteContentSize.Y + 8)
            end)

            local function close_ms()
                open = false
                kyri.svc.tw:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.wait(0.2)
                if list_frame and list_frame.Parent then
                    list_frame.Visible = false
                end
            end

            for i, option in ipairs(options) do
                local is_sel = selected[option] == true

                local opt_btn = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = is_sel and t.active or t.element,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = list_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = opt_btn})

                local opt_lbl = make("TextLabel", {
                    Size = UDim2.new(1, -46, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = is_sel and t.accent or t.text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = opt_btn
                })

                local check = make("TextLabel", {
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Text = is_sel and "✓" or "",
                    TextColor3 = t.accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    Parent = opt_btn
                })

                if is_sel then
                    table.insert(w.accents, {obj = opt_lbl, prop = "TextColor3"})
                    table.insert(w.accents, {obj = check, prop = "TextColor3"})
                end

                opt_btn.MouseEnter:Connect(function()
                    if not selected[option] then
                        kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                    end
                end)
                opt_btn.MouseLeave:Connect(function()
                    if not selected[option] then
                        kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
                    end
                end)

                opt_btn.MouseButton1Click:Connect(function()
                    play("click")
                    selected[option] = not selected[option]
                    local now = selected[option] == true
                    check.Text = now and "✓" or ""
                    opt_lbl.TextColor3 = now and t.accent or t.text
                    opt_btn.BackgroundColor3 = now and t.active or t.element
                    selected_lbl.Text = display_text()
                    if flag then w.flags[flag] = get_list() end
                    if callback then callback(get_list()) end
                end)
            end

            dropdown_btn.MouseButton1Click:Connect(function()
                play("click")
                open = not open

                if open then
                    local content_height = list_layout.AbsoluteContentSize.Y + 8
                    local max_height = math.min(content_height, 200)
                    list_frame.Visible = true
                    kyri.svc.tw:Create(container, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 42 + max_height + 4)
                    }):Play()
                    kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, max_height)
                    }):Play()
                    kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    task.spawn(close_ms)
                end
            end)

            table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(inp, gpe)
                if not open then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                local pos = inp.Position
                local ap = container.AbsolutePosition
                local as = container.AbsoluteSize
                if pos.X < ap.X or pos.X > ap.X + as.X or pos.Y < ap.Y or pos.Y > ap.Y + as.Y then
                    task.spawn(close_ms)
                end
            end))

            dropdown_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            dropdown_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
            end)

            local api = {container = container}
            function api:get() return get_list() end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:colorpicker(text, def, callback, flag)
            local current = def or Color3.fromRGB(255, 255, 255)
            if flag then w.flags[flag] = current end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local preview_btn = make("TextButton", {
                Size = UDim2.fromOffset(44, 22),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = current,
                Text = "",
                AutoButtonColor = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 5), Parent = preview_btn})

            local function on_color(c)
                current = c
                preview_btn.BackgroundColor3 = c
                if flag then w.flags[flag] = c end
                if callback then callback(c) end
            end

            preview_btn.MouseButton1Click:Connect(function()
                play("click")
                make_colorpicker_popup(current, on_color)
            end)

            preview_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            preview_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
            end)

            local api = {box = box}
            function api:set(color) on_color(color) end
            function api:get() return current end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:image(id, height)
            height = height or 120
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, height),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            local img = make("ImageLabel", {
                Size = UDim2.new(1, -8, 1, -8),
                Position = UDim2.fromOffset(4, 4),
                BackgroundTransparency = 1,
                Image = id or "",
                ScaleType = Enum.ScaleType.Fit,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = img})

            local api = {box = box, img = img}
            function api:set(new_id) img.Image = new_id end
            return api
        end

        function tab:progressbar(text, max_val)
            max_val = max_val or 100
            local cur = 0

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -90, 0, 20),
                Position = UDim2.fromOffset(16, 8),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local pct_lbl = make("TextLabel", {
                Size = UDim2.fromOffset(60, 20),
                Position = UDim2.new(1, -16, 0, 8),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "0%",
                TextColor3 = t.accent,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = box
            })
            table.insert(w.accents, {obj = pct_lbl, prop = "TextColor3"})

            local track = make("Frame", {
                Size = UDim2.new(1, -32, 0, 5),
                Position = UDim2.fromOffset(16, 34),
                BackgroundColor3 = t.container,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

            local fill = make("Frame", {
                Size = UDim2.fromScale(0, 1),
                BackgroundColor3 = t.accent,
                Parent = track
            })
            table.insert(w.accents, {obj = fill, prop = "BackgroundColor3"})
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})

            local api = {box = box}
            function api:set(val, animate)
                cur = math.clamp(val, 0, max_val)
                local pct = cur / max_val
                pct_lbl.Text = math.floor(pct * 100) .. "%"
                if animate then
                    kyri.svc.tw:Create(fill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Size = UDim2.fromScale(pct, 1)
                    }):Play()
                else
                    fill.Size = UDim2.fromScale(pct, 1)
                end
            end
            function api:get() return cur end
            return api
        end

        function tab:keybind(text, default, hold_to_interact, callback, flag)
            local current_key = default or "None"
            local listening = false
            local holding = false
            local is_mouse = false

            local mouse_names = {
                [Enum.UserInputType.MouseButton1] = "Mouse1",
                [Enum.UserInputType.MouseButton2] = "Mouse2",
                [Enum.UserInputType.MouseButton3] = "Mouse3"
            }

            if flag then w.flags[flag] = current_key end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -130, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local keybind_btn = make("TextButton", {
                Size = UDim2.fromOffset(100, 28),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = t.container,
                Text = current_key,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                AutoButtonColor = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = keybind_btn})

            local function update_key(new_key, mouse)
                current_key = new_key
                is_mouse = mouse or false
                keybind_btn.Text = new_key
                if flag then w.flags[flag] = new_key end
            end

            keybind_btn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keybind_btn.Text = "..."
                play("click")

                local conn
                conn = kyri.svc.inp.InputBegan:Connect(function(input, gpe)
                    if gpe then return end

                    local mname = mouse_names[input.UserInputType]
                    if mname then
                        conn:Disconnect()
                        listening = false
                        update_key(mname, true)
                        return
                    end

                    local key = input.KeyCode.Name
                    if key ~= "Unknown" then
                        conn:Disconnect()
                        listening = false
                        update_key(key, false)
                    end
                end)
            end)

            table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(input, gpe)
                if gpe or listening then return end

                local triggered = false
                if is_mouse then
                    triggered = mouse_names[input.UserInputType] == current_key
                else
                    triggered = input.KeyCode.Name == current_key
                end

                if triggered then
                    if hold_to_interact then
                        holding = true
                        if callback then callback(true) end
                    else
                        if callback then callback() end
                    end
                end
            end))

            table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(input, gpe)
                if not hold_to_interact or not holding then return end

                local released = false
                if is_mouse then
                    released = mouse_names[input.UserInputType] == current_key
                else
                    released = input.KeyCode.Name == current_key
                end

                if released then
                    holding = false
                    if callback then callback(false) end
                end
            end))

            keybind_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(keybind_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            keybind_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(keybind_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
            end)

            local api = {box = box}
            function api:set(new_key, mouse) update_key(new_key, mouse) end
            function api:get() return current_key end
            function api:setcallback(fn) callback = fn end
            return api
        end

        w.tabs[name] = tab

        if not w.active then
            task.wait()
            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = UDim2.new(0, 3, 0, 38)}):Play()
            if tab.icon then
                kyri.svc.tw:Create(tab.icon, ti, {ImageColor3 = t.text}):Play()
            end
            w.active = tab
        end

        return tab
    end

    function w:create_settings()
        local settings = self:tab("Settings")

        settings:label("config management")

        local config_name_result = settings:input("config name", "MyConfig", function() end)
        local config_name_input = config_name_result.input

        local function create_popup(ptitle, message, on_yes)
            local popup_gui = make("ScreenGui", {
                Name = "KyriPopup",
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 999999999,
                Parent = kyri.svc.plr.LocalPlayer.PlayerGui
            })

            local overlay = make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.5,
                Parent = popup_gui
            })

            local popup = make("Frame", {
                Size = UDim2.fromOffset(320, 160),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = t.bg,
                Parent = overlay
            })
            make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = popup})

            make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 30),
                Position = UDim2.fromOffset(16, 16),
                BackgroundTransparency = 1,
                Text = ptitle,
                TextColor3 = t.text,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = popup
            })

            make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 40),
                Position = UDim2.fromOffset(16, 50),
                BackgroundTransparency = 1,
                Text = message,
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = popup
            })

            local btn_container = make("Frame", {
                Size = UDim2.new(1, -32, 0, 36),
                Position = UDim2.fromOffset(16, 108),
                BackgroundTransparency = 1,
                Parent = popup
            })
            make("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                Parent = btn_container
            })

            local function create_btn(label, is_yes)
                local btn = make("TextButton", {
                    Size = UDim2.fromOffset(140, 36),
                    BackgroundColor3 = is_yes and t.accent or t.element,
                    Text = label,
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 13,
                    AutoButtonColor = false,
                    Parent = btn_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})

                btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(btn, TweenInfo.new(0.15), {
                        BackgroundColor3 = is_yes and t.accent or t.element
                    }):Play()
                end)
                btn.MouseButton1Click:Connect(function()
                    if is_yes and on_yes then on_yes() end
                    popup_gui:Destroy()
                end)
            end

            create_btn("yes", true)
            create_btn("no", false)
        end

        local function refresh_configs()
            for _, child in ipairs(settings.page:GetChildren()) do
                if child.Name == "KyriConfigRow" then
                    child:Destroy()
                end
            end

            local configs = list_configs(w.game_name)
            for _, cfg_name in ipairs(configs) do
                local cfg_btn = make("Frame", {
                    Name = "KyriConfigRow",
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = t.element,
                    Parent = settings.page
                })
                make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = cfg_btn})

                local load_btn = make("TextButton", {
                    Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = cfg_btn
                })

                make("TextLabel", {
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.fromOffset(16, 0),
                    BackgroundTransparency = 1,
                    Text = cfg_name,
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = load_btn
                })

                local delete_btn = make("ImageButton", {
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -15, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6022668885",
                    ImageColor3 = t.subtext,
                    Parent = cfg_btn
                })

                load_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(cfg_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                load_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(cfg_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
                end)
                delete_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(delete_btn, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(255, 100, 100)}):Play()
                end)
                delete_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(delete_btn, TweenInfo.new(0.15), {ImageColor3 = t.subtext}):Play()
                end)

                load_btn.MouseButton1Click:Connect(function()
                    local data = load_config(w.game_name, cfg_name)
                    if data then
                        for flag, value in pairs(data) do
                            w.flags[flag] = value
                            local set_func = w.flags[flag .. "_set"]
                            if set_func then set_func(value, true) end
                        end
                    end
                end)

                delete_btn.MouseButton1Click:Connect(function()
                    create_popup(
                        "delete config",
                        "are you sure you want to delete '" .. cfg_name .. "'?",
                        function()
                            delete_config(w.game_name, cfg_name)
                            refresh_configs()
                        end
                    )
                end)
            end
        end

        settings:button("save config", function()
            if config_name_input and config_name_input.Text ~= "" then
                local cfg_name = config_name_input.Text
                local data = {}
                for flag, value in pairs(w.flags) do
                    if not flag:match("_set$") then
                        data[flag] = value
                    end
                end
                save_config(w.game_name, cfg_name, data)
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
        if options.AutoLoad then
            local data = load_config(w.game_name, options.AutoLoad)
            if data then
                for flag, value in pairs(data) do
                    w.flags[flag] = value
                    local set_func = w.flags[flag .. "_set"]
                    if set_func then set_func(value, true) end
                end
            end
        end
    end)

    function w:notify(title, text, duration)
        duration = duration or 3

        local notif_gui = w.localPlayer.PlayerGui:FindFirstChild("KyriNotifications")
        if not notif_gui then
            notif_gui = make("ScreenGui", {
                Name = "KyriNotifications",
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 999999998,
                Parent = w.localPlayer.PlayerGui
            })

            local container = make("Frame", {
                Name = "Container",
                Size = UDim2.new(0, 320, 1, 0),
                Position = UDim2.new(1, -20, 0, 20),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Parent = notif_gui
            })

            make("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Parent = container
            })
        end

        local container = notif_gui.Container

        -- wrapper holds all pieces as siblings so nothing clips anything
        local wrapper = make("Frame", {
            Size = UDim2.fromOffset(320, 77),
            BackgroundTransparency = 1,
            Parent = container
        })

        -- accent bar: sits to the left of the notif (bar rel X=-16, Y=4, W=13, H=63)
        local bar = make("Frame", {
            Size = UDim2.fromOffset(13, 63),
            Position = UDim2.fromOffset(-16, 4),
            BackgroundColor3 = t.accent,
            Parent = wrapper
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bar})

        local notif = make("Frame", {
            Size = UDim2.fromOffset(320, 70),
            BackgroundColor3 = t.bg,
            BackgroundTransparency = 0.2,
            Parent = wrapper
        })
        make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = notif})

        local title_lbl = make("TextLabel", {
            Size = UDim2.new(1, -24, 0, 20),
            Position = UDim2.fromOffset(14, 10),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = t.text,
            Font = Enum.Font.GothamBold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notif
        })

        local text_lbl = make("TextLabel", {
            Size = UDim2.new(1, -24, 0, 30),
            Position = UDim2.fromOffset(14, 32),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = t.subtext,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Parent = notif
        })

        -- progress bar: sits below the notif (prog rel Y=74, H=3)
        local prog_bg = make("Frame", {
            Size = UDim2.fromOffset(320, 3),
            Position = UDim2.fromOffset(0, 74),
            BackgroundColor3 = t.container,
            Parent = wrapper
        })
        local prog_fill = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = t.accent,
            Parent = prog_bg
        })

        local dismissed = false
        local function dismiss()
            if dismissed then return end
            dismissed = true
            kyri.svc.tw:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            kyri.svc.tw:Create(bar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            kyri.svc.tw:Create(title_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            kyri.svc.tw:Create(text_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            kyri.svc.tw:Create(prog_fill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            kyri.svc.tw:Create(prog_bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            if wrapper and wrapper.Parent then wrapper:Destroy() end
        end

        local click_btn = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 5,
            Parent = notif
        })
        click_btn.MouseButton1Click:Connect(dismiss)

        wrapper.Position = UDim2.new(0, 340, 0, 0)
        kyri.svc.tw:Create(wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        kyri.svc.tw:Create(prog_fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.fromScale(0, 1)
        }):Play()

        task.delay(duration, dismiss)
    end

    function w:accent(color)
        t.accent = color
        for _, d in ipairs(w.accents) do
            if d.obj and d.obj.Parent then
                d.obj[d.prop] = color
            end
        end
    end

    function w:destroy()
        for _, c in ipairs(conns) do
            pcall(function() c:Disconnect() end)
        end
        if w.gui and w.gui.Parent then w.gui:Destroy() end
        local ng = w.localPlayer.PlayerGui:FindFirstChild("KyriNotifications")
        if ng then ng:Destroy() end
        if w.is_mobile then
            pcall(function() kyri.svc.cas:UnbindAction("KyriToggle") end)
        end
    end

    if getgenv then getgenv().__kyri_inst = w end
    return w
end

return kyri
