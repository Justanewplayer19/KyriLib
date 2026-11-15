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
    cas = svc("ContextActionService"),
    txt = svc("TextChatService")
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

kyri.presets = {
    ["kyri"] = {
        bg = Color3.fromRGB(8,8,10), container = Color3.fromRGB(14,14,18),
        element = Color3.fromRGB(20,20,26), hover = Color3.fromRGB(28,28,36),
        active = Color3.fromRGB(32,32,42), accent = Color3.fromRGB(138,116,249),
        text = Color3.fromRGB(245,245,250), subtext = Color3.fromRGB(165,165,180),
        border = Color3.fromRGB(32,32,40),
    },
    ["midnight"] = {
        bg = Color3.fromRGB(6,8,14), container = Color3.fromRGB(10,14,22),
        element = Color3.fromRGB(16,20,32), hover = Color3.fromRGB(22,28,44),
        active = Color3.fromRGB(26,34,52), accent = Color3.fromRGB(80,160,255),
        text = Color3.fromRGB(240,245,255), subtext = Color3.fromRGB(140,160,200),
        border = Color3.fromRGB(24,32,50),
    },
    ["rose"] = {
        bg = Color3.fromRGB(12,8,10), container = Color3.fromRGB(18,12,16),
        element = Color3.fromRGB(26,18,22), hover = Color3.fromRGB(36,24,30),
        active = Color3.fromRGB(44,28,36), accent = Color3.fromRGB(255,110,150),
        text = Color3.fromRGB(255,245,248), subtext = Color3.fromRGB(190,160,170),
        border = Color3.fromRGB(40,26,32),
    },
    ["forest"] = {
        bg = Color3.fromRGB(8,12,8), container = Color3.fromRGB(12,18,12),
        element = Color3.fromRGB(18,26,18), hover = Color3.fromRGB(24,34,24),
        active = Color3.fromRGB(30,42,30), accent = Color3.fromRGB(80,220,120),
        text = Color3.fromRGB(240,250,240), subtext = Color3.fromRGB(150,190,155),
        border = Color3.fromRGB(24,38,24),
    },
    ["slate"] = {
        bg = Color3.fromRGB(12,12,14), container = Color3.fromRGB(18,18,22),
        element = Color3.fromRGB(26,26,32), hover = Color3.fromRGB(34,34,42),
        active = Color3.fromRGB(40,40,50), accent = Color3.fromRGB(160,160,185),
        text = Color3.fromRGB(240,240,245), subtext = Color3.fromRGB(160,160,175),
        border = Color3.fromRGB(36,36,44),
    },
}

-- LucideBlox icon pack, fetched from icons.json and cached to KyriLib/icons.json
-- Usage: w:tab("Name", "icon-name") -- e.g. "sword", "users", "settings-2"
-- Loaded once here, at require time. It cannot be deferred to first lookup:
-- HttpGet yields, and yielding inside an __index metamethod throws.
-- Set getgenv().kyri_icon_source before loading the lib to use your own pack.
local ICON_URL = "https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/icons.json"
local ICON_FILE = "KyriLib/icons.json"

local function decode_icons(raw)
    if type(raw) ~= "string" or #raw < 64 then return nil end
    local ok, tbl = pcall(function() return kyri.svc.http:JSONDecode(raw) end)
    if ok and type(tbl) == "table" and next(tbl) then return tbl end
    return nil
end

local function fetch_icons()
    local tbl

    if isfile then
        pcall(function()
            if isfile(ICON_FILE) then tbl = decode_icons(readfile(ICON_FILE)) end
        end)
    end
    if tbl then return tbl end

    local raw
    pcall(function()
        raw = game:HttpGet((getgenv and getgenv().kyri_icon_source) or ICON_URL)
    end)
    tbl = decode_icons(raw)

    if tbl and writefile then
        pcall(function()
            if isfolder and not isfolder("KyriLib") then makefolder("KyriLib") end
            writefile(ICON_FILE, raw)
        end)
    end
    return tbl
end

kyri.icons = fetch_icons() or {}

function kyri.reload_icons()
    if isfile and isfile(ICON_FILE) then
        pcall(function() delfile(ICON_FILE) end)
    end
    kyri.icons = fetch_icons() or kyri.icons
    return kyri.icons
end

local function rnd(n)
    local c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local s = ""
    for i = 1, n or math.random(9, 15) do
        local p = math.random(1, #c)
        s = s .. c:sub(p, p)
    end
    return s
end

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

local function ico(ic)
    if not ic then return nil end
    if kyri.icons[ic] then return kyri.icons[ic] end
    if type(ic) == "string" and (ic:find("^rbxassetid://") or ic:find("^rbxthumb://") or ic:find("^rbxasset://")) then return ic end
    return nil
end

local has_cg = pcall(function()
    local o = Instance.new("CanvasGroup")
    o:Destroy()
end)

local function layer(p, vis)
    return make(has_cg and "CanvasGroup" or "Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        GroupTransparency = has_cg and (vis and 0 or 1) or nil,
        Visible = vis,
        Parent = p
    })
end

local function fade(o, tr, dur)
    if has_cg then
        kyri.svc.tw:Create(o, TweenInfo.new(dur or 0.18), {GroupTransparency = tr}):Play()
    else
        o.Visible = tr < 0.5
    end
end

local ISLAND_FILE = "KyriLib/island.json"

local function save_island_pos(root)
    if not writefile then return end
    pcall(function()
        if isfolder and not isfolder("KyriLib") then makefolder("KyriLib") end
        local p = root.Position
        writefile(ISLAND_FILE, kyri.svc.http:JSONEncode({
            sx = p.X.Scale, ox = p.X.Offset,
            sy = p.Y.Scale, oy = p.Y.Offset,
            ax = root.AnchorPoint.X, ay = root.AnchorPoint.Y
        }))
    end)
end

function kyri.island(opts)
    opts = opts or {}
    local t = kyri.theme
    local lp = kyri.svc.plr.LocalPlayer
    local conns = {}

    local isl = {}
    isl.expanded = false
    isl.playing = false
    isl.seeking = false

    local cw = opts.width or 230
    local ch = opts.height or 38
    local ew = opts.expanded_width or 330
    local gap = 11
    local show_bars = opts.bars ~= false
    local show_seek = opts.seek ~= false
    local show_vol = opts.volume ~= false
    local draggable = opts.draggable ~= false

    if getgenv and getgenv().__kyri_island then
        pcall(function() getgenv().__kyri_island:Destroy() end)
        getgenv().__kyri_island = nil
    end

    -- inset is NOT ignored on purpose: the roblox topbar lives in CoreGui and draws
    -- over PlayerGui at any DisplayOrder, so y=0 here would hide the pill behind it
    local gui = make("ScreenGui", {
        Name = rnd(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = false,
        DisplayOrder = 999999997,
        Parent = lp.PlayerGui
    })
    gui:SetAttribute("kyri", true)
    if getgenv then getgenv().__kyri_island = gui end
    isl.gui = gui

    local ipos = opts.position or UDim2.new(0.5, 0, 0, opts.y or 10)
    local ianc = opts.position and Vector2.new(0, 0) or Vector2.new(0.5, 0)

    if opts.remember ~= false and isfile then
        pcall(function()
            if isfile(ISLAND_FILE) then
                local d = kyri.svc.http:JSONDecode(readfile(ISLAND_FILE))
                if d and d.ox then
                    ipos = UDim2.new(d.sx, d.ox, d.sy, d.oy)
                    ianc = Vector2.new(d.ax, d.ay)
                end
            end
        end)
    end

    local root = make("Frame", {
        Size = UDim2.fromOffset(cw, ch),
        Position = ipos,
        AnchorPoint = ianc,
        BackgroundColor3 = opts.color or Color3.fromRGB(7, 7, 9),
        ClipsDescendants = true,
        Parent = gui
    })
    isl.root = root

    local rc = make("UICorner", {CornerRadius = UDim.new(0, math.floor(ch / 2)), Parent = root})
    make("UIStroke", {Color = t.border, Thickness = 1, Transparency = 0.3, Parent = root})

    local cv = layer(root, true)
    local ev = layer(root, false)

    local art = make("ImageLabel", {
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(0, 7, 0.5, -12),
        BackgroundColor3 = t.element,
        Image = opts.image or "",
        ScaleType = Enum.ScaleType.Crop,
        Parent = cv
    })
    make("UICorner", {CornerRadius = UDim.new(0, 7), Parent = art})

    local art_ic = make("ImageLabel", {
        Size = UDim2.fromOffset(13, 13),
        Position = UDim2.new(0.5, -7, 0.5, -7),
        BackgroundTransparency = 1,
        Image = ico(opts.icon) or kyri.icons["music"],
        ImageColor3 = t.subtext,
        Visible = (opts.image or "") == "",
        Parent = art
    })

    local ctitle = make("TextLabel", {
        Size = UDim2.new(1, show_bars and -74 or -48, 1, 0),
        Position = UDim2.fromOffset(39, 0),
        BackgroundTransparency = 1,
        Text = opts.title or "kyri",
        TextColor3 = t.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = cv
    })

    local bar_objs = {}
    if show_bars then
        local bars = make("Frame", {
            Size = UDim2.fromOffset(17, 14),
            Position = UDim2.new(1, -26, 0.5, -7),
            BackgroundTransparency = 1,
            Parent = cv
        })
        for i = 1, 3 do
            local b = make("Frame", {
                Size = UDim2.fromOffset(3, 3),
                Position = UDim2.new(0, (i - 1) * 7, 1, 0),
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = t.accent,
                Parent = bars
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = b})
            bar_objs[i] = b
        end
        task.spawn(function()
            while gui.Parent do
                if isl.playing and not isl.expanded then
                    for i,b in pairs(bar_objs) do
                        kyri.svc.tw:Create(b, TweenInfo.new(0.21), {Size = UDim2.fromOffset(3, math.random(3, 14))}):Play()
                    end
                elseif bar_objs[1] and bar_objs[1].Size.Y.Offset ~= 3 then
                    for i,b in pairs(bar_objs) do
                        kyri.svc.tw:Create(b, TweenInfo.new(0.2), {Size = UDim2.fromOffset(3, 3)}):Play()
                    end
                end
                task.wait(0.22)
            end
        end)
    end

    make("UIPadding", {
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        Parent = ev
    })
    make("UIListLayout", {
        Padding = UDim.new(0, gap),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ev
    })

    local head = make("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = ev
    })

    local bart = make("ImageLabel", {
        Size = UDim2.fromOffset(52, 52),
        BackgroundColor3 = t.element,
        Image = opts.image or "",
        ScaleType = Enum.ScaleType.Crop,
        Parent = head
    })
    make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = bart})

    local bart_ic = make("ImageLabel", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(0.5, -10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = ico(opts.icon) or kyri.icons["music"],
        ImageColor3 = t.subtext,
        Visible = (opts.image or "") == "",
        Parent = bart
    })

    local etitle = make("TextLabel", {
        Size = UDim2.new(1, -96, 0, 20),
        Position = UDim2.fromOffset(64, 6),
        BackgroundTransparency = 1,
        Text = opts.title or "kyri",
        TextColor3 = t.text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = head
    })

    local esub = make("TextLabel", {
        Size = UDim2.new(1, -96, 0, 16),
        Position = UDim2.fromOffset(64, 27),
        BackgroundTransparency = 1,
        Text = opts.subtitle or "",
        TextColor3 = t.subtext,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = head
    })

    local close = make("ImageButton", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(1, -20, 0, 6),
        BackgroundTransparency = 1,
        Image = kyri.icons["x"],
        ImageColor3 = t.subtext,
        Parent = head
    })

    local quit
    if opts.on_close then
        quit = make("ImageButton", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.new(1, -48, 0, 6),
            BackgroundTransparency = 1,
            Image = ico("power") or kyri.icons["x"],
            ImageColor3 = t.subtext,
            Parent = head
        })
        quit.MouseButton1Click:Connect(function() pcall(opts.on_close) end)
        quit.MouseEnter:Connect(function()
            kyri.svc.tw:Create(quit, TweenInfo.new(0.15), {ImageColor3 = t.text}):Play()
        end)
        quit.MouseLeave:Connect(function()
            kyri.svc.tw:Create(quit, TweenInfo.new(0.15), {ImageColor3 = t.subtext}):Play()
        end)
    end

    local function drag_bar(hit, track, fill, cb, held)
        local down = false
        local function upd(x)
            local pct = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            fill.Size = UDim2.fromScale(pct, 1)
            return pct
        end
        hit.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                down = true
                if held then isl.seeking = true end
                upd(i.Position.X)
            end
        end)
        table.insert(conns, kyri.svc.inp.InputChanged:Connect(function(i)
            if not down then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                upd(i.Position.X)
            end
        end))
        table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(i)
            if not down then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                down = false
                local pct = upd(i.Position.X)
                if cb then pcall(cb, pct) end
                if held then
                    task.delay(0.5, function() isl.seeking = false end)
                end
            end
        end))
    end

    local sfill, lt, rt
    if show_seek then
        local srow = make("Frame", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Parent = ev
        })
        local strack = make("Frame", {
            Size = UDim2.new(1, 0, 0, 4),
            BackgroundColor3 = t.element,
            Parent = srow
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = strack})

        sfill = make("Frame", {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = t.accent,
            Parent = strack
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sfill})

        local shit = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.fromOffset(0, -7),
            BackgroundTransparency = 1,
            Text = "",
            Parent = strack
        })
        drag_bar(shit, strack, sfill, function(p)
            if isl.on_seek then isl.on_seek(p) end
        end, true)

        lt = make("TextLabel", {
            Size = UDim2.new(0, 60, 0, 14),
            Position = UDim2.fromOffset(0, 10),
            BackgroundTransparency = 1,
            Text = "0:00",
            TextColor3 = t.subtext,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = srow
        })

        rt = make("TextLabel", {
            Size = UDim2.new(0, 60, 0, 14),
            Position = UDim2.new(1, -60, 0, 10),
            BackgroundTransparency = 1,
            Text = "0:00",
            TextColor3 = t.subtext,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = srow
        })
    end

    local trow = make("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Parent = ev
    })
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = trow
    })

    local vfill, vic
    if show_vol then
        local vrow = make("Frame", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            LayoutOrder = 4,
            Parent = ev
        })
        vic = make("ImageLabel", {
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.fromOffset(0, 1),
            BackgroundTransparency = 1,
            Image = kyri.icons["volume-2"],
            ImageColor3 = t.subtext,
            Parent = vrow
        })
        local vtrack = make("Frame", {
            Size = UDim2.new(1, -24, 0, 4),
            Position = UDim2.fromOffset(24, 6),
            BackgroundColor3 = t.element,
            Parent = vrow
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = vtrack})

        vfill = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = t.subtext,
            Parent = vtrack
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = vfill})

        local vhit = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.fromOffset(0, -6),
            BackgroundTransparency = 1,
            Text = "",
            Parent = vtrack
        })
        drag_bar(vhit, vtrack, vfill, function(p)
            if isl.on_volume then isl.on_volume(math.floor(p * 100)) end
        end)
    end

    local body
    if opts.body_height then
        body = make("Frame", {
            Size = UDim2.new(1, 0, 0, opts.body_height),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            LayoutOrder = 5,
            Parent = ev
        })
        isl.body = body
    end

    local function exp_h()
        local h, n = 0, 0
        for i,c in pairs(ev:GetChildren()) do
            if c:IsA("GuiObject") then
                h = h + c.Size.Y.Offset
                n = n + 1
            end
        end
        return h + math.max(n - 1, 0) * gap + 28
    end

    if body and opts.total_height then
        local over = exp_h() - body.Size.Y.Offset
        body.Size = UDim2.new(1, 0, 0, math.max(opts.total_height - over, 120))
    end

    local tap = make("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10,
        Parent = root
    })

    local function set_expanded(state)
        if isl.expanded == state then return end
        isl.expanded = state
        tap.Visible = not state
        local ti = TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        if state then
            ev.Visible = true
            kyri.svc.tw:Create(root, ti, {Size = UDim2.fromOffset(ew, exp_h())}):Play()
            kyri.svc.tw:Create(rc, TweenInfo.new(0.3), {CornerRadius = UDim.new(0, 22)}):Play()
            fade(cv, 1, 0.12)
            fade(ev, 0, 0.26)
        else
            kyri.svc.tw:Create(root, ti, {Size = UDim2.fromOffset(cw, ch)}):Play()
            kyri.svc.tw:Create(rc, TweenInfo.new(0.3), {CornerRadius = UDim.new(0, math.floor(ch / 2))}):Play()
            fade(ev, 1, 0.12)
            fade(cv, 0, 0.26)
            task.delay(0.24, function()
                if not isl.expanded then ev.Visible = false end
            end)
        end
        if isl.on_toggle then pcall(isl.on_toggle, state) end
    end

    close.MouseButton1Click:Connect(function()
        set_expanded(false)
    end)
    close.MouseEnter:Connect(function()
        kyri.svc.tw:Create(close, TweenInfo.new(0.15), {ImageColor3 = t.text}):Play()
    end)
    close.MouseLeave:Connect(function()
        kyri.svc.tw:Create(close, TweenInfo.new(0.15), {ImageColor3 = t.subtext}):Play()
    end)

    do
        local held, moved, start, origin = false, 0, nil, nil

        tap.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                held = true
                moved = 0
                start = i.Position
                origin = root.Position
                kyri.svc.tw:Create(root, TweenInfo.new(0.12), {Size = UDim2.fromOffset(cw + 6, ch + 2)}):Play()
            end
        end)

        table.insert(conns, kyri.svc.inp.InputChanged:Connect(function(i)
            if not held or not draggable then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                local d = i.Position - start
                moved = math.max(moved, math.abs(d.X) + math.abs(d.Y))
                if moved > 6 then
                    root.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
                end
            end
        end))

        table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(i)
            if not held then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                held = false
                if moved <= 6 then
                    root.Size = UDim2.fromOffset(cw, ch)
                    set_expanded(true)
                else
                    kyri.svc.tw:Create(root, TweenInfo.new(0.15), {Size = UDim2.fromOffset(cw, ch)}):Play()
                    if opts.remember ~= false then save_island_pos(root) end
                end
            end
        end))
    end

    tap.MouseEnter:Connect(function()
        kyri.svc.tw:Create(root, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(16, 16, 20)}):Play()
        if opts.hover then set_expanded(true) end
    end)
    tap.MouseLeave:Connect(function()
        kyri.svc.tw:Create(root, TweenInfo.new(0.15), {BackgroundColor3 = opts.color or Color3.fromRGB(7, 7, 9)}):Play()
    end)

    function isl:button(icon, cb, name)
        local b = make("ImageButton", {
            Size = UDim2.fromOffset(34, 34),
            BackgroundColor3 = t.element,
            Image = "",
            AutoButtonColor = false,
            Parent = trow
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = b})

        local im = make("ImageLabel", {
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(0.5, -8, 0.5, -8),
            BackgroundTransparency = 1,
            Image = ico(icon) or kyri.icons["play"],
            ImageColor3 = t.text,
            Parent = b
        })

        b.MouseButton1Click:Connect(function()
            if cb then pcall(cb) end
        end)
        b.MouseEnter:Connect(function()
            kyri.svc.tw:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
        end)
        b.MouseLeave:Connect(function()
            kyri.svc.tw:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
        end)
        if name then b.Name = name end

        local api = {box = b, img = im}
        function api:icon(new) im.Image = ico(new) or im.Image end
        function api:tint(c) im.ImageColor3 = c end
        function api:setcallback(fn) cb = fn end
        return api
    end

    function isl:row(text)
        local r = make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = text or "",
            TextColor3 = t.subtext,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 9,
            Parent = ev
        })
        local api = {box = r}
        function api:set(v) r.Text = v end
        return api
    end

    function isl:set(d)
        if not d then return end
        if d.title then
            ctitle.Text = d.title
            etitle.Text = d.title
        end
        if d.subtitle ~= nil then esub.Text = d.subtitle end
        if d.image ~= nil then
            art.Image = d.image
            bart.Image = d.image
            art_ic.Visible = d.image == ""
            bart_ic.Visible = d.image == ""
        end
        if d.icon then
            local id = ico(d.icon)
            if id then
                art_ic.Image = id
                bart_ic.Image = id
            end
        end
        if d.progress and sfill and not isl.seeking then
            sfill.Size = UDim2.fromScale(math.clamp(d.progress, 0, 1), 1)
        end
        if d.left and lt then lt.Text = d.left end
        if d.right and rt then rt.Text = d.right end
        if d.volume and vfill then
            vfill.Size = UDim2.fromScale(math.clamp(d.volume / 100, 0, 1), 1)
            if vic then vic.Image = d.volume <= 0 and kyri.icons["volume-x"] or kyri.icons["volume-2"] end
        end
        if d.playing ~= nil then isl.playing = d.playing end
    end

    function isl:expand() set_expanded(true) end
    function isl:collapse() set_expanded(false) end
    function isl:toggle() set_expanded(not isl.expanded) end

    function isl:relayout()
        if isl.expanded then
            kyri.svc.tw:Create(root, TweenInfo.new(0.2), {Size = UDim2.fromOffset(ew, exp_h())}):Play()
        end
    end

    function isl:notify(text, dur)
        local was = ctitle.Text
        local wasbar = isl.playing
        isl.playing = false
        ctitle.Text = text
        if not isl.expanded then
            kyri.svc.tw:Create(root, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(cw + 24, ch)
            }):Play()
        end
        task.delay(dur or 2.5, function()
            if ctitle.Text ~= text then return end
            ctitle.Text = was
            isl.playing = wasbar
            if not isl.expanded then
                kyri.svc.tw:Create(root, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    Size = UDim2.fromOffset(cw, ch)
                }):Play()
            end
        end)
    end

    function isl:visible(v) root.Visible = v end

    function isl:resetpos()
        if isfile and isfile(ISLAND_FILE) then pcall(function() delfile(ISLAND_FILE) end) end
        root.AnchorPoint = opts.position and Vector2.new(0, 0) or Vector2.new(0.5, 0)
        root.Position = opts.position or UDim2.new(0.5, 0, 0, opts.y or 10)
    end
    function isl:onseek(fn) isl.on_seek = fn end
    function isl:onvolume(fn) isl.on_volume = fn end

    function isl:destroy()
        for i,c in pairs(conns) do
            pcall(function() c:Disconnect() end)
        end
        if gui and gui.Parent then gui:Destroy() end
    end

    isl.on_seek = opts.on_seek
    isl.on_volume = opts.on_volume
    isl.on_toggle = opts.on_toggle

    root.Size = UDim2.fromOffset(cw, 0)
    kyri.svc.tw:Create(root, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(cw, ch)
    }):Play()

    return isl
end
local sha_k = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local function sha256(msg)
    local h = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19}
    local len = #msg
    local bits = len * 8
    local tail = ""
    for i = 7, 0, -1 do
        tail = tail .. string.char(math.floor(bits / 2 ^ (8 * i)) % 256)
    end
    msg = msg .. "\128" .. string.rep("\0", (55 - len) % 64) .. tail

    for i = 1, #msg, 64 do
        local w = {}
        for j = 0, 15 do
            local a, b, c, d = msg:byte(i + j * 4, i + j * 4 + 3)
            w[j + 1] = a * 16777216 + b * 65536 + c * 256 + d
        end
        for j = 17, 64 do
            local v, v2 = w[j - 15], w[j - 2]
            local s0 = bit32.bxor(bit32.rrotate(v, 7), bit32.rrotate(v, 18), bit32.rshift(v, 3))
            local s1 = bit32.bxor(bit32.rrotate(v2, 17), bit32.rrotate(v2, 19), bit32.rshift(v2, 10))
            w[j] = (w[j - 16] + s0 + w[j - 7] + s1) % 4294967296
        end

        local a, b, c, d, e, f, g, hh = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
        for j = 1, 64 do
            local S1 = bit32.bxor(bit32.rrotate(e, 6), bit32.rrotate(e, 11), bit32.rrotate(e, 25))
            local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
            local t1 = (hh + S1 + ch + sha_k[j] + w[j]) % 4294967296
            local S0 = bit32.bxor(bit32.rrotate(a, 2), bit32.rrotate(a, 13), bit32.rrotate(a, 22))
            local mj = bit32.bxor(bit32.band(a, b), bit32.band(a, c), bit32.band(b, c))
            local t2 = (S0 + mj) % 4294967296
            hh, g, f, e = g, f, e, (d + t1) % 4294967296
            d, c, b, a = c, b, a, (t1 + t2) % 4294967296
        end

        h[1] = (h[1] + a) % 4294967296
        h[2] = (h[2] + b) % 4294967296
        h[3] = (h[3] + c) % 4294967296
        h[4] = (h[4] + d) % 4294967296
        h[5] = (h[5] + e) % 4294967296
        h[6] = (h[6] + f) % 4294967296
        h[7] = (h[7] + g) % 4294967296
        h[8] = (h[8] + hh) % 4294967296
    end

    local out = ""
    for i = 1, 8 do
        local v = h[i]
        out = out .. string.char(bit32.extract(v, 24, 8), bit32.extract(v, 16, 8), bit32.extract(v, 8, 8), bit32.extract(v, 0, 8))
    end
    return out
end

local b64c = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

local function b64url(data)
    local out = {}
    for i = 1, #data, 3 do
        local a, b, c = data:byte(i, i + 2)
        local n = a * 65536 + (b or 0) * 256 + (c or 0)
        local idx = {bit32.extract(n, 18, 6), bit32.extract(n, 12, 6), bit32.extract(n, 6, 6), bit32.extract(n, 0, 6)}
        local cnt = b and (c and 4 or 3) or 2
        for j = 1, cnt do
            out[#out + 1] = b64c:sub(idx[j] + 1, idx[j] + 1)
        end
    end
    return table.concat(out)
end

local vchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"

local function verifier()
    local rng = Random.new(math.floor(tick() * 1e6) % 2147483647)
    local out = {}
    for i = 1, 64 do
        local p = rng:NextInteger(1, #vchars)
        out[i] = vchars:sub(p, p)
    end
    return table.concat(out)
end

local function fmt_time(s)
    return string.format("%d:%02d", math.floor(s / 60), math.floor(s % 60))
end

function kyri.spotify(opts)
    opts = opts or {}
    local hs = kyri.svc.http
    local req = request or http_request or (http and http.request) or (syn and syn.request)

    local sp = {}
    sp.ready = false
    sp.playing = false
    sp.pos, sp.dur, sp.vol = 0, 0, 100
    sp.shuffle = false
    sp.loop = "off"
    sp.track = nil
    sp.results = {}

    local CID = opts.client_id or "035b9c837a6f46ffaffce6ada163a6ad"
    local REDIR = opts.redirect or "http://127.0.0.1:8888/callback"
    local SCOPES = opts.scopes or "user-read-playback-state user-modify-playback-state user-read-currently-playing user-read-recently-played user-library-modify user-library-read"
    local DIR = "KyriLib/spotify"
    local TOK = DIR .. "/tokens.json"
    local PK = DIR .. "/pkce.txt"
    local ART = DIR .. "/art"

    local token, refresh, alive = "", "", true
    local cur_id, seeking, last_seek = "", false, 0

    local function dirs()
        if not isfolder("KyriLib") then makefolder("KyriLib") end
        if not isfolder(DIR) then makefolder(DIR) end
        if not isfolder(ART) then makefolder(ART) end
    end

    local function save_tokens(a, r)
        dirs()
        if a then token = a end
        if r then refresh = r end
        writefile(TOK, hs:JSONEncode({access_token = token, refresh_token = refresh}))
    end

    local function load_tokens()
        if not isfile(TOK) then return false end
        local ok, d = pcall(function() return hs:JSONDecode(readfile(TOK)) end)
        if not ok or type(d) ~= "table" then return false end
        token = d.access_token or ""
        refresh = d.refresh_token or ""
        return refresh ~= ""
    end

    local function form(tbl)
        local parts = {}
        for k,v in pairs(tbl) do
            parts[#parts + 1] = k .. "=" .. hs:UrlEncode(v)
        end
        return table.concat(parts, "&")
    end

    local function new_token()
        if refresh == "" or not req then return false end
        local res = req({
            Url = "https://accounts.spotify.com/api/token",
            Method = "POST",
            Headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
            Body = form({grant_type = "refresh_token", refresh_token = refresh, client_id = CID})
        })
        if res and res.StatusCode == 200 then
            local d = hs:JSONDecode(res.Body)
            save_tokens(d.access_token, d.refresh_token)
            sp.ready = true
            return true
        end
        return false
    end

    function sp:authurl()
        local v = verifier()
        dirs()
        writefile(PK, v)
        return "https://accounts.spotify.com/authorize?"
            .. form({
                client_id = CID,
                response_type = "code",
                redirect_uri = REDIR,
                scope = SCOPES,
                code_challenge_method = "S256",
                code_challenge = b64url(sha256(v))
            })
    end

    function sp:submit(code)
        if not code or code == "" then return false, "no code" end
        if not isfile(PK) then return false, "no verifier, copy the auth url again" end
        code = code:gsub("%s", "")
        code = code:match("[?&]code=([^&]+)") or code
        local res = req({
            Url = "https://accounts.spotify.com/api/token",
            Method = "POST",
            Headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
            Body = form({
                grant_type = "authorization_code",
                code = code,
                redirect_uri = REDIR,
                client_id = CID,
                code_verifier = readfile(PK)
            })
        })
        if res and res.StatusCode == 200 then
            local d = hs:JSONDecode(res.Body)
            save_tokens(d.access_token, d.refresh_token)
            pcall(function() delfile(PK) end)
            sp.ready = true
            return true
        end
        return false, res and res.Body or "no response"
    end

    local function api(method, ep, body)
        if not sp.ready and not new_token() then return nil end
        local headers = {
            ["Authorization"] = "Bearer " .. token,
            ["Content-Type"] = "application/json",
            ["Content-Length"] = "0"
        }
        local rd = {Url = "https://api.spotify.com/v1" .. ep, Method = method, Headers = headers}
        if body then
            local bs = hs:JSONEncode(body)
            rd.Body = bs
            headers["Content-Length"] = tostring(#bs)
        end
        local ok, res = pcall(req, rd)
        if not ok then return nil end
        if res and res.StatusCode == 401 and new_token() then
            headers["Authorization"] = "Bearer " .. token
            rd.Headers = headers
            local ok2, res2 = pcall(req, rd)
            if ok2 then res = res2 end
        end
        return res
    end

    local function good(r)
        return r and (r.StatusCode == 200 or r.StatusCode == 202 or r.StatusCode == 204)
    end

    sp.request = api

    function sp:authed() return sp.ready end

    function sp:play()
        local r = api("PUT", "/me/player/play")
        if good(r) then sp.playing = true end
        return good(r)
    end

    function sp:pause()
        local r = api("PUT", "/me/player/pause")
        if good(r) then sp.playing = false end
        return good(r)
    end

    function sp:toggle()
        if sp.playing then return sp:pause() end
        return sp:play()
    end

    function sp:next()
        local r = api("POST", "/me/player/next")
        cur_id = ""
        task.delay(0.4, function() sp:sync() end)
        return good(r)
    end

    function sp:prev()
        local r = api("POST", "/me/player/previous")
        cur_id = ""
        task.delay(0.4, function() sp:sync() end)
        return good(r)
    end

    function sp:seek(pct)
        if sp.dur <= 0 then return false end
        local now = tick()
        if now - last_seek < 0.35 then return false end
        last_seek = now
        seeking = true
        local r = api("PUT", "/me/player/seek?position_ms=" .. math.floor(math.clamp(pct, 0, 1) * sp.dur * 1000))
        if good(r) then sp.pos = math.floor(pct * sp.dur) end
        task.delay(0.6, function() seeking = false end)
        return good(r)
    end

    function sp:volume(v)
        v = math.clamp(math.floor(v), 0, 100)
        local r = api("PUT", "/me/player/volume?volume_percent=" .. v)
        if good(r) then sp.vol = v end
        return good(r)
    end

    function sp:setshuffle(state)
        local r = api("PUT", "/me/player/shuffle?state=" .. (state and "true" or "false"))
        if good(r) then sp.shuffle = state end
        return good(r)
    end

    function sp:setloop(mode)
        if mode == nil then
            mode = sp.loop == "off" and "context" or (sp.loop == "context" and "track" or "off")
        end
        local r = api("PUT", "/me/player/repeat?state=" .. mode)
        if good(r) then sp.loop = mode end
        return good(r), sp.loop
    end

    function sp:like()
        if not sp.track or not sp.track.id then return false end
        return good(api("PUT", "/me/tracks?ids=" .. sp.track.id))
    end

    function sp:search(q, limit)
        if not q or q == "" then return {} end
        local r = api("GET", "/search?q=" .. hs:UrlEncode(q) .. "&type=track&limit=" .. (limit or 8))
        if not r or r.StatusCode ~= 200 then return {} end
        local d = hs:JSONDecode(r.Body)
        sp.results = (d.tracks and d.tracks.items) or {}
        return sp.results
    end

    function sp:playuri(uri)
        local r = api("PUT", "/me/player/play", {uris = {uri}})
        cur_id = ""
        task.delay(0.4, function() sp:sync() end)
        return good(r)
    end

    function sp:queue(uri)
        return good(api("POST", "/me/player/queue?uri=" .. hs:UrlEncode(uri)))
    end

    function sp:devices()
        local r = api("GET", "/me/player/devices")
        if not r or r.StatusCode ~= 200 then return {} end
        return hs:JSONDecode(r.Body).devices or {}
    end

    function sp:artists()
        if not sp.track or not sp.track.artists then return "" end
        local a = {}
        for i,v in pairs(sp.track.artists) do a[#a + 1] = v.name end
        return table.concat(a, ", ")
    end

    local art_cache = {}

    local function load_art(url, id, cb)
        if not url or url == "" or not getcustomasset then return end
        if art_cache[id] then
            cb(art_cache[id])
            return
        end
        task.spawn(function()
            pcall(function()
                dirs()
                local f = ART .. "/" .. id .. ".jpg"
                if not isfile(f) then
                    local res = req({Url = url, Method = "GET"})
                    if not res or res.StatusCode ~= 200 then return end
                    writefile(f, res.Body)
                end
                local asset = getcustomasset(f)
                art_cache[id] = asset
                cb(asset)
            end)
        end)
    end

    local isl, ui
    local own_island = true
    sp.on_track = opts.on_track

    local function push(d)
        if isl then isl:set(d) end
        if ui then ui(d) end
    end

    function sp:sync()
        local r = api("GET", "/me/player/currently-playing")
        if not r or r.StatusCode ~= 200 then
            if r and r.StatusCode == 204 then
                push({title = "nothing playing", subtitle = "", playing = false, progress = 0})
                sp.playing = false
            end
            return
        end
        local ok, d = pcall(function() return hs:JSONDecode(r.Body) end)
        if not ok or not d or not d.item then return end

        sp.playing = d.is_playing and true or false
        sp.pos = math.floor((d.progress_ms or 0) / 1000)
        sp.dur = math.floor((d.item.duration_ms or 0) / 1000)
        if d.device and d.device.volume_percent then sp.vol = d.device.volume_percent end
        if d.shuffle_state ~= nil then sp.shuffle = d.shuffle_state end
        if d.repeat_state then sp.loop = d.repeat_state end

        local changed = d.item.id ~= cur_id
        sp.track = d.item

        if changed then
            cur_id = d.item.id
            push({title = d.item.name, subtitle = sp:artists(), image = "", playing = sp.playing})
            if d.item.album and d.item.album.images and #d.item.album.images > 0 then
                load_art(d.item.album.images[1].url, d.item.id, function(asset)
                    if cur_id == d.item.id then push({image = asset}) end
                end)
            end
            if sp.on_track then pcall(sp.on_track, d.item) end
        end

        push({
            playing = sp.playing,
            volume = sp.vol,
            progress = sp.dur > 0 and (sp.pos / sp.dur) or 0,
            left = fmt_time(sp.pos),
            right = fmt_time(sp.dur)
        })
    end

    function sp:destroy()
        alive = false
        if isl and own_island then pcall(function() isl:destroy() end) end
    end

    dirs()
    if load_tokens() then
        sp.ready = true
        task.spawn(new_token)
    end

    -- an island-mode window already owns a pill, so share it rather than drop a
    -- second one on top. opts.island = true forces a separate island anyway
    own_island = opts.island ~= false
    if opts.island ~= true and opts.window and opts.window.isl then
        isl = opts.window.isl
        own_island = false
    end

    if own_island then
        isl = kyri.island({
            title = sp.ready and "spotify" or "spotify · not connected",
            subtitle = "",
            icon = "music",
            width = opts.island_width or 240,
            expanded_width = 340,
            on_seek = function(p) sp:seek(p) end,
            on_volume = function(v) sp:volume(v) end,
            y = opts.island_y,
            position = opts.island_position,
            hover = opts.island_hover
        })
    end

    if isl then
        sp.island = isl

        isl:button("shuffle", function()
            sp:setshuffle(not sp.shuffle)
            isl:notify(sp.shuffle and "shuffle on" or "shuffle off", 1.5)
        end, "shuffle")

        isl:button("skip-back", function() sp:prev() end, "prev")

        local pb
        pb = isl:button("play", function()
            sp:toggle()
            pb:icon(sp.playing and "pause" or "play")
        end, "toggle")

        isl:button("skip-forward", function() sp:next() end, "next")

        local lb
        lb = isl:button("repeat", function()
            local _, m = sp:setloop()
            lb:tint(m == "off" and kyri.theme.subtext or kyri.theme.accent)
            isl:notify("repeat: " .. m, 1.5)
        end, "loop")
        lb:tint(kyri.theme.subtext)

        isl:button("heart", function()
            if sp:like() then isl:notify("added to liked", 1.5) end
        end, "like")

        local base_push = push
        push = function(d)
            base_push(d)
            if d.playing ~= nil then pb:icon(d.playing and "pause" or "play") end
        end
    end

    local w = opts.window
    if not w and opts.tabs ~= false then
        w = kyri.new(opts.title or "spotify", {GameName = "Spotify"})
    end
    sp.window = w

    if w and opts.tabs ~= false then
        local np = w:tab("Now Playing", "music")
        local art_api = np:image("", 240, Enum.ScaleType.Crop)
        local t_lbl = np:label("not playing")
        local a_lbl = np:label("")
        local time_lbl = np:label("0:00 / 0:00")

        np:section("seek")
        local seek_api = np:slider("position", 0, 100, 0, function(pct)
            sp:seek(pct / 100)
        end, nil, 0.1)

        np:section("controls")
        local play_api = np:button("play / pause", function() sp:toggle() end, "play")
        np:button("previous", function() sp:prev() end, "skip-back")
        np:button("next", function() sp:next() end, "skip-forward")

        np:section("playback")
        local vol_api = np:slider("volume", 0, 100, 100, function(v) sp:volume(v) end, "sp_vol", 1)
        np:toggle("shuffle", false, function(s) sp:setshuffle(s) end)
        local loop_api
        loop_api = np:button("repeat: off", function()
            local _, m = sp:setloop()
            loop_api:set("repeat: " .. m)
        end, "repeat")
        np:button("like current track", function()
            if sp:like() then w:notify("spotify", "added to liked songs", 2) end
        end, "heart")

        local srch = w:tab("Search", "search")
        srch:label("type a song name and press enter")
        srch:space()
        srch:input("search", "song name...", function(q)
            for i,c in pairs(srch.page:GetChildren()) do
                if c.Name == "SpotifyResult" then c:Destroy() end
            end
            local items = sp:search(q)
            if #items == 0 then
                w:notify("search", "no results for: " .. q, 2)
                return
            end
            for i,tr in pairs(items) do
                if tr and tr.name and tr.uri then
                    local a = {}
                    for j,v in pairs(tr.artists or {}) do a[#a + 1] = v.name end
                    local rb = srch:button(i .. ".  " .. tr.name .. "  —  " .. table.concat(a, ", "), function()
                        if sp:playuri(tr.uri) then
                            w:notify("playing", tr.name, 3)
                            if isl then isl:notify(tr.name, 2.5) end
                        end
                    end)
                    rb.box.Name = "SpotifyResult"
                end
            end
        end)

        local at = w:tab("Auth", "key")
        at:section("connect spotify")
        at:paragraph("how to authenticate",
            "1. click 'copy auth url'\n2. open it in your browser and approve\n3. the page will fail to load — that is normal\n4. copy the whole url from the address bar\n5. paste it below and submit")

        local st_lbl
        at:button("copy auth url", function()
            setclipboard(sp:authurl())
            w:notify("copied", "auth url copied, open it in your browser", 3)
        end, "link")

        at:space()
        st_lbl = at:label(sp.ready and "status: connected" or "status: not connected")
        local code_in = at:input("callback url or code", "paste here", function() end)

        at:button("submit", function()
            local raw = code_in.input.Text
            if raw == "" then
                w:notify("spotify", "paste the code first", 2)
                return
            end
            st_lbl:set("status: connecting...")
            task.spawn(function()
                local ok, err = sp:submit(raw)
                if ok then
                    st_lbl:set("status: connected")
                    w:notify("spotify", "connected", 3)
                    if isl then isl:set({title = "spotify"}) end
                    sp:sync()
                else
                    st_lbl:set("status: failed, try again")
                    w:notify("spotify", tostring(err):sub(1, 90), 4)
                end
            end)
        end, "check")

        at:space()
        at:button("sign out", function()
            pcall(function() delfile(TOK) end)
            token, refresh, sp.ready = "", "", false
            st_lbl:set("status: not connected")
            w:notify("spotify", "signed out", 2)
        end, "log-out")

        ui = function(d)
            if d.title then t_lbl:set(d.title) end
            if d.subtitle ~= nil and d.subtitle ~= "" then a_lbl:set(d.subtitle) end
            if d.image ~= nil then art_api:set(d.image) end
            if d.left and d.right then time_lbl:set(d.left .. "  /  " .. d.right) end
            if d.progress and not seeking then seek_api:set(math.clamp(d.progress * 100, 0, 100)) end
            if d.volume then vol_api:set(d.volume) end
        end
    end

    if not req then
        if w then w:notify("spotify", "this executor has no http support", 5) end
        return sp
    end

    task.spawn(function()
        local n = 0
        while alive and task.wait(1) do
            if sp.ready then
                if sp.playing and not seeking then
                    sp.pos = math.min(sp.pos + 1, sp.dur)
                    push({
                        progress = sp.dur > 0 and (sp.pos / sp.dur) or 0,
                        left = fmt_time(sp.pos),
                        right = fmt_time(sp.dur)
                    })
                end
                n = n + 1
                if n % 5 == 0 then
                    task.spawn(function() sp:sync() end)
                end
            end
        end
    end)

    if sp.ready then task.spawn(function() sp:sync() end) end

    if opts.commands then
        local function say(m)
            pcall(function()
                kyri.svc.txt.TextChannels.RBXGeneral:SendAsync(m)
            end)
        end
        local cmds = {
            play = function() sp:play() say("resumed") end,
            pause = function() sp:pause() say("paused") end,
            skip = function() sp:next() say("skipped") end,
            back = function() sp:prev() say("back") end,
            like = function() say(sp:like() and "liked" or "failed") end,
            current = function()
                if sp.track then
                    say((sp.playing and "playing" or "paused") .. ": " .. sp.track.name .. " by " .. sp:artists())
                else
                    say("nothing playing")
                end
            end,
            volume = function(a) if sp:volume(tonumber(a[1]) or 50) then say("volume " .. sp.vol) end end,
            shuffle = function(a)
                sp:setshuffle(a[1] == "on")
                say("shuffle " .. (a[1] or "off"))
            end,
            loop = function(a) local _, m = sp:setloop(a[1]) say("repeat " .. m) end,
            search = function(a)
                local items = sp:search(table.concat(a, " "), 5)
                for i,tr in pairs(items) do say(i .. ". " .. tr.name) end
            end,
            pick = function(a)
                local tr = sp.results[tonumber(a[1]) or 0]
                if tr then
                    sp:playuri(tr.uri)
                    say("playing " .. tr.name)
                end
            end,
            help = function()
                say("!sp play/pause/skip/back/current/like | search [q] pick [n] | volume [0-100] | loop [mode] | shuffle [on/off]")
            end
        }
        local me = kyri.svc.plr.LocalPlayer
        kyri.svc.txt.MessageReceived:Connect(function(msg)
            if not msg.TextSource or msg.TextSource.UserId ~= me.UserId then return end
            local args = {}
            for word in msg.Text:gmatch("%S+") do args[#args + 1] = word end
            if args[1] ~= "!sp" or not args[2] then return end
            local fn = cmds[args[2]:lower()]
            if not fn then return end
            local rest = {}
            for i = 3, #args do rest[#rest + 1] = args[i] end
            task.spawn(function() pcall(fn, rest) end)
        end)
    end

    if getgenv then getgenv().__kyri_spotify = sp end
    return sp
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

    -- gui names are randomised, so stale instances are found by attribute
    for i,g in pairs(localPlayer.PlayerGui:GetChildren()) do
        if g:IsA("ScreenGui") and g:GetAttribute("kyri") then g:Destroy() end
    end

    local load_gui = make("ScreenGui", {
        Name = rnd(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999,
        Parent = localPlayer.PlayerGui
    })
    load_gui:SetAttribute("kyri", true)

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

    -- Key system
    if options.KeySystem then
        local ks = options.KeySettings or {}
        local validKeys = ks.Key or {}
        local fileName = ks.FileName and (ks.FileName .. "_kyrikey.txt")
        local th = kyri.theme
        local mode = options.KeySystem == "Everytime" and "Everytime" or "Once"

        local savedKeyValid = false
        if mode == "Once" and fileName then
            pcall(function()
                if isfile(fileName) then
                    local saved = readfile(fileName)
                    for _, k in ipairs(validKeys) do
                        if saved == k then savedKeyValid = true break end
                    end
                end
            end)
        end

        if not savedKeyValid then
            local keyGui = make("ScreenGui", {
                Name = rnd(),
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 999999999,
                Parent = localPlayer.PlayerGui
            })

            local dialog = make("Frame", {
                Size = UDim2.fromOffset(480, 200),
                Position = UDim2.new(0.5, -240, 0.5, -100),
                BackgroundColor3 = th.bg,
                Parent = keyGui
            })
            make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = dialog })
            make("UIStroke", { Color = th.border, Thickness = 1, Parent = dialog })

            make("TextLabel", {
                Size = UDim2.new(1, -60, 0, 28),
                Position = UDim2.fromOffset(20, 18),
                BackgroundTransparency = 1,
                Text = ks.Title or "Key System",
                TextColor3 = th.text,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            make("TextLabel", {
                Size = UDim2.new(1, -60, 0, 18),
                Position = UDim2.fromOffset(20, 44),
                BackgroundTransparency = 1,
                Text = ks.Subtitle or "Enter your key to continue",
                TextColor3 = th.subtext,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            local closeBtn = make("TextButton", {
                Size = UDim2.fromOffset(30, 30),
                Position = UDim2.new(1, -38, 0, 8),
                BackgroundTransparency = 1,
                Text = "×",
                TextColor3 = th.subtext,
                TextSize = 22,
                Font = Enum.Font.GothamBold,
                Parent = dialog
            })

            -- left side: key input
            make("TextLabel", {
                Size = UDim2.new(0.5, -30, 0, 16),
                Position = UDim2.fromOffset(20, 80),
                BackgroundTransparency = 1,
                Text = "Key",
                TextColor3 = th.subtext,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            local keyBox = make("Frame", {
                Size = UDim2.new(0.52, 0, 0, 36),
                Position = UDim2.fromOffset(20, 98),
                BackgroundColor3 = th.element,
                Parent = dialog
            })
            make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = keyBox })
            make("UIStroke", { Color = th.border, Thickness = 1, Parent = keyBox })

            local keyInput = make("TextBox", {
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(8, 0),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = "key",
                TextColor3 = th.text,
                PlaceholderColor3 = th.subtext,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = keyBox
            })

            -- right side: note
            if ks.Note then
                make("TextLabel", {
                    Size = UDim2.new(0.44, -22, 1, -20),
                    Position = UDim2.new(0.55, 12, 0, 10),
                    BackgroundTransparency = 1,
                    Text = ks.Note,
                    TextColor3 = th.text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextWrapped = true,
                    Parent = dialog
                })
            end

            local submitBtn = make("TextButton", {
                Size = UDim2.new(0.52, 0, 0, 32),
                Position = UDim2.fromOffset(20, 148),
                BackgroundColor3 = th.accent,
                Text = "Submit",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                Parent = dialog
            })
            make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = submitBtn })

            local errLabel = make("TextLabel", {
                Size = UDim2.new(0.52, 0, 0, 18),
                Position = UDim2.fromOffset(20, 183),
                BackgroundTransparency = 1,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 80, 80),
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            local keyDone = false
            local keyAccepted = false

            local function tryKey(input)
                local trimmed = input:match("^%s*(.-)%s*$")
                for _, k in ipairs(validKeys) do
                    if trimmed == k then return true, trimmed end
                end
                return false
            end

            submitBtn.MouseButton1Click:Connect(function()
                local ok, trimmed = tryKey(keyInput.Text)
                if ok then
                    if mode == "Once" and fileName then
                        pcall(function() writefile(fileName, trimmed) end)
                    end
                    keyAccepted = true
                    keyDone = true
                else
                    errLabel.Text = "invalid key"
                    keyInput.Text = ""
                end
            end)

            closeBtn.MouseButton1Click:Connect(function()
                keyDone = true
            end)

            repeat task.wait() until keyDone
            keyGui:Destroy()

            if not keyAccepted then return end
        end

        -- Success splash
        local splashGui = make("ScreenGui", {
            Name = rnd(),
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 999999999,
            Parent = localPlayer.PlayerGui
        })

        local card = make("Frame", {
            Size = UDim2.fromOffset(280, 110),
            Position = UDim2.new(0.5, -140, 0.5, -55),
            BackgroundColor3 = kyri.theme.bg,
            BackgroundTransparency = 1,
            Parent = splashGui
        })
        make("UICorner", { CornerRadius = UDim.new(0, 14), Parent = card })
        make("UIStroke", { Color = kyri.theme.border, Thickness = 1, Transparency = 1, Parent = card })

        local accent_bar = make("Frame", {
            Size = UDim2.fromOffset(3, 32),
            Position = UDim2.fromOffset(18, 22),
            BackgroundColor3 = kyri.theme.accent,
            BackgroundTransparency = 1,
            Parent = card
        })
        make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accent_bar })

        local splashTitle = make("TextLabel", {
            Size = UDim2.new(1, -50, 0, 26),
            Position = UDim2.fromOffset(30, 20),
            BackgroundTransparency = 1,
            Text = ks.Title or title or "Key System",
            TextColor3 = kyri.theme.text,
            TextTransparency = 1,
            TextSize = 17,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card
        })

        local splashSub = make("TextLabel", {
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.fromOffset(30, 46),
            BackgroundTransparency = 1,
            Text = "by " .. (ks.Creator or "you"),
            TextColor3 = kyri.theme.subtext,
            TextTransparency = 1,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card
        })

        local splashBrand = make("TextLabel", {
            Size = UDim2.new(1, -18, 0, 18),
            Position = UDim2.new(0, 0, 1, -26),
            BackgroundTransparency = 1,
            Text = "Kyri UI",
            TextColor3 = kyri.theme.subtext,
            TextTransparency = 1,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = card
        })

        local fadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
        kyri.svc.tw:Create(card, fadeIn, { BackgroundTransparency = 0 }):Play()
        kyri.svc.tw:Create(card:FindFirstChildOfClass("UIStroke"), fadeIn, { Transparency = 0 }):Play()
        kyri.svc.tw:Create(accent_bar, fadeIn, { BackgroundTransparency = 0 }):Play()
        kyri.svc.tw:Create(splashTitle, fadeIn, { TextTransparency = 0 }):Play()
        kyri.svc.tw:Create(splashSub, fadeIn, { TextTransparency = 0 }):Play()
        kyri.svc.tw:Create(splashBrand, fadeIn, { TextTransparency = 0 }):Play()

        task.wait(2)

        local fadeOut = TweenInfo.new(0.4)
        kyri.svc.tw:Create(card, fadeOut, { BackgroundTransparency = 1 }):Play()
        kyri.svc.tw:Create(card:FindFirstChildOfClass("UIStroke"), fadeOut, { Transparency = 1 }):Play()
        kyri.svc.tw:Create(accent_bar, fadeOut, { BackgroundTransparency = 1 }):Play()
        kyri.svc.tw:Create(splashTitle, fadeOut, { TextTransparency = 1 }):Play()
        kyri.svc.tw:Create(splashSub, fadeOut, { TextTransparency = 1 }):Play()
        kyri.svc.tw:Create(splashBrand, fadeOut, { TextTransparency = 1 }):Play()
        task.wait(0.5)
        splashGui:Destroy()
    end

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
        Name = rnd(),
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

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)

    -- "island" collapses to a pill you click to open, "window" is the classic
    -- sidebar layout. phones get the island by default, the sidebar eats too
    -- much of a narrow screen to be usable
    local mode = options.Mode
    if mode ~= "island" and mode ~= "window" then
        mode = w.is_mobile and "island" or "window"
    end
    w.mode = mode
    w.gui.IgnoreGuiInset = mode ~= "island"

    local remember = options.Remember ~= false
    local POS_FILE = "KyriLib/window.json"

    local function read_pos()
        if not remember or not isfile then return nil end
        local d
        pcall(function()
            if isfile(POS_FILE) then d = kyri.svc.http:JSONDecode(readfile(POS_FILE)) end
        end)
        if type(d) ~= "table" or type(d[mode]) ~= "table" then return nil end
        return d[mode]
    end

    local function write_pos(p, s)
        if not remember or not writefile then return end
        pcall(function()
            local d = {}
            if isfile and isfile(POS_FILE) then
                local ok, got = pcall(function() return kyri.svc.http:JSONDecode(readfile(POS_FILE)) end)
                if ok and type(got) == "table" then d = got end
            end
            d[mode] = {x = p.X.Offset, y = p.Y.Offset, w = s and s.X.Offset, h = s and s.Y.Offset}
            if isfolder and not isfolder("KyriLib") then makefolder("KyriLib") end
            writefile(POS_FILE, kyri.svc.http:JSONEncode(d))
        end)
    end

    local function fit(x, y, sw, sh)
        return math.clamp(x, 0, math.max(vp.X - sw, 0)), math.clamp(y, 0, math.max(vp.Y - sh, 0))
    end

    local main, top, sidebar, content, tab_holder, tab_list
    local ind_pos, ind_off, ind_on
    local on_header_tap, rebind
    local pos_adjust = function(p) return p end

    if mode == "island" then
        local pan_w = w.is_mobile and math.clamp(math.floor(vp.X * 0.9), 260, 420) or 370
        local pan_h = w.is_mobile and math.clamp(math.floor(vp.Y * 0.62), 300, 520) or 430
        w.pan_w, w.pan_h = pan_w, pan_h

        ind_pos = UDim2.new(0, 0, 1, -2)
        ind_off = UDim2.new(0, 0, 0, 2)
        ind_on = UDim2.new(1, 0, 0, 2)

        -- w:spotify swaps the island for one with transport chrome, so every
        -- reference to it has to be reachable again afterwards
        rebind = function(isl)
            w.isl = isl
            main = isl.root
            w.expand = function() isl:expand() end
            w.collapse = function() isl:collapse() end
            w.expanded = function() return isl.expanded end
        end

        rebind(kyri.island({
            title = w.title,
            icon = options.Icon,
            bars = false,
            seek = false,
            volume = false,
            expanded_width = pan_w,
            body_height = pan_h,
            total_height = pan_h,
            on_close = function() w:destroy() end
        }))

        local host = w.isl.body

        local strip = make("Frame", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 1,
            Parent = host
        })
        sidebar = strip

        tab_holder = make("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = Enum.ScrollingDirection.X,
            Parent = strip
        })

        tab_list = make("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tab_holder
        })

        tab_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab_holder.CanvasSize = UDim2.new(0, tab_list.AbsoluteContentSize.X, 0, 0)
        end)

        content = make("Frame", {
            Size = UDim2.new(1, 0, 1, -38),
            Position = UDim2.fromOffset(0, 38),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = host
        })
    else
        local win_w, win_h = 520, 400
        if w.is_mobile then
            win_w = math.clamp(math.floor(vp.X * 0.88), 270, 480)
            win_h = math.clamp(math.floor(vp.Y * 0.6), 240, 400)
        end
        local side_w = w.is_mobile and 104 or 140

        ind_pos = UDim2.new(1, 0, 0, 0)
        ind_off = UDim2.new(0, 0, 0, 38)
        ind_on = UDim2.new(0, 3, 0, 38)

        local sv = read_pos()
        if sv and sv.w and sv.h then
            win_w = math.clamp(sv.w, 400, math.max(math.floor(vp.X), 400))
            win_h = math.clamp(sv.h, 300, math.max(math.floor(vp.Y), 300))
        end
        local pos = UDim2.new(0.5, -win_w / 2, 0.5, -win_h / 2)
        if sv then
            local x, y = fit(sv.x, sv.y, win_w, win_h)
            pos = UDim2.fromOffset(x, y)
        end

        main = make("Frame", {
            Name = rnd(),
            Size = UDim2.fromOffset(win_w, win_h),
            Position = pos,
            BackgroundColor3 = t.bg,
            ClipsDescendants = true,
            Parent = w.gui
        })

        make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = main})

        -- inset from the corner: main clips to a 12px radius, so a flush handle
        -- gets sliced diagonally by the rounding
        local resize_handle = make("ImageButton", {
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.new(1, -8, 1, -8),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6023426962",
            ImageColor3 = t.subtext,
            ImageTransparency = 0.5,
            ZIndex = 100,
            Visible = not w.is_mobile,
            Parent = main
        })

        local minimized = false
        local pre_min_size = nil

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
                    if resizing then write_pos(main.Position, main.Size) end
                    resizing = false
                end
            end))

            resize_handle.MouseEnter:Connect(function()
                kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.text, ImageTransparency = 0}):Play()
            end)
            resize_handle.MouseLeave:Connect(function()
                kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.subtext, ImageTransparency = 0.5}):Play()
            end)
        end

        -- no border stroke on main: against the near-black bg it reads as a faint
        -- grey rim. the drop shadow below carries the edge separation instead.

        top = make("Frame", {
            Size = UDim2.new(1, 0, 0, 52),
            BackgroundColor3 = t.container,
            Parent = main
        })

        make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = top})

        -- squares off the topbar's lower corners so it flows into the body;
        -- hidden while minimised, otherwise the collapsed pill gets square corners
        local top_fill = make("Frame", {
            Size = UDim2.new(1, 0, 0, 12),
            Position = UDim2.new(0, 0, 1, -12),
            BackgroundColor3 = t.container,
            BorderSizePixel = 0,
            Parent = top
        })

        local badge = make("Frame", {
            Size = UDim2.fromOffset(26, 26),
            Position = UDim2.fromOffset(14, 13),
            BackgroundColor3 = t.accent,
            BackgroundTransparency = 0.84,
            Parent = top
        })
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = badge})
        table.insert(w.accents, {obj = badge, prop = "BackgroundColor3"})

        local badge_txt = make("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = (w.title or "k"):sub(1, 1):upper(),
            TextColor3 = t.accent,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            Parent = badge
        })
        table.insert(w.accents, {obj = badge_txt, prop = "TextColor3"})

        local title_lbl = make("TextLabel", {
            Size = UDim2.new(1, -146, 1, 0),
            Position = UDim2.fromOffset(50, 0),
            BackgroundTransparency = 1,
            Text = w.title,
            TextColor3 = t.text,
            Font = Enum.Font.GothamBold,
            TextSize = 17,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = top
        })

        local close = make("ImageButton", {
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(1, -15, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Image = ico("x") or "rbxassetid://7743878857",
            ImageColor3 = t.subtext,
            Parent = top
        })

        local minimize = make("ImageButton", {
            Size = UDim2.fromOffset(18, 18),
            Position = UDim2.new(1, -43, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6026568240",
            ImageColor3 = t.subtext,
            Parent = top
        })

        for i,b in pairs({minimize, close}) do
            b.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(b, TweenInfo.new(0.2), {ImageColor3 = t.text}):Play()
            end)
            b.MouseLeave:Connect(function()
                kyri.svc.tw:Create(b, TweenInfo.new(0.2), {ImageColor3 = t.subtext}):Play()
            end)
        end

        close.MouseButton1Click:Connect(function()
            play("click")
            w:destroy()
        end)

        minimize.MouseButton1Click:Connect(function()
            play("click")
            minimized = not minimized

            if minimized then
                pre_min_size = main.Size
                sidebar.Visible = false
                content.Visible = false
                resize_handle.Visible = false
                top_fill.Visible = false
                local pill = math.clamp(math.floor(title_lbl.TextBounds.X) + 140, 210, 350)
                kyri.svc.tw:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(pill, 52)
                }):Play()
            else
                top_fill.Visible = true
                kyri.svc.tw:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = pre_min_size
                }):Play()
                task.delay(0.3, function()
                    if not minimized then
                        sidebar.Visible = true
                        content.Visible = true
                        resize_handle.Visible = not w.is_mobile
                    end
                end)
            end

            kyri.svc.tw:Create(minimize, TweenInfo.new(0.25), {
                Rotation = minimized and 180 or 0
            }):Play()
        end)

        sidebar = make("Frame", {
            Size = UDim2.new(0, side_w, 1, -64),
            Position = UDim2.fromOffset(12, 58),
            BackgroundTransparency = 1,
            Parent = main
        })

        tab_holder = make("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Parent = sidebar
        })

        tab_list = make("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tab_holder
        })

        tab_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab_holder.CanvasSize = UDim2.new(0, 0, 0, tab_list.AbsoluteContentSize.Y)
        end)

        content = make("Frame", {
            Size = UDim2.new(1, -(side_w + 28), 1, -70),
            Position = UDim2.fromOffset(side_w + 18, 58),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = main
        })
    end

    if mode == "window" then

    -- drop shadow sits outside main, so it is a sibling: main clips its children.
    -- off by default, any soft edge around the frame just looks like a smudge
    local want_shadow = options.Shadow == true

    local shadow = make("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.62,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Visible = want_shadow,
        ZIndex = 0,
        Parent = w.gui
    })

    -- pads down and to the sides, barely at the top. spread evenly it haloes the
    -- frame and reads as a transparent outline instead of a shadow
    local function sync_shadow()
        local p, s = main.Position, main.Size
        shadow.Position = UDim2.new(p.X.Scale, p.X.Offset - 13, p.Y.Scale, p.Y.Offset - 2)
        shadow.Size = UDim2.new(s.X.Scale, s.X.Offset + 26, s.Y.Scale, s.Y.Offset + 22)
        shadow.Visible = main.Visible and want_shadow
    end

    main:GetPropertyChangedSignal("Position"):Connect(sync_shadow)
    main:GetPropertyChangedSignal("Size"):Connect(sync_shadow)
    main:GetPropertyChangedSignal("Visible"):Connect(sync_shadow)
    sync_shadow()

    local drag, drag_input, drag_start, input_start = false, nil, nil, nil
    local moved = false

    local function update_input(input)
        local delta = input.Position - drag_start
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
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
            moved = false
            drag_start = inp.Position
            input_start = main.Position
            drag_input = inp

            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    drag = false
                    if moved then
                        write_pos(pos_adjust(main.Position), mode == "window" and main.Size or nil)
                    elseif on_header_tap then
                        on_header_tap()
                    end
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

    end

    function w:resetpos()
        if mode == "island" then
            if w.isl then w.isl:resetpos() end
            return
        end
        if isfile and isfile(POS_FILE) then pcall(function() delfile(POS_FILE) end) end
    end

    w.gui:SetAttribute("kyri", true)
    w.gui.Parent = localPlayer.PlayerGui
    w.localPlayer = localPlayer

    local function toggle_gui()
        main.Visible = not main.Visible
    end

    if w.is_mobile then
        w.action = rnd()
        kyri.svc.cas:BindAction(w.action, function(name, state, input)
            if state == Enum.UserInputState.Begin then toggle_gui() end
        end, true, Enum.KeyCode.ButtonR3)
        kyri.svc.cas:SetTitle(w.action, (w.title or "k"):sub(1, 1):upper())
        kyri.svc.cas:SetPosition(w.action, UDim2.new(1, -78, 1, -78))
    else
        table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.RightControl then toggle_gui() end
        end))
    end

    local function make_colorpicker_popup(current, on_change)
        local popup_gui = make("ScreenGui", {
            Name = rnd(),
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
            BackgroundColor3 = t.element,
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

        local chip = w.mode == "island"

        local btn = make("TextButton", {
            Name = name,
            Size = chip and UDim2.new(0, 60, 0, 28) or UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = t.element,
            Text = "",
            AutoButtonColor = false,
            Parent = tab_holder
        })
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})

        local has_icon = icon ~= nil
        local text_offset = has_icon and 36 or 12
        if chip then text_offset = has_icon and 29 or 11 end

        if has_icon then
            local icon_id = kyri.icons[icon]
                or (type(icon) == "string" and (icon:find("^rbxassetid://") or icon:find("^rbxthumb://")) and icon)
                or "rbxassetid://7743875962"

            local icon_img = make("ImageLabel", {
                Size = UDim2.fromOffset(chip and 15 or 18, chip and 15 or 18),
                Position = chip and UDim2.fromOffset(9, 6) or UDim2.fromOffset(11, 10),
                BackgroundTransparency = 1,
                Image = icon_id,
                ImageColor3 = t.subtext,
                Parent = btn
            })
            tab.icon = icon_img

            -- download https:// icons via executor request() + getcustomasset()
            if type(icon) == "string" and icon:find("^https://") then
                task.spawn(function()
                    local ok, err = pcall(function()
                        local http = request or http_request or syn and syn.request
                        if not http then return end
                        local res = http({ Url = icon, Method = "GET" })
                        if not res or res.StatusCode ~= 200 or not res.Body then return end
                        if not getcustomasset then return end
                        -- derive a stable filename from the url so the same icon isn't re-downloaded every tab switch
                        local fname = "kyrilib_icons/" .. icon:gsub("[^%w]", "_"):sub(1, 64) .. ".png"
                        if not isfolder("kyrilib_icons") then makefolder("kyrilib_icons") end
                        writefile(fname, res.Body)
                        local asset = getcustomasset(fname)
                        icon_img.Image = asset
                    end)
                    if not ok then
                        -- silently fail — icon stays as default
                    end
                end)
            end
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

        if chip then
            btn.Size = UDim2.new(0, math.clamp(math.floor(txt.TextBounds.X) + text_offset + 13, 54, 150), 0, 28)
            txt.TextSize = 13
        end

        local indicator = make("Frame", {
            Size = ind_off,
            Position = ind_pos,
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

        -- right gutter for the scrollbar: elements are full width, so without it
        -- the 3px accent bar draws on top of their right edge on scrollable tabs
        make("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = page
        })

        local function sync_bar()
            local h = page_list.AbsoluteContentSize.Y + 12
            page.CanvasSize = UDim2.new(0, 0, 0, h)
            page.ScrollBarThickness = h > page.AbsoluteSize.Y + 1 and 3 or 0
        end

        page_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(sync_bar)
        page:GetPropertyChangedSignal("AbsoluteSize"):Connect(sync_bar)

        local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        btn.MouseButton1Click:Connect(function()
            play("click")

            for _, tb in pairs(w.tabs) do
                tb.page.Visible = false
                kyri.svc.tw:Create(tb.btn, ti, {BackgroundColor3 = t.element}):Play()
                kyri.svc.tw:Create(tb.txt, ti, {TextColor3 = t.subtext}):Play()
                kyri.svc.tw:Create(tb.indicator, ti, {Size = ind_off}):Play()
                if tb.icon then
                    kyri.svc.tw:Create(tb.icon, ti, {ImageColor3 = t.subtext}):Play()
                end
            end

            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = ind_on}):Play()
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

        function tab:search(ph)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("ImageLabel", {
                Size = UDim2.fromOffset(14, 14),
                Position = UDim2.fromOffset(11, 10),
                BackgroundTransparency = 1,
                Image = ico("search") or "rbxassetid://7734052925",
                ImageColor3 = t.subtext,
                Parent = box
            })

            local tb = make("TextBox", {
                Size = UDim2.new(1, -42, 1, 0),
                Position = UDim2.fromOffset(33, 0),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = ph or "search",
                PlaceholderColor3 = t.subtext,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                ClearTextOnFocus = false,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local function hit(o, q)
                if (o:IsA("TextLabel") or o:IsA("TextButton")) and o.Text:lower():find(q, 1, true) then
                    return true
                end
                for i,c in pairs(o:GetChildren()) do
                    if hit(c, q) then return true end
                end
                return false
            end

            tb:GetPropertyChangedSignal("Text"):Connect(function()
                local q = tb.Text:lower()
                for i,c in pairs(page:GetChildren()) do
                    if c ~= box and c:IsA("GuiObject") then
                        c.Visible = q == "" or hit(c, q)
                    end
                end
            end)

            return tb
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

        function tab:button(text, callback, icon)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            if icon then
                local icon_id = kyri.icons[icon]
                    or (type(icon) == "string" and (icon:find("^rbxassetid://") or icon:find("^rbxthumb://")) and icon)
                    or "rbxassetid://7743875962"
                local icon_img = make("ImageLabel", {
                    Size = UDim2.fromOffset(18, 18),
                    Position = UDim2.new(0, 14, 0.5, -9),
                    BackgroundTransparency = 1,
                    Image = icon_id,
                    ImageColor3 = t.subtext,
                    Parent = box
                })
                if type(icon) == "string" and icon:find("^https://") then
                    task.spawn(function()
                        pcall(function()
                            local http = request or http_request or syn and syn.request
                            if not http or not getcustomasset then return end
                            local res = http({Url = icon, Method = "GET"})
                            if not res or res.StatusCode ~= 200 then return end
                            if not isfolder("kyrilib_icons") then makefolder("kyrilib_icons") end
                            local fname = "kyrilib_icons/" .. icon:gsub("[^%w]", "_"):sub(1, 64) .. ".png"
                            writefile(fname, res.Body)
                            icon_img.Image = getcustomasset(fname)
                        end)
                    end)
                end
            end

            local text_x = icon and 40 or 16
            local text_w = icon and -56 or -24

            local lbl = make("TextLabel", {
                Size = UDim2.new(1, text_w, 1, 0),
                Position = UDim2.fromOffset(text_x, 0),
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
                Size = UDim2.new(1, 0, 0, w.is_mobile and 82 or 58),
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

            -- value display: click to type a number
            local val_btn = make("TextButton", {
                Size = UDim2.fromOffset(72, 20),
                Position = UDim2.new(1, -16, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextColor3 = t.accent,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                AutoButtonColor = false,
                Parent = box
            })
            table.insert(w.accents, {obj = val_btn, prop = "TextColor3"})

            local val_inp = make("TextBox", {
                Size = UDim2.fromOffset(72, 20),
                Position = UDim2.new(1, -16, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = t.container,
                Text = tostring(val),
                TextColor3 = t.text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Visible = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 4), Parent = val_inp})
            make("UIPadding", {PaddingRight = UDim.new(0, 4), Parent = val_inp})

            -- track: 8px tall for easier targeting
            local track = make("Frame", {
                Size = UDim2.new(1, -32, 0, 8),
                Position = UDim2.fromOffset(16, 36),
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

            -- handle: 18x18 so it's easy to grab
            local handle = make("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 2,
                Parent = track
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = handle})

            -- shared apply: used by drag, type-in, api:set, and config load
            local function apply(new_val, fire_cb)
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
                val_btn.Text = tostring(val)
                if flag then w.flags[flag] = val end
                if fire_cb and callback then callback(val) end
            end

            -- large transparent hit zone: 36px tall covering the track + padding
            -- makes the slider trivial to click and drag on both PC and mobile
            local hit = make("Frame", {
                Size = UDim2.new(1, -32, 0, 36),
                Position = UDim2.fromOffset(16, 20),
                BackgroundTransparency = 1,
                ZIndex = 3,
                Parent = box
            })

            local dragging = false

            local function drag_to(x)
                local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                apply(min + (max - min) * pct, true)
            end

            hit.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                   or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    play("toggle_on")
                    drag_to(inp.Position.X)
                end
            end)

            table.insert(conns, kyri.svc.inp.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement
                   or inp.UserInputType == Enum.UserInputType.Touch then
                    drag_to(inp.Position.X)
                end
            end))

            table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                   or inp.UserInputType == Enum.UserInputType.Touch then
                    if dragging then play("toggle_off") end
                    dragging = false
                end
            end))

            -- click value label → type a number → apply
            val_btn.MouseButton1Click:Connect(function()
                val_btn.Visible = false
                val_inp.Text = tostring(val)
                val_inp.Visible = true
                val_inp:CaptureFocus()
            end)

            val_inp.FocusLost:Connect(function()
                local num = tonumber(val_inp.Text)
                if num then apply(num, true) end
                val_inp.Visible = false
                val_btn.Visible = true
            end)

            -- mobile: keep +/- buttons below the track for fine control
            if w.is_mobile then
                local btn_row = make("Frame", {
                    Size = UDim2.new(1, -32, 0, 28),
                    Position = UDim2.fromOffset(16, 50),
                    BackgroundTransparency = 1,
                    Parent = box
                })
                make("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = btn_row
                })
                local minus_btn = make("TextButton", {
                    Size = UDim2.new(0.45, 0, 1, 0),
                    BackgroundColor3 = t.container,
                    Text = "–",
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 16,
                    AutoButtonColor = false,
                    Parent = btn_row
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = minus_btn})
                local plus_btn = make("TextButton", {
                    Size = UDim2.new(0.45, 0, 1, 0),
                    BackgroundColor3 = t.container,
                    Text = "+",
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 16,
                    AutoButtonColor = false,
                    Parent = btn_row
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = plus_btn})

                minus_btn.MouseButton1Click:Connect(function()
                    play("click")
                    apply(val - (step or 1), true)
                end)
                plus_btn.MouseButton1Click:Connect(function()
                    play("click")
                    apply(val + (step or 1), true)
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
            end

            local api = {box = box}
            function api:set(new_val) apply(new_val, false) end
            function api:get() return val end
            function api:setcallback(fn) callback = fn end
            if flag then
                w.flags[flag .. "_set"] = function(v, fire) apply(v, fire) end
            end
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

        function tab:image(id, height, scale_type)
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
                ScaleType = scale_type or Enum.ScaleType.Fit,
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

        table.insert(w.tabs, tab)

        if not w.active then
            task.wait()
            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = ind_on}):Play()
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
                Name = rnd(),
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

        local cfg_row = rnd()

        local function refresh_configs()
            for _, child in ipairs(settings.page:GetChildren()) do
                if child.Name == cfg_row then
                    child:Destroy()
                end
            end

            local configs = list_configs(w.game_name)

            if #configs == 0 then
                local none = make("Frame", {
                    Name = cfg_row,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Parent = settings.page
                })
                make("TextLabel", {
                    Size = UDim2.new(1, -6, 1, 0),
                    Position = UDim2.fromOffset(6, 0),
                    BackgroundTransparency = 1,
                    Text = "nothing saved yet",
                    TextColor3 = t.subtext,
                    TextTransparency = 0.35,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = none
                })
            end

            for _, cfg_name in ipairs(configs) do
                local cfg_btn = make("Frame", {
                    Name = cfg_row,
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

        settings:space(8)
        settings:section("theme")

        local preset_names = {}
        for name in pairs(kyri.presets) do table.insert(preset_names, name) end
        table.sort(preset_names)
        settings:dropdown("preset", preset_names, "kyri", function(name)
            local p = kyri.presets[name]
            if p then w:apply_theme(p) end
        end)

        settings:space(4)
        settings:section("custom colors")

        local theme_props = {
            {"bg",        "background"},
            {"container", "header"},
            {"element",   "elements"},
            {"accent",    "accent"},
            {"text",      "text"},
            {"subtext",   "subtext"},
            {"border",    "border"},
        }

        for _, pair in ipairs(theme_props) do
            local key, label = pair[1], pair[2]

            local row = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = settings.page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = row})

            make("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = label,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row
            })

            local swatch = make("TextButton", {
                Size = UDim2.fromOffset(44, 22),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = t[key],
                Text = "",
                AutoButtonColor = false,
                Parent = row
            })
            make("UICorner", {CornerRadius = UDim.new(0, 5), Parent = swatch})

            row.MouseEnter:Connect(function()
                kyri.svc.tw:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            row.MouseLeave:Connect(function()
                kyri.svc.tw:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
            end)

            swatch.MouseButton1Click:Connect(function()
                play("click")
                make_colorpicker_popup(t[key], function(c)
                    swatch.BackgroundColor3 = c
                    w:apply_theme({[key] = c})
                end)
            end)
        end

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

        local notif_gui = w.notif_gui
        if not notif_gui or not notif_gui.Parent then
            notif_gui = make("ScreenGui", {
                Name = rnd(),
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 999999998,
                Parent = w.localPlayer.PlayerGui
            })
            notif_gui:SetAttribute("kyri", true)
            w.notif_gui = notif_gui

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

    function w:apply_theme(overrides)
        for key, new_color in pairs(overrides) do
            local old_color = t[key]
            t[key] = new_color
            if key == "accent" then
                for _, d in ipairs(w.accents) do
                    if d.obj and d.obj.Parent then
                        d.obj[d.prop] = new_color
                    end
                end
            elseif old_color then
                for _, obj in ipairs(main:GetDescendants()) do
                    pcall(function()
                        if obj:IsA("GuiObject") and obj.BackgroundColor3 == old_color then
                            obj.BackgroundColor3 = new_color
                        end
                        if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox"))
                           and obj.TextColor3 == old_color then
                            obj.TextColor3 = new_color
                        end
                        if obj:IsA("UIStroke") and obj.Color == old_color then
                            obj.Color = new_color
                        end
                        if (obj:IsA("ImageLabel") or obj:IsA("ImageButton"))
                           and obj.ImageColor3 == old_color then
                            obj.ImageColor3 = new_color
                        end
                    end)
                end
            end
        end
    end

    function w:island(opts)
        if w.mode == "island" then return w.isl end
        opts = opts or {}
        if opts.title == nil then opts.title = title end
        w.isl = kyri.island(opts)
        return w.isl
    end

    function w:spotify(opts)
        opts = opts or {}
        opts.window = w

        -- the hub island has no seek or volume rows, so swap in one that does
        -- and carry the tab panel across. spotify then shares the single pill
        if w.mode == "island" and w.isl and opts.island ~= true then
            local old = w.isl
            local kept = {}

            -- park them outside the island first: kyri.island is a singleton and
            -- destroys the old ScreenGui, which would take these with it
            for i,c in pairs(old.body:GetChildren()) do
                if c:IsA("GuiObject") then
                    c.Visible = false
                    c.Parent = w.gui
                    kept[#kept + 1] = c
                end
            end

            local fresh = kyri.island({
                title = w.title,
                expanded_width = w.pan_w,
                body_height = w.pan_h,
                total_height = w.pan_h,
                on_close = function() w:destroy() end
            })
            for i,c in pairs(kept) do
                c.Parent = fresh.body
                c.Visible = true
            end

            old:destroy()
            if rebind then rebind(fresh) end
        end

        w.sp = kyri.spotify(opts)
        return w.sp
    end

    function w:destroy()
        for _, c in ipairs(conns) do
            pcall(function() c:Disconnect() end)
        end
        if w.sp then pcall(function() w.sp:destroy() end) end
        if w.isl then pcall(function() w.isl:destroy() end) end
        if w.gui and w.gui.Parent then w.gui:Destroy() end
        if w.notif_gui then pcall(function() w.notif_gui:Destroy() end) end
        if w.is_mobile then
            pcall(function() kyri.svc.cas:UnbindAction(w.action) end)
        end
    end

    if getgenv then getgenv().__kyri_inst = w end
    return w
end

return kyri
