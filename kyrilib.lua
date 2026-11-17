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
    txt = svc("TextChatService"),
    cp = svc("ContentProvider"),
    ts = svc("TextService")
}

kyri.studio = KYRI_STUDIO == true or (kyri.svc.run:IsStudio() and not (identifyexecutor or getgenv or gethui))

local function http_get(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 0 then return res end
    ok, res = pcall(function() return kyri.svc.http:GetAsync(url) end)
    if ok and type(res) == "string" and #res > 0 then return res end
    return nil
end

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

local ICON_URL = "https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/icons.json"
local ICON_FILE = "KyriLib/icons.json"

local function decode_icons(raw)
    if type(raw) ~= "string" or #raw < 64 then return nil end
    local ok, tbl = pcall(function() return kyri.svc.http:JSONDecode(raw) end)
    if ok and type(tbl) == "table" and next(tbl) then return tbl end
    return nil
end

local function fetch_icons()
    if type(KYRI_ICONS) == "table" and next(KYRI_ICONS) then return KYRI_ICONS end

    local tbl

    if isfile then
        pcall(function()
            if isfile(ICON_FILE) then tbl = decode_icons(readfile(ICON_FILE)) end
        end)
    end
    if tbl then return tbl end

    local raw
    pcall(function()
        raw = http_get((getgenv and getgenv().kyri_icon_source) or ICON_URL)
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

function kyri.copybox(text, title)
    local lp = kyri.svc.plr.LocalPlayer
    local gui = make("ScreenGui", {
        Name = rnd(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999,
        Parent = lp:FindFirstChildOfClass("PlayerGui")
    })
    gui:SetAttribute("kyri", true)

    local t = kyri.theme

    local box = make("Frame", {
        Size = UDim2.fromOffset(440, 150),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = t.bg,
        Parent = gui
    })
    make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = box})
    make("UIStroke", {Color = t.border, Thickness = 1, Transparency = 0.3, Parent = box})

    make("TextLabel", {
        Size = UDim2.new(1, -28, 0, 20),
        Position = UDim2.fromOffset(16, 14),
        BackgroundTransparency = 1,
        Text = title or "copy this",
        TextColor3 = t.text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = box
    })

    make("TextLabel", {
        Size = UDim2.new(1, -28, 0, 16),
        Position = UDim2.fromOffset(16, 34),
        BackgroundTransparency = 1,
        Text = "select the text and copy it with ctrl+c",
        TextColor3 = t.subtext,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = box
    })

    local field = make("TextBox", {
        Size = UDim2.new(1, -32, 0, 52),
        Position = UDim2.fromOffset(16, 58),
        BackgroundColor3 = t.element,
        Text = text or "",
        TextColor3 = t.text,
        Font = Enum.Font.Code,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ClearTextOnFocus = false,
        TextEditable = true,
        Parent = box
    })
    make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = field})
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 8),
        Parent = field
    })

    local close = make("TextButton", {
        Size = UDim2.fromOffset(72, 26),
        Position = UDim2.new(1, -16, 1, -14),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = t.element,
        Text = "done",
        TextColor3 = t.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = box
    })
    make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = close})
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    task.spawn(function()
        task.wait(0.1)
        pcall(function()
            field:CaptureFocus()
            field.CursorPosition = #field.Text + 1
            field.SelectionStart = 1
        end)
    end)

    return gui
end

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
    if type(ic) == "string" and ic:find("://") then return ic end
    return nil
end

local has_cg = pcall(function()
    local o = Instance.new("CanvasGroup")
    o:Destroy()
end)

local function tip(obj, text)
    if not obj or not text or text == "" then return end

    local box, lbl, stroke
    local token = 0

    local function build()
        local gui = obj:FindFirstAncestorWhichIsA("ScreenGui")
        if not gui then return false end

        box = make("Frame", {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 22),
            BackgroundColor3 = kyri.theme.container,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 120,
            Parent = gui
        })
        make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = box})
        make("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = box
        })
        stroke = make("UIStroke", {
            Color = kyri.theme.border,
            Thickness = 1,
            Transparency = 1,
            Parent = box
        })
        lbl = make("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 22),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = kyri.theme.text,
            TextTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            ZIndex = 121,
            Parent = box
        })
        return true
    end

    local function place()
        local gui = obj:FindFirstAncestorWhichIsA("ScreenGui")
        if not gui then return end
        local a, sz = obj.AbsolutePosition, obj.AbsoluteSize
        local right = (a.X + sz.X / 2) > gui.AbsoluteSize.X / 2
        box.AnchorPoint = Vector2.new(right and 1 or 0, 0)
        box.Position = UDim2.fromOffset(right and (a.X + sz.X) or a.X, a.Y + sz.Y + 7)
    end

    obj.MouseEnter:Connect(function()
        token = token + 1
        local mine = token
        task.delay(0.4, function()
            if mine ~= token then return end
            if not box and not build() then return end
            place()
            box.Visible = true
            local ti = TweenInfo.new(0.12)
            kyri.svc.tw:Create(box, ti, {BackgroundTransparency = 0}):Play()
            kyri.svc.tw:Create(lbl, ti, {TextTransparency = 0}):Play()
            kyri.svc.tw:Create(stroke, ti, {Transparency = 0.3}):Play()
        end)
    end)

    local function hide()
        token = token + 1
        if not box then return end
        local ti = TweenInfo.new(0.1)
        kyri.svc.tw:Create(box, ti, {BackgroundTransparency = 1}):Play()
        kyri.svc.tw:Create(lbl, ti, {TextTransparency = 1}):Play()
        kyri.svc.tw:Create(stroke, ti, {Transparency = 1}):Play()
        task.delay(0.12, function()
            if box and token > 0 then box.Visible = false end
        end)
    end

    obj.MouseLeave:Connect(hide)
    if obj:IsA("GuiButton") then
        obj.MouseButton1Down:Connect(hide)
    end
end

local function remote_icon(obj, url)
    if type(url) ~= "string" or not url:find("^https://") then return end
    task.spawn(function()
        pcall(function()
            local http = request or http_request or (syn and syn.request)
            if not http or not getcustomasset or not writefile then return end
            if isfolder and not isfolder("kyrilib_icons") then makefolder("kyrilib_icons") end
            local f = "kyrilib_icons/" .. url:gsub("[^%w]", "_"):sub(1, 64) .. ".png"
            if not isfile(f) then
                local res = http({Url = url, Method = "GET"})
                if not res or res.StatusCode ~= 200 or not res.Body then return end
                writefile(f, res.Body)
            end
            obj.Image = getcustomasset(f)
        end)
    end)
end

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

local mine = {}

local function island_positions()
    local d
    if isfile then
        pcall(function()
            if isfile(ISLAND_FILE) then d = kyri.svc.http:JSONDecode(readfile(ISLAND_FILE)) end
        end)
    end
    if type(d) ~= "table" then d = {} end
    return d
end

local function save_island_pos(root, id)
    if not writefile then return end
    pcall(function()
        if isfolder and not isfolder("KyriLib") then makefolder("KyriLib") end
        local d = island_positions()
        local p = root.Position
        d[id or "main"] = {
            sx = p.X.Scale, ox = p.X.Offset,
            sy = p.Y.Scale, oy = p.Y.Offset,
            ax = root.AnchorPoint.X, ay = root.AnchorPoint.Y
        }
        writefile(ISLAND_FILE, kyri.svc.http:JSONEncode(d))
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
    local f_med = opts.font or Enum.Font.GothamMedium
    local f_bold = opts.font_bold or Enum.Font.GothamBold
    local f_measure = typeof(f_bold) == "EnumItem" and f_bold or Enum.Font.GothamBold

    local function setfont(obj, f)
        if typeof(f) == "Font" then
            obj.FontFace = f
        elseif typeof(f) == "EnumItem" then
            obj.Font = f
        end
    end
    local show_bars = opts.bars ~= false
    local show_seek = opts.seek ~= false
    local show_vol = opts.volume ~= false
    local draggable = opts.draggable ~= false

    local id = opts.id or "main"

    local stack = 0
    for g in pairs(mine) do
        if g.Parent then stack = stack + 1 end
    end

    if getgenv then
        local g = getgenv()
        g.__kyri_islands = type(g.__kyri_islands) == "table" and g.__kyri_islands or {}
        for i = #g.__kyri_islands, 1, -1 do
            local old = g.__kyri_islands[i]
            if not mine[old] then
                pcall(function() old:Destroy() end)
                table.remove(g.__kyri_islands, i)
            end
        end
    end

    local gui = make("ScreenGui", {
        Name = rnd(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = false,
        DisplayOrder = 999999997,
        Parent = lp.PlayerGui
    })
    gui:SetAttribute("kyri", true)
    mine[gui] = true
    if getgenv then table.insert(getgenv().__kyri_islands, gui) end
    isl.gui = gui

    local base_y = opts.y or (10 + stack * (ch + 8))
    local ipos = opts.position or UDim2.new(0.5, 0, 0, base_y)
    local ianc = opts.position and Vector2.new(0, 0) or Vector2.new(0.5, 0)

    if opts.remember ~= false then
        local d = island_positions()[id]
        if d and d.ox then
            ipos = UDim2.new(d.sx, d.ox, d.sy, d.oy)
            ianc = Vector2.new(d.ax, d.ay)
        end
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

    local glyph = ico(opts.icon)
    local letter = (not glyph) and (opts.letter or (opts.title or "k"):sub(1, 1):upper()) or nil

    local art_ic = make("ImageLabel", {
        Size = UDim2.fromOffset(13, 13),
        Position = UDim2.new(0.5, -7, 0.5, -7),
        BackgroundTransparency = 1,
        Image = glyph or "",
        ImageColor3 = t.subtext,
        Visible = glyph ~= nil and (opts.image or "") == "",
        Parent = art
    })

    local art_tx = make("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = letter or "",
        TextColor3 = t.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Visible = letter ~= nil and (opts.image or "") == "",
        Parent = art
    })

    local show_chev = opts.body_height ~= nil

    local ctitle = make("TextLabel", {
        Size = UDim2.new(1, (show_bars or show_chev) and -74 or -48, 1, 0),
        Position = UDim2.fromOffset(39, 0),
        BackgroundTransparency = 1,
        Text = opts.title or "kyri",
        TextColor3 = t.text,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = cv
    })
    setfont(ctitle, f_med)

    if show_chev then
        make("ImageLabel", {
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.new(1, -26, 0.5, -7),
            BackgroundTransparency = 1,
            Image = ico("chevron-down") or "",
            ImageColor3 = t.subtext,
            ImageTransparency = 0.35,
            Parent = cv
        })
    end

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
        Image = glyph or "",
        ImageColor3 = t.subtext,
        Visible = glyph ~= nil and (opts.image or "") == "",
        Parent = bart
    })

    local bart_tx = make("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = letter or "",
        TextColor3 = t.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Visible = letter ~= nil and (opts.image or "") == "",
        Parent = bart
    })

    local etitle = make("TextLabel", {
        Size = UDim2.new(1, -96, 0, 20),
        Position = UDim2.fromOffset(64, 6),
        BackgroundTransparency = 1,
        Text = opts.title or "kyri",
        TextColor3 = t.text,
        TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = head
    })
    setfont(etitle, f_bold)

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
        Image = ico("chevron-up") or ico("x") or "",
        ImageColor3 = t.subtext,
        Parent = head
    })

    tip(close, "collapse")

    local grab = make("TextButton", {
        Size = UDim2.new(1, -96, 0, 52),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 6,
        Visible = false,
        Parent = head
    })

    local quit
    if opts.on_close then
        quit = make("ImageButton", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.new(1, -48, 0, 6),
            BackgroundTransparency = 1,
            Image = ico("power") or ico("log-out") or "",
            ImageColor3 = t.subtext,
            Parent = head
        })
        tip(quit, "close")
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
        Visible = false,
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
            if c:IsA("GuiObject") and c.Visible then
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

    local function fit(w, h)
        local vp = gui.AbsoluteSize
        if vp.X < 8 or vp.Y < 8 then return nil end
        local p = root.Position
        local ax, ay = root.AnchorPoint.X, root.AnchorPoint.Y
        local x = p.X.Scale * vp.X + p.X.Offset - ax * w
        local y = p.Y.Scale * vp.Y + p.Y.Offset - ay * h
        local nx = math.clamp(x, 8, math.max(vp.X - w - 8, 8))
        local ny = math.clamp(y, 8, math.max(vp.Y - h - 8, 8))
        if math.abs(nx - x) < 1 and math.abs(ny - y) < 1 then return nil end
        return UDim2.new(p.X.Scale, p.X.Offset + (nx - x), p.Y.Scale, p.Y.Offset + (ny - y))
    end

    local function set_expanded(state)
        if isl.expanded == state then return end
        isl.expanded = state
        tap.Visible = not state
        grab.Visible = state
        local ti = TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        if state then
            ev.Visible = true
            local eh = exp_h()
            local goal = {Size = UDim2.fromOffset(ew, eh)}
            local np = fit(ew, eh)
            if np then goal.Position = np end
            kyri.svc.tw:Create(root, ti, goal):Play()
            kyri.svc.tw:Create(rc, TweenInfo.new(0.3), {CornerRadius = UDim.new(0, 22)}):Play()
            fade(cv, 1, 0.12)
            fade(ev, 0, 0.26)
        else
            local goal = {Size = UDim2.fromOffset(cw, ch)}
            local np = fit(cw, ch)
            if np then goal.Position = np end
            kyri.svc.tw:Create(root, ti, goal):Play()
            if opts.remember ~= false then
                task.delay(0.36, function() save_island_pos(root, id) end)
            end
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

    table.insert(conns, gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local np = fit(root.Size.X.Offset, root.Size.Y.Offset)
        if np then root.Position = np end
    end))

    do
        local held, moved, start, origin, pill = false, 0, nil, nil, false

        local function press(i, squish)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            held = true
            moved = 0
            pill = squish
            start = i.Position
            origin = root.Position
            if squish then
                kyri.svc.tw:Create(root, TweenInfo.new(0.12), {Size = UDim2.fromOffset(cw + 6, ch + 2)}):Play()
            end
        end

        tap.InputBegan:Connect(function(i) press(i, true) end)
        grab.InputBegan:Connect(function(i) press(i, false) end)

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
                    if pill then
                        root.Size = UDim2.fromOffset(cw, ch)
                        set_expanded(true)
                    end
                else
                    if pill then
                        kyri.svc.tw:Create(root, TweenInfo.new(0.15), {Size = UDim2.fromOffset(cw, ch)}):Play()
                    end
                    local np = fit(root.Size.X.Offset, root.Size.Y.Offset)
                    if np then kyri.svc.tw:Create(root, TweenInfo.new(0.18), {Position = np}):Play() end
                    if opts.remember ~= false then
                        task.delay(np and 0.2 or 0, function() save_island_pos(root, id) end)
                    end
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

        trow.Visible = true

        b.MouseButton1Click:Connect(function()
            if cb then pcall(cb) end
        end)
        b.MouseEnter:Connect(function()
            kyri.svc.tw:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
        end)
        b.MouseLeave:Connect(function()
            kyri.svc.tw:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
        end)
        if name then
            b.Name = name
            tip(b, name)
        end

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

    function isl:input(ph, cb, kinds)
        local box = make("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = t.element,
            Visible = false,
            LayoutOrder = 6,
            Parent = ev
        })
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

        make("ImageLabel", {
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.fromOffset(10, 8),
            BackgroundTransparency = 1,
            Image = ico("search") or "",
            ImageColor3 = t.subtext,
            Parent = box
        })

        kinds = kinds or {{"track", "songs"}, {"playlist", "lists"}}
        local chip_w = 42
        local strip_w = #kinds * chip_w + (#kinds - 1) * 2 + 10

        local tb = make("TextBox", {
            Size = UDim2.new(1, -(strip_w + 40), 1, 0),
            Position = UDim2.fromOffset(32, 0),
            BackgroundTransparency = 1,
            Text = "",
            PlaceholderText = ph or "search",
            PlaceholderColor3 = t.subtext,
            TextColor3 = t.text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            ClearTextOnFocus = false,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = box
        })

        local mode = kinds[1][1]
        local tabs = {}

        local function paint()
            for k,b in pairs(tabs) do
                local on = k == mode
                kyri.svc.tw:Create(b, TweenInfo.new(0.15), {
                    BackgroundColor3 = on and t.accent or t.container,
                    TextColor3 = on and Color3.new(1, 1, 1) or t.subtext
                }):Play()
            end
        end

        for i,v in pairs(kinds) do
            local b = make("TextButton", {
                Size = UDim2.fromOffset(chip_w, 20),
                Position = UDim2.new(1, -(strip_w - 10) + (i - 1) * (chip_w + 2), 0.5, -10),
                BackgroundColor3 = t.container,
                Text = v[2],
                TextColor3 = t.subtext,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                AutoButtonColor = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = b})
            tabs[v[1]] = b
            b.MouseButton1Click:Connect(function()
                mode = v[1]
                paint()
                if tb.Text ~= "" and cb then cb(tb.Text, mode) end
            end)
        end
        paint()

        tb.FocusLost:Connect(function(enter)
            if enter and cb then cb(tb.Text, mode) end
        end)

        local api = {box = box, input = tb}
        function api:show(v)
            box.Visible = v ~= false
            isl:relayout()
        end
        function api:visible() return box.Visible end
        function api:get() return tb.Text, mode end
        function api:set(v) tb.Text = v or "" end
        function api:focus() pcall(function() tb:CaptureFocus() end) end
        return api
    end

    function isl:list(max)
        max = max or 5
        local holder = make("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            LayoutOrder = 7,
            Parent = ev
        })
        make("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = holder
        })

        local api = {box = holder}

        function api:set(items)
            for i,c in pairs(holder:GetChildren()) do
                if c:IsA("GuiObject") then c:Destroy() end
            end

            local n = 0
            for i,it in pairs(items or {}) do
                if n >= max then break end
                n = n + 1

                local b = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = t.element,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = i,
                    Parent = holder
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = b})

                local x = 10
                if it.icon then
                    local im = make("ImageLabel", {
                        Size = UDim2.fromOffset(18, 18),
                        Position = UDim2.fromOffset(6, 5),
                        BackgroundColor3 = t.container,
                        Image = ico(it.icon) or (type(it.icon) == "string" and it.icon:find("^rbxassetid://") and it.icon) or "",
                        Parent = b
                    })
                    make("UICorner", {CornerRadius = UDim.new(0, 4), Parent = im})
                    remote_icon(im, it.icon)
                    x = 30
                end

                make("TextLabel", {
                    Size = UDim2.new(1, -x - 10, 1, 0),
                    Position = UDim2.fromOffset(x, 0),
                    BackgroundTransparency = 1,
                    Text = it.text or "",
                    TextColor3 = t.text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = b
                })

                b.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = t.hover}):Play()
                end)
                b.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = t.element}):Play()
                end)
                b.MouseButton1Click:Connect(function()
                    if it.cb then pcall(it.cb) end
                end)
            end

            holder.Size = UDim2.new(1, 0, 0, n == 0 and 0 or (n * 28 + (n - 1) * 4))
            holder.Visible = n > 0
            isl:relayout()
        end

        function api:clear() api:set({}) end
        function api:count()
            local n = 0
            for i,c in pairs(holder:GetChildren()) do
                if c:IsA("GuiObject") then n = n + 1 end
            end
            return n
        end
        return api
    end

    function isl:lyrics()
        local box = make("Frame", {
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Visible = false,
            LayoutOrder = 8,
            Parent = ev
        })

        local roll = make("Frame", {
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            Parent = box
        })

        local shift = make("Frame", {
            Size = UDim2.fromOffset(10, 22),
            BackgroundTransparency = 1,
            Parent = roll
        })

        local function mk(col, tr)
            return make("TextLabel", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                TextColor3 = col,
                TextTransparency = tr,
                TextSize = 14,
                TextWrapped = false,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = shift
            })
        end

        local base = mk(t.subtext, 0.5)
        local hl = mk(t.text, 0)

        setfont(base, f_bold)
        setfont(hl, f_bold)

        local grad = make("UIGradient", {Parent = hl})

        local cred = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 13),
            Position = UDim2.fromOffset(0, 24),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            TextColor3 = t.subtext,
            TextTransparency = 0.45,
            TextSize = 10,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = false,
            Parent = box
        })

        setfont(cred, f_med)

        local full_credit = nil
        cred.MouseButton1Click:Connect(function()
            if full_credit and kyri.copybox then kyri.copybox(full_credit, "lyrics credit") end
        end)

        local function wipe(v)
            v = math.clamp(v, 0.0005, 0.9995)
            grad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(v, 0),
                NumberSequenceKeypoint.new(math.min(v + 0.0004, 1), 1),
                NumberSequenceKeypoint.new(1, 1)
            })
        end

        wipe(0)

        local inf = Vector2.new(9999, 100)
        local function width(str, sz)
            if str == "" then return 0 end
            local ok, v = pcall(function()
                return kyri.svc.ts:GetTextSize(str, sz, f_measure, inf).X
            end)
            return ok and v or 0
        end

        local key = nil
        local span = {}
        local total = 0
        local room = 0
        local at = 0
        local held, held_syl = "", nil

        local function layout(text, syl)
            held, held_syl = text, syl
            room = box.AbsoluteSize.X
            if room <= 4 then room = ew - 28 end

            local sz = 14
            local wide = width(text, sz)
            while wide > room and sz > 11 do
                sz = sz - 1
                wide = width(text, sz)
            end

            base.TextSize = sz
            hl.TextSize = sz

            total = math.max(wide, room)
            shift.Size = UDim2.fromOffset(total, 22)
            shift.Position = UDim2.fromOffset(0, 0)
            at = 0

            span = {}
            if syl then
                for n,w in pairs(syl) do
                    span[n] = {a = width(text:sub(1, w.at), sz), b = width(text:sub(1, w.to), sz)}
                end
            end
        end

        local function sweep(syl, now)
            if total <= 0 or not syl then return 0 end

            local k = 0
            for n,w in pairs(syl) do
                if w.t and w.t <= now then k = n else break end
            end
            if k == 0 then return 0 end

            local m = span[k]
            if not m then return 0 end

            local w = syl[k]
            local dur = math.max((w.e or w.t) - w.t, 0.06)
            local f = math.clamp((now - w.t) / dur, 0, 1)
            return (m.a + (m.b - m.a) * f) / total
        end

        local function recheck()
            local now = box.AbsoluteSize.X
            if now > 4 and math.abs(now - room) > 2 and held ~= "" then
                layout(held, held_syl)
            end
        end

        local function follow(pct)
            local want = 0
            if total > room then
                want = math.clamp(room * 0.4 - pct * total, -(total - room), 0)
            end
            at = at + (want - at) * 0.25
            shift.Position = UDim2.fromOffset(math.floor(at + 0.5), 0)
        end

        local api = {box = box}

        local function swap(text)
            base.Text = text
            hl.Text = text
            roll.Position = UDim2.fromOffset(0, 15)
            base.TextTransparency = 1
            hl.TextTransparency = 1
            kyri.svc.tw:Create(roll, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.fromOffset(0, 0)
            }):Play()
            kyri.svc.tw:Create(base, TweenInfo.new(0.26), {TextTransparency = 0.5}):Play()
            kyri.svc.tw:Create(hl, TweenInfo.new(0.26), {TextTransparency = 0}):Play()
        end

        function api:line(text, syl, now, id)
            text = text or ""
            if id ~= key then
                key = id
                layout(text, syl)
                wipe(0)
                swap(text)
            end
            recheck()
            local pct = sweep(syl, now)
            wipe(pct)
            follow(pct)
        end

        function api:set(text, pct, id)
            text = text or ""
            if id ~= key then
                key = id
                layout(text, nil)
                wipe(0)
                swap(text)
            end
            recheck()
            pct = math.clamp(pct or 0, 0, 1)
            wipe(pct)
            follow(pct)
        end

        function api:credit(short, long)
            full_credit = long
            cred.Text = short or ""
            cred.Visible = (short or "") ~= ""
            cred.Active = long ~= nil
        end

        function api:clear()
            key = nil
            span = {}
            total = 0
            at = 0
            held, held_syl = "", nil
            base.Text = ""
            hl.Text = ""
            shift.Position = UDim2.fromOffset(0, 0)
            wipe(0)
        end

        function api:show(v)
            local want = v and true or false
            if box.Visible == want then return end
            box.Visible = want
            isl:relayout()
        end

        function api:visible() return box.Visible end
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
            art_ic.Visible = d.image == "" and glyph ~= nil
            bart_ic.Visible = d.image == "" and glyph ~= nil
            art_tx.Visible = d.image == "" and letter ~= nil
            bart_tx.Visible = d.image == "" and letter ~= nil
        end
        if d.icon then
            local id = ico(d.icon)
            if id then
                glyph = id
                art_ic.Image = id
                bart_ic.Image = id
                art_ic.Visible = art.Image == ""
                bart_ic.Visible = bart.Image == ""
                art_tx.Visible = false
                bart_tx.Visible = false
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

    function isl:theme(over)
        if type(over) == "string" then over = kyri.presets[over] end
        if type(over) ~= "table" then return false end

        for k,new in pairs(over) do
            local was = t[k]
            t[k] = new
            if was and typeof(new) == "Color3" then
                for i,o in pairs(root:GetDescendants()) do
                    pcall(function()
                        if o:IsA("GuiObject") and o.BackgroundColor3 == was then
                            o.BackgroundColor3 = new
                        end
                        if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
                            if o.TextColor3 == was then o.TextColor3 = new end
                        end
                        if o:IsA("UIStroke") and o.Color == was then o.Color = new end
                        if o:IsA("ImageLabel") or o:IsA("ImageButton") then
                            if o.ImageColor3 == was then o.ImageColor3 = new end
                        end
                        if o:IsA("Frame") and o.BackgroundColor3 == was then
                            o.BackgroundColor3 = new
                        end
                    end)
                end
                pcall(function()
                    if root.BackgroundColor3 == was then root.BackgroundColor3 = new end
                end)
            end
        end
        return true
    end

    function isl:resetpos()
        if writefile then
            pcall(function()
                local d = island_positions()
                d[id] = nil
                writefile(ISLAND_FILE, kyri.svc.http:JSONEncode(d))
            end)
        end
        root.AnchorPoint = opts.position and Vector2.new(0, 0) or Vector2.new(0.5, 0)
        root.Position = opts.position or UDim2.new(0.5, 0, 0, base_y)
    end
    function isl:onseek(fn) isl.on_seek = fn end
    function isl:onvolume(fn) isl.on_volume = fn end

    function isl:destroy()
        for i,c in pairs(conns) do
            pcall(function() c:Disconnect() end)
        end
        mine[gui] = nil
        if getgenv and type(getgenv().__kyri_islands) == "table" then
            local l = getgenv().__kyri_islands
            for i = #l, 1, -1 do
                if l[i] == gui then table.remove(l, i) end
            end
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
    sp.vol_known = false
    sp.can_volume = true
    local idle_for = 0
    sp.shuffle = false
    sp.loop = "off"
    sp.track = nil
    sp.results = {}
    sp.lyric_offset = 0
    sp.device_id = nil
    sp.autoplay = true
    sp.lyric_rev = 0
    sp.agent = "KyriLib/1.0 (+https://github.com/Justanewplayer19/KyriLib)"
    if opts.contact then sp.agent = sp.agent:sub(1, -2) .. "; " .. opts.contact .. ")" end

    local CID = opts.client_id or "035b9c837a6f46ffaffce6ada163a6ad"
    local REDIR = opts.redirect or "http://127.0.0.1:8888/callback"
    local SCOPES = opts.scopes or table.concat({
        "user-read-playback-state",
        "user-modify-playback-state",
        "user-read-currently-playing",
        "user-read-recently-played",
        "user-library-modify",
        "user-library-read",
        "user-follow-read",
        "user-top-read",
        "playlist-read-private",
        "playlist-read-collaborative"
    }, " ")
    local DIR = "KyriLib/spotify"
    local TOK = DIR .. "/tokens.json"
    local PK = DIR .. "/pkce.txt"
    local ART = DIR .. "/art"

    local token, refresh, alive = "", "", true
    local grant = nil

    local function missing(s)
        local have = {}
        for w in tostring(s or ""):gmatch("[^ ]+") do have[w] = true end
        for w in SCOPES:gmatch("[^ ]+") do
            if not have[w] then return true end
        end
        return false
    end
    local cur_id, seeking, last_seek = "", false, 0

    local function dirs()
        if not isfolder("KyriLib") then makefolder("KyriLib") end
        if not isfolder(DIR) then makefolder(DIR) end
        if not isfolder(ART) then makefolder(ART) end
    end

    local function save_tokens(a, r, gr)
        dirs()
        if a then token = a end
        if r then refresh = r end
        if gr and gr ~= "" then grant = gr end
        writefile(TOK, hs:JSONEncode({access_token = token, refresh_token = refresh, scope = grant}))
        sp.stale_scopes = grant ~= nil and missing(grant)
    end

    local function load_tokens()
        if not isfile(TOK) then return false end
        local ok, d = pcall(function() return hs:JSONDecode(readfile(TOK)) end)
        if not ok or type(d) ~= "table" then return false end
        token = d.access_token or ""
        refresh = d.refresh_token or ""
        grant = d.scope
        if grant == "stale" or grant == "" then grant = nil end
        sp.stale_scopes = grant ~= nil and missing(grant)
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
            save_tokens(d.access_token, d.refresh_token, d.scope)
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
            save_tokens(d.access_token, d.refresh_token, d.scope)
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
        if res and (ep:find("^/me/top") or ep:find("^/me/following")) then
            if res.StatusCode == 403 then
                sp.stale_scopes = true
            elseif res.StatusCode == 200 then
                sp.stale_scopes = false
            end
        end
        return res
    end

    local function good(r)
        return r and (r.StatusCode == 200 or r.StatusCode == 202 or r.StatusCode == 204)
    end

    local function why(r)
        if not r then return "no response from spotify, check your connection" end
        local c = r.StatusCode
        if c == 401 then return "session expired, reconnect on the auth tab" end
        if c == 403 then return "spotify premium is required for playback control" end
        if c == 404 then return "no active device, play something on spotify first" end
        if c == 429 then return "rate limited by spotify, give it a moment" end
        if c == 500 or c == 502 or c == 503 then return "spotify is having a moment, try again" end
        return "spotify returned " .. tostring(c)
    end

    local last_msg, last_at = "", 0

    local function report(r, what)
        if good(r) then return true end
        local msg = why(r)
        sp.last_error = msg
        if msg ~= last_msg or os.clock() - last_at > 5 then
            last_msg, last_at = msg, os.clock()
            if sp.window then
                pcall(function() sp.window:notify(what or "spotify", msg, 4, "alert-triangle") end)
            elseif isl then
                pcall(function() isl:notify(msg, 3) end)
            end
        end
        return false
    end

    sp.request = api

    function sp:authed() return sp.ready end

    function sp:play()
        local r = api("PUT", "/me/player/play")
        if good(r) then sp.playing = true end
        return report(r, "play")
    end

    function sp:pause()
        local r = api("PUT", "/me/player/pause")
        if good(r) then sp.playing = false end
        return report(r, "pause")
    end

    function sp:toggle()
        if sp.playing then return sp:pause() end
        return sp:play()
    end

    function sp:next()
        local r = api("POST", "/me/player/next")
        cur_id = ""
        task.delay(0.4, function() sp:sync() end)
        return report(r, "next")
    end

    function sp:prev()
        local r = api("POST", "/me/player/previous")
        cur_id = ""
        task.delay(0.4, function() sp:sync() end)
        return report(r, "prev")
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
        if sp.can_volume == false then
            sp.last_error = (sp.device_name or "this device") .. " does not take volume from spotify"
            return false
        end
        v = math.clamp(math.floor(v), 0, 100)
        local r = api("PUT", "/me/player/volume?volume_percent=" .. v)
        if good(r) then sp.vol = v end
        return good(r)
    end

    function sp:setshuffle(state)
        local r = api("PUT", "/me/player/shuffle?state=" .. (state and "true" or "false"))
        if good(r) then sp.shuffle = state end
        return report(r, "shuffle")
    end

    function sp:setloop(mode)
        if mode == nil then
            mode = sp.loop == "off" and "context" or (sp.loop == "context" and "track" or "off")
        end
        local r = api("PUT", "/me/player/repeat?state=" .. mode)
        if good(r) then sp.loop = mode end
        return report(r, "repeat"), sp.loop
    end

    function sp:like()
        if not sp.track or not sp.track.id then return false end
        return report(api("PUT", "/me/tracks?ids=" .. sp.track.id), "like")
    end

    function sp:search(q, limit, kind)
        if not q or q == "" then return {} end
        kind = kind or "track"
        local r = api("GET", "/search?q=" .. hs:UrlEncode(q) .. "&type=" .. kind .. "&limit=" .. (limit or 8))
        if not r or r.StatusCode ~= 200 then return {} end
        local ok, d = pcall(function() return hs:JSONDecode(r.Body) end)
        if not ok or not d then return {} end
        sp.results = (d.tracks and d.tracks.items) or {}
        sp.playlist_results = (d.playlists and d.playlists.items) or {}
        sp.album_results = (d.albums and d.albums.items) or {}
        if kind == "playlist" then return sp.playlist_results end
        if kind == "album" then return sp.album_results end
        return sp.results
    end

    function sp:playlists(limit)
        local r = api("GET", "/me/playlists?limit=" .. (limit or 20))
        if not r or r.StatusCode ~= 200 then return {} end
        local ok, d = pcall(function() return hs:JSONDecode(r.Body) end)
        if not ok or not d then return {} end
        sp.my_playlists = d.items or {}
        return sp.my_playlists
    end

    local function target()
        if not sp.device_id then
            local list = sp:devices()
            for i,d in pairs(list) do
                if d.is_active then sp.device_id = d.id break end
            end
            if not sp.device_id and list[1] then sp.device_id = list[1].id end
        end
        return sp.device_id and ("?device_id=" .. sp.device_id) or ""
    end

    local function start(body)
        local r = api("PUT", "/me/player/play" .. target(), body)
        if r and (r.StatusCode == 404 or r.StatusCode == 403) then
            sp.device_id = nil
            local t = target()
            if t ~= "" then r = api("PUT", "/me/player/play" .. t, body) end
        end
        cur_id = ""
        task.delay(0.4, function() sp:sync() end)
        return r
    end

    function sp:playcontext(uri)
        if not uri then return false end
        return report(start({context_uri = uri}), "play")
    end

    function sp:playuri(uri, context)
        if not uri then return false end
        if context and sp.autoplay ~= false then
            return report(start({context_uri = context, offset = {uri = uri}}), "play")
        end
        return report(start({uris = {uri}}), "play")
    end

    function sp:features()
        if not sp.track or not sp.track.id then return nil end
        local r = api("GET", "/audio-features/" .. sp.track.id)
        if not r or r.StatusCode ~= 200 then
            sp.bpm = nil
            return nil
        end
        local ok, d = pcall(function() return hs:JSONDecode(r.Body) end)
        if not ok or type(d) ~= "table" then return nil end
        sp.bpm = d.tempo and math.floor(d.tempo + 0.5) or nil
        return d
    end

    function sp:queue(uri)
        return report(api("POST", "/me/player/queue?uri=" .. hs:UrlEncode(uri)), "queue")
    end

    function sp:transfer(id, play)
        if not id then return false end
        sp.device_id = id
        local r = api("PUT", "/me/player", {device_ids = {id}, play = play ~= false})
        cur_id = ""
        task.delay(0.6, function() sp:sync() end)
        return report(r, "device")
    end

    function sp:devices()
        local r = api("GET", "/me/player/devices")
        if not r or r.StatusCode ~= 200 then return {} end
        return hs:JSONDecode(r.Body).devices or {}
    end

    local function parse_lrc(text)
        local out = {}
        for line in tostring(text):gmatch("[^\r\n]+") do
            local mm, ss, rest = line:match("^%[(%d+):([%d%.]+)%](.*)$")
            if mm and ss then
                local body = rest:gsub("^%s+", ""):gsub("%s+$", "")
                out[#out + 1] = {t = tonumber(mm) * 60 + tonumber(ss), text = body}
            end
        end
        table.sort(out, function(a, b) return a.t < b.t end)
        return out
    end

    local function tsec(v)
        if not v then return nil end
        local h, m, sec = v:match("^(%d+):(%d+):([%d%.]+)$")
        if h then return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(sec) end
        local m2, s2 = v:match("^(%d+):([%d%.]+)$")
        if m2 then return tonumber(m2) * 60 + tonumber(s2) end
        return tonumber(v)
    end

    local function strip(x)
        return (x:gsub("<[^>]*>", ""):gsub("&amp;", "&"):gsub("&lt;", "<"):gsub("&gt;", ">")
            :gsub("&quot;", '"'):gsub("&#39;", "'"):gsub("&apos;", "'"))
    end

    local function parse_ttml(xml)
        local out = {}
        for attrs, inner in xml:gmatch("<p([^>]*)>(.-)</p>") do
            local b = tsec(attrs:match('begin="([^"]+)"'))
            local e = tsec(attrs:match('end="([^"]+)"'))
            if b then
                local text, words, pos = "", {}, 1
                while true do
                    local s1, e1, sattr, stext = inner:find("<span([^>]*)>(.-)</span>", pos)
                    if not s1 then break end
                    if not sattr:find("x%-bg") then
                        text = text .. strip(inner:sub(pos, s1 - 1))
                        local w = {
                            t = tsec(sattr:match('begin="([^"]+)"')),
                            e = tsec(sattr:match('end="([^"]+)"')),
                            at = #text
                        }
                        text = text .. strip(stext)
                        w.to = #text
                        if w.t then words[#words + 1] = w end
                    end
                    pos = e1 + 1
                end
                text = text .. strip(inner:sub(pos))
                text = text:gsub("^%s+", ""):gsub("%s+$", "")
                if text ~= "" then
                    out[#out + 1] = {t = b, e = e, text = text, words = #words > 0 and words or nil}
                end
            end
        end
        table.sort(out, function(a, b) return a.t < b.t end)
        return out
    end

    local lyric_cache = {}

    local lyr_soft = false

    local function soft_check(ok, res)
        if not ok or not res then
            lyr_soft = true
            return
        end
        local c = res.StatusCode
        if c == 429 or c >= 500 then lyr_soft = true end
    end

    local function spicy_key()
        if opts.spicy_key then return opts.spicy_key end
        local g = getgenv and getgenv()
        return g and (g.KYRI_SPICY_KEY or g.SPICY_LYRICS_KEY) or nil
    end

    local function spicy_credit(b)
        if b.source ~= "spicy_lyrics" then
            if b.source == "apple_music" then return "lyrics from Apple Music", nil end
            if b.source == "spotify" then return "lyrics from Spotify", nil end
            return "lyrics from Spicy Lyrics", nil
        end

        local a = b.UploadAttribution
        local up = a and a.Uploader
        local mk = a and a.Maker
        local line = "lyrics from Spicy Lyrics"
        local long = {"Lyrics from Spicy Lyrics", "https://spicylyrics.org"}

        if up and up.username then
            line = line .. "  -  uploaded by " .. up.username
            long[#long + 1] = "uploaded by " .. up.username .. "   " .. (up.url or "")
        end
        if mk and mk.username then
            line = line .. ", made by " .. mk.username
            long[#long + 1] = "made by " .. mk.username .. "   " .. (mk.url or "")
        end

        return line, table.concat(long, "\n")
    end

    local function spicy_lines(b)
        local out = {}

        if b.Type == "Syllable" and type(b.Content) == "table" then
            for i,ln in pairs(b.Content) do
                local lead = ln.Lead
                if type(lead) == "table" and type(lead.Syllables) == "table" then
                    local text, syl = "", {}
                    local n = #lead.Syllables
                    for j,sy in pairs(lead.Syllables) do
                        local w = {t = sy.StartTime, e = sy.EndTime, at = #text}
                        text = text .. (sy.Text or "")
                        w.to = #text
                        if w.t then syl[#syl + 1] = w end
                        if not sy.IsPartOfWord and j < n then text = text .. " " end
                    end
                    text = text:gsub("^%s+", ""):gsub("%s+$", "")
                    if text ~= "" then
                        out[#out + 1] = {
                            t = lead.StartTime or ln.StartTime or 0,
                            e = lead.EndTime or ln.EndTime,
                            text = text,
                            words = #syl > 0 and syl or nil
                        }
                    end
                end
            end

        elseif b.Type == "Line" and type(b.Content) == "table" then
            for i,ln in pairs(b.Content) do
                if type(ln.Text) == "string" and ln.Text ~= "" then
                    out[#out + 1] = {t = ln.StartTime or 0, e = ln.EndTime, text = ln.Text}
                end
            end
        end

        table.sort(out, function(x, y) return x.t < y.t end)
        return out
    end

    local function from_spicy()
        local key = spicy_key()
        if not key or not sp.track or not sp.track.id then return nil end

        local ok, res = pcall(req, {
            Url = "https://api.spicylyrics.org/v1/lyrics/" .. sp.track.id,
            Method = "GET",
            Headers = {
                ["Authorization"] = "Bearer " .. key,
                ["User-Agent"] = sp.agent
            }
        })
        soft_check(ok, res)
        if not ok or not res then return nil end

        if res.StatusCode == 401 or res.StatusCode == 403 then
            sp.last_error = "spicy lyrics key rejected"
            return nil
        end
        if res.StatusCode ~= 200 or not res.Body then return nil end

        local okd, d = pcall(function() return hs:JSONDecode(res.Body) end)
        if not okd or type(d) ~= "table" or type(d.Body) ~= "table" then return nil end

        local b = d.Body

        if b.Type == "Static" then
            local bits = {}
            for i,ln in pairs(type(b.Lines) == "table" and b.Lines or {}) do
                if type(ln.Text) == "string" then bits[#bits + 1] = ln.Text end
            end
            if #bits == 0 then return nil end
            local credit, full = spicy_credit(b)
            return {plain = table.concat(bits, "\n"), provider = "spicy", credit = credit, credit_full = full}
        end

        local lines = spicy_lines(b)
        if #lines == 0 then return nil end

        local credit, full = spicy_credit(b)
        return {
            synced = lines,
            provider = "spicy",
            source = b.source,
            credit = credit,
            credit_full = full,
            page = "https://spicylyrics.org",
            words = b.Type == "Syllable",
            writers = b.SongWriters
        }
    end

    local function red_get(url)
        local ok, res = pcall(req, {
            Url = url,
            Method = "GET",
            Headers = {["User-Agent"] = sp.agent}
        })
        soft_check(ok, res)
        if not ok or not res or res.StatusCode ~= 200 or not res.Body then return nil end
        return res.Body
    end

    local function from_red()
        local q = sp.track.name .. " " .. sp:artists()
        local body = red_get("https://lrc.red/search.json?q=" .. hs:UrlEncode(q))
        if not body then return nil end

        local ok, d = pcall(function() return hs:JSONDecode(body) end)
        if not ok or type(d) ~= "table" or type(d.hits) ~= "table" then return nil end

        local best, gap = nil, math.huge
        for i,h in pairs(d.hits) do
            local off = math.abs((tonumber(h.duration) or 0) - (sp.dur or 0))
            if off < gap then best, gap = h, off end
        end
        if not best or gap > 7 then return nil end

        local meta = red_get("https://lrc.red/s/" .. best.isrc .. ".json")
        if not meta then return nil end
        local okm, m = pcall(function() return hs:JSONDecode(meta) end)
        if not okm or type(m) ~= "table" then return nil end
        if m.sync ~= "word" and m.sync ~= "line" then return nil end

        local xml = red_get("https://lrc.red/s/" .. best.isrc .. ".ttml")
        if not xml then return nil end

        local lines = parse_ttml(xml)
        if #lines == 0 then return nil end

        return {
            synced = lines,
            provider = "lrc.red",
            page = m.page or ("https://lrc.red/s/" .. best.isrc),
            credit = "lyrics by lrc.red",
            words = m.sync == "word",
            duration = tonumber(m.duration),
            drift = math.abs((tonumber(m.duration) or 0) - (sp.dur or 0))
        }
    end

    function sp:lyrics()
        if not sp.track or not sp.track.name then return nil end
        local id = (sp.track.id or sp.track.name) .. "|" .. tostring(sp.lyric_source)

        if sp.lyric_pick then
            local d = sp.lyric_pick
            local out = {plain = d.plainLyrics, synced = nil, duration = tonumber(d.duration)}
            if type(d.syncedLyrics) == "string" then
                local lines = parse_lrc(d.syncedLyrics)
                if #lines > 0 then out.synced = lines end
            end
            lyric_cache[id] = out
            sp.lyric_pick = nil
            return out
        end

        if lyric_cache[id] ~= nil then return lyric_cache[id] or nil end
        if not req then return nil end

        lyr_soft = false
        sp.lyric_error = nil
        local spare = nil

        if sp.lyric_source ~= "lrclib" and sp.lyric_source ~= "lrc.red" then
            local hot = from_spicy()
            if hot and hot.synced then
                lyric_cache[id] = hot
                return hot
            end
            spare = spare or hot
        end

        if sp.lyric_source ~= "lrclib" then
            local red = from_red()
            if red and red.synced then
                lyric_cache[id] = red
                return red
            end
            spare = spare or red
        end

        local alb = (sp.track.album and sp.track.album.name) or ""
        local url = "https://lrclib.net/api/get"
            .. "?artist_name=" .. hs:UrlEncode(sp:artists())
            .. "&track_name=" .. hs:UrlEncode(sp.track.name)
            .. "&album_name=" .. hs:UrlEncode(alb)
            .. "&duration=" .. tostring(math.floor(sp.dur or 0))

        local function grab(u)
            local ok, res = pcall(req, {Url = u, Method = "GET"})
            soft_check(ok, res)
            if not ok or not res or res.StatusCode ~= 200 or not res.Body then return nil end
            local okd, d = pcall(function() return hs:JSONDecode(res.Body) end)
            if not okd then return nil end
            return d
        end

        local d = grab(url)

        if not d or type(d.syncedLyrics) ~= "string" or d.syncedLyrics == "" then
            local hits = grab("https://lrclib.net/api/search"
                .. "?track_name=" .. hs:UrlEncode(sp.track.name)
                .. "&artist_name=" .. hs:UrlEncode(sp:artists()))

            if type(hits) == "table" then
                local best, gap = nil, math.huge
                for i,h in pairs(hits) do
                    if type(h) == "table" and type(h.syncedLyrics) == "string" and h.syncedLyrics ~= "" then
                        local off = math.abs((tonumber(h.duration) or 0) - (sp.dur or 0))
                        if off < gap then best, gap = h, off end
                    end
                end
                if best and gap <= 6 then d = best end
            end
        end

        if type(d) ~= "table" then
            if spare then
                lyric_cache[id] = spare
            elseif lyr_soft then
                sp.lyric_error = "network"
            else
                lyric_cache[id] = false
            end
            return spare
        end

        local out = {
            plain = d.plainLyrics,
            synced = nil,
            instrumental = d.instrumental and true or false,
            provider = "lrclib",
            credit = "lyrics by lrclib.net",
            duration = tonumber(d.duration),
            drift = d.duration and math.abs((tonumber(d.duration) or 0) - (sp.dur or 0)) or nil
        }
        if type(d.syncedLyrics) == "string" and d.syncedLyrics ~= "" then
            local lines = parse_lrc(d.syncedLyrics)
            if #lines > 0 then out.synced = lines end
        end

        if not out.synced and spare then
            lyric_cache[id] = spare
            return spare
        end

        lyric_cache[id] = out
        return out
    end

    function sp:lyricsalts()
        if not sp.track or not sp.track.name or not req then return {} end
        local ok, res = pcall(req, {
            Url = "https://lrclib.net/api/search"
                .. "?track_name=" .. hs:UrlEncode(sp.track.name)
                .. "&artist_name=" .. hs:UrlEncode(sp:artists()),
            Method = "GET"
        })
        if not ok or not res or res.StatusCode ~= 200 then return {} end
        local okd, d = pcall(function() return hs:JSONDecode(res.Body) end)
        if not okd or type(d) ~= "table" then return {} end

        local out = {}
        for i,h in pairs(d) do
            if type(h) == "table" and type(h.syncedLyrics) == "string" and h.syncedLyrics ~= "" then
                out[#out + 1] = {
                    name = (h.trackName or "?") .. "  -  " .. (h.artistName or "?"),
                    duration = tonumber(h.duration),
                    drift = math.abs((tonumber(h.duration) or 0) - (sp.dur or 0)),
                    raw = h
                }
            end
        end
        table.sort(out, function(a, b) return a.drift < b.drift end)
        sp.lyric_alts = out
        return out
    end

    function sp:uselyrics(n)
        local pick = sp.lyric_alts and sp.lyric_alts[n]
        if not pick then return false end
        sp.lyric_pick = pick.raw
        sp.lyric_rev = (sp.lyric_rev or 0) + 1
        sp.lyric_offset = 0
        return true
    end

    function sp:nudge(by)
        sp.lyric_offset = math.clamp((sp.lyric_offset or 0) + (by or 0), -15, 15)
        return sp.lyric_offset
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

    local hooks = {}

    local function push(d)
        if isl then isl:set(d) end
        if ui then ui(d) end
        for i,h in pairs(hooks) do pcall(h, d) end
    end

    function sp:sync()
        local function grab(ep)
            local r = api("GET", ep)
            if not r or r.StatusCode ~= 200 or not r.Body or #r.Body < 2 then return nil end
            local ok, d = pcall(function() return hs:JSONDecode(r.Body) end)
            if not ok or type(d) ~= "table" then return nil end
            return d
        end

        local d = grab("/me/player")
        if not d or not d.item then
            local alt = grab("/me/player/currently-playing")
            if alt and alt.item then
                if d and d.device then alt.device = alt.device or d.device end
                d = alt
            end
        end

        if not d or not d.item then
            sp.playing = false
            idle_for = idle_for + 1
            if idle_for >= 3 then
                sp.track = nil
                cur_id = ""
                push({title = "nothing playing", subtitle = "", playing = false, progress = 0})
            else
                push({playing = false})
            end
            return
        end

        idle_for = 0

        sp.playing = d.is_playing and true or false
        sp.pos = math.floor((d.progress_ms or 0) / 1000)
        sp.dur = math.floor((d.item.duration_ms or 0) / 1000)
        if d.device then
            if d.device.id then sp.device_id = d.device.id end
            if d.device.volume_percent then
                sp.vol = d.device.volume_percent
                sp.vol_known = true
            end
            sp.device_name = d.device.name
            sp.device_type = d.device.type
            sp.can_volume = d.device.supports_volume ~= false
        end
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

        sp.at_pos, sp.at_clock = sp.pos, os.clock()

        push({
            playing = sp.playing,
            volume = sp.vol_known and sp.vol or nil,
            progress = sp.dur > 0 and (sp.pos / sp.dur) or 0,
            left = fmt_time(sp.pos),
            right = fmt_time(sp.dur)
        })
    end

    function sp:now()
        local base = sp.at_pos or sp.pos or 0
        local run = sp.playing and (os.clock() - (sp.at_clock or os.clock())) or 0
        return base + run - (sp.lyric_offset or 0)
    end

    local SPOT_PNG = "https://raw.githubusercontent.com/Justanewplayer19/KyriLib/main/spotify.png"
    local spot_img

    local function spot_logo()
        if spot_img ~= nil then return spot_img end
        spot_img = false
        pcall(function()
            if not (writefile and getcustomasset) then return end
            dirs()
            local f = CONFIG_FOLDER .. "/spotify.png"
            local have = isfile and isfile(f) and readfile and #readfile(f) > 500
            if not have then
                local res = req({Url = SPOT_PNG, Method = "GET"})
                if not res or res.StatusCode ~= 200 or #res.Body < 500 then return end
                writefile(f, res.Body)
            end
            spot_img = getcustomasset(f)
        end)
        return spot_img
    end

    sp.logo = spot_logo

    local RECENT_FILE = CONFIG_FOLDER .. "/spotify_recents.json"

    local function recents_load()
        local d
        pcall(function()
            if isfile and isfile(RECENT_FILE) then d = hs:JSONDecode(readfile(RECENT_FILE)) end
        end)
        return type(d) == "table" and d or {}
    end

    local function recents_add(it)
        if not writefile or not it.uri then return end
        pcall(function()
            dirs()
            local d = recents_load()
            for i = #d, 1, -1 do
                if d[i].uri == it.uri then table.remove(d, i) end
            end
            table.insert(d, 1, it)
            while #d > 8 do table.remove(d) end
            writefile(RECENT_FILE, hs:JSONEncode(d))
        end)
    end

    local dk

    function sp:desktop(dopts)
        if dk then return dk end
        dopts = dopts or {}

        local lp = kyri.svc.plr.LocalPlayer
        local tw = kyri.svc.tw

        local c = {
            bg = Color3.fromRGB(0, 0, 0),
            panel = Color3.fromRGB(18, 18, 18),
            raise = Color3.fromRGB(26, 26, 26),
            hover = Color3.fromRGB(44, 44, 44),
            green = Color3.fromRGB(30, 215, 96),
            text = Color3.fromRGB(255, 255, 255),
            sub = Color3.fromRGB(179, 179, 179),
            line = Color3.fromRGB(40, 40, 40)
        }
        if dopts.colors then
            for k,v in pairs(dopts.colors) do c[k] = v end
        end

        local fb = Enum.Font.GothamBold
        local fm = Enum.Font.GothamMedium
        local fr = Enum.Font.Gotham

        local gui = make("ScreenGui", {
            Name = rnd(),
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 999999998,
            Enabled = false,
            Parent = gethui and gethui() or lp:WaitForChild("PlayerGui")
        })
        gui:SetAttribute("kyri", true)

        local shade = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.45,
            Text = "",
            AutoButtonColor = false,
            Parent = gui
        })

        local win = make("Frame", {
            Size = UDim2.fromScale(0.86, 0.88),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = c.bg,
            Active = true,
            ClipsDescendants = true,
            Parent = gui
        })
        make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = win})
        make("UIStroke", {Color = c.line, Thickness = 1, Transparency = 0.4, Parent = win})

        local function round(o, r)
            make("UICorner", {CornerRadius = UDim.new(0, r or 6), Parent = o})
            return o
        end

        local function lbl(p, props)
            props = props or {}
            props.BackgroundTransparency = 1
            props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
            props.TextColor3 = props.TextColor3 or c.text
            props.Font = props.Font or fr
            props.TextSize = props.TextSize or 13
            props.Parent = p
            return make("TextLabel", props)
        end

        local function hoverable(o, from, to)
            o.MouseEnter:Connect(function()
                tw:Create(o, TweenInfo.new(0.12), {BackgroundColor3 = to}):Play()
            end)
            o.MouseLeave:Connect(function()
                tw:Create(o, TweenInfo.new(0.12), {BackgroundColor3 = from}):Play()
            end)
            return o
        end

        local function iconbtn(p, name, size, tint)
            local b = make("ImageButton", {
                Size = UDim2.fromOffset(size, size),
                BackgroundTransparency = 1,
                Image = ico(name) or "",
                ImageColor3 = tint or c.sub,
                AutoButtonColor = false,
                Parent = p
            })
            b.MouseEnter:Connect(function()
                tw:Create(b, TweenInfo.new(0.12), {ImageColor3 = c.text}):Play()
            end)
            b.MouseLeave:Connect(function()
                tw:Create(b, TweenInfo.new(0.12), {ImageColor3 = tint or c.sub}):Play()
            end)
            return b
        end

        local function scroller(p, props)
            props = props or {}
            props.BackgroundTransparency = 1
            props.ScrollBarThickness = 4
            props.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90)
            props.CanvasSize = UDim2.new()
            props.AutomaticCanvasSize = Enum.AutomaticSize.Y
            props.ScrollingDirection = Enum.ScrollingDirection.Y
            props.Parent = p
            local s = make("ScrollingFrame", props)
            make("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = s
            })
            return s
        end

        local function art_of(obj)
            if not obj then return nil end
            local im = obj.images or (obj.album and obj.album.images)
            if im and im[1] then return im[1].url end
            return nil
        end

        local function paint(img, obj, id)
            local u = art_of(obj)
            if not u or not id then return end
            load_art(u, id, function(a)
                if img and img.Parent then img.Image = a end
            end)
        end

        local function wipe(f)
            for i,v in pairs(f:GetChildren()) do
                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
            end
        end

        local top = make("Frame", {
            Size = UDim2.new(1, 0, 0, 56),
            BackgroundColor3 = c.bg,
            Active = true,
            Parent = win
        })

        local logo = make("ImageLabel", {
            Size = UDim2.fromOffset(28, 28),
            Position = UDim2.fromOffset(14, 14),
            BackgroundTransparency = 1,
            Image = "",
            Parent = top
        })
        task.spawn(function()
            local a = spot_logo()
            logo.Image = a or ico("music") or ""
        end)

        local homeb = make("ImageButton", {
            Size = UDim2.fromOffset(36, 36),
            Position = UDim2.fromOffset(54, 10),
            BackgroundColor3 = c.raise,
            Image = "",
            AutoButtonColor = false,
            Parent = top
        })
        round(homeb, 18)
        hoverable(homeb, c.raise, c.hover)
        make("ImageLabel", {
            Size = UDim2.fromOffset(17, 17),
            Position = UDim2.new(0.5, -8, 0.5, -8),
            BackgroundTransparency = 1,
            Image = ico("home") or "",
            ImageColor3 = c.text,
            Parent = homeb
        })

        local sbox = make("Frame", {
            Size = UDim2.fromOffset(380, 38),
            Position = UDim2.new(0.5, -190, 0, 9),
            BackgroundColor3 = c.raise,
            Parent = top
        })
        round(sbox, 19)
        make("ImageLabel", {
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.fromOffset(14, 11),
            BackgroundTransparency = 1,
            Image = ico("search") or "",
            ImageColor3 = c.sub,
            Parent = sbox
        })
        local sfield = make("TextBox", {
            Size = UDim2.new(1, -46, 1, 0),
            Position = UDim2.fromOffset(38, 0),
            BackgroundTransparency = 1,
            Text = "",
            PlaceholderText = "What do you want to play?",
            PlaceholderColor3 = c.sub,
            TextColor3 = c.text,
            Font = fr,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Parent = sbox
        })

        local closeb = iconbtn(top, "x", 18)
        closeb.Position = UDim2.new(1, -34, 0, 19)
        tip(closeb, "close")
        tip(homeb, "home")
        tip(sfield, "search spotify")
        tip(logo, "kyrilib for spotify")

        local bar = make("Frame", {
            Size = UDim2.new(1, 0, 0, 76),
            Position = UDim2.new(0, 0, 1, -76),
            BackgroundColor3 = c.bg,
            Active = true,
            Parent = win
        })
        make("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = c.line,
            Parent = bar
        })

        local body = make("Frame", {
            Size = UDim2.new(1, -16, 1, -142),
            Position = UDim2.fromOffset(8, 58),
            BackgroundTransparency = 1,
            Parent = win
        })

        local side = make("Frame", {
            Size = UDim2.new(0, 248, 1, 0),
            BackgroundColor3 = c.panel,
            Active = true,
            Parent = body
        })
        round(side, 8)

        local right = make("Frame", {
            Size = UDim2.new(0, 300, 1, 0),
            Position = UDim2.new(1, -300, 0, 0),
            BackgroundColor3 = c.panel,
            Active = true,
            ClipsDescendants = true,
            Parent = body
        })
        round(right, 8)

        local mid = make("Frame", {
            Size = UDim2.new(1, -564, 1, 0),
            Position = UDim2.fromOffset(256, 0),
            BackgroundColor3 = c.panel,
            Active = true,
            ClipsDescendants = true,
            Parent = body
        })
        round(mid, 8)

        local lib_title = lbl(side, {
            Size = UDim2.new(1, -56, 0, 20),
            Position = UDim2.fromOffset(44, 14),
            Text = "Your Library",
            Font = fb,
            TextSize = 15
        })

        local libtog = make("ImageButton", {
            Size = UDim2.fromOffset(28, 28),
            Position = UDim2.fromOffset(10, 10),
            BackgroundColor3 = c.hover,
            BackgroundTransparency = 1,
            Image = "",
            AutoButtonColor = false,
            Parent = side
        })
        round(libtog, 14)
        hoverable(libtog, c.panel, c.hover)
        libtog.BackgroundTransparency = 1
        libtog.MouseEnter:Connect(function()
            tw:Create(libtog, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
        end)
        libtog.MouseLeave:Connect(function()
            tw:Create(libtog, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
        end)
        local libtog_i = make("ImageLabel", {
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(0.5, -8, 0.5, -8),
            BackgroundTransparency = 1,
            Image = ico("sidebar") or "",
            ImageColor3 = c.sub,
            Parent = libtog
        })
        tip(libtog, "collapse your library")

        local chips = make("Frame", {
            Size = UDim2.new(1, -24, 0, 26),
            Position = UDim2.fromOffset(12, 40),
            BackgroundTransparency = 1,
            Parent = side
        })
        make("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = chips
        })

        local lib_list = scroller(side, {
            Size = UDim2.new(1, -10, 1, -80),
            Position = UDim2.fromOffset(5, 74)
        })

        local mid_scroll = scroller(mid, {
            Size = UDim2.new(1, -8, 1, -8),
            Position = UDim2.fromOffset(4, 4)
        })
        make("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 16),
            Parent = mid_scroll
        })

        local lib = {playlist = {}, album = {}, artist = {}}
        local filter = "all"
        local view_fn
        local shut = false
        local relib

        local function fetch(ep)
            local r = api("GET", ep)
            if not r or r.StatusCode ~= 200 then return nil end
            local ok, d = pcall(function() return hs:JSONDecode(r.Body) end)
            if not ok then return nil end
            return d
        end

        local function names(arts)
            local out = {}
            for i,a in pairs(arts or {}) do out[#out + 1] = a.name end
            return table.concat(out, ", ")
        end

        local function commas(n)
            local s = tostring(math.floor(tonumber(n) or 0))
            local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
            return (out:gsub("^,", ""))
        end

        local function row(parent, h)
            local b = make("TextButton", {
                Size = UDim2.new(1, 0, 0, h),
                BackgroundColor3 = c.panel,
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = #parent:GetChildren(),
                Parent = parent
            })
            round(b, 5)
            b.MouseEnter:Connect(function()
                tw:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0, BackgroundColor3 = c.hover}):Play()
            end)
            b.MouseLeave:Connect(function()
                tw:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
            end)
            return b
        end

        local function cover(parent, size, x, y, rad)
            local im = make("ImageLabel", {
                Size = UDim2.fromOffset(size, size),
                Position = UDim2.fromOffset(x, y),
                BackgroundColor3 = c.raise,
                Image = "",
                ScaleType = Enum.ScaleType.Crop,
                Parent = parent
            })
            round(im, rad or 4)
            return im
        end

        local function band(ord)
            local f = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = ord or #mid_scroll:GetChildren(),
                Parent = mid_scroll
            })
            make("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = f
            })
            return f
        end

        local function sect(title, into)
            return lbl(into or mid_scroll, {
                Size = UDim2.new(1, 0, 0, 26),
                Text = title,
                Font = fb,
                TextSize = 17,
                LayoutOrder = #(into or mid_scroll):GetChildren()
            })
        end

        local open_playlist, open_album, open_artist, show_home, do_search

        local function track_row(t, ctx, n, into)
            if not t or not t.id then return end
            local b = row(into or mid_scroll, 46)

            lbl(b, {
                Size = UDim2.fromOffset(26, 46),
                Position = UDim2.fromOffset(2, 0),
                Text = tostring(n),
                TextColor3 = c.sub,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Center
            })

            local im = cover(b, 34, 34, 6)
            paint(im, t, t.id)

            lbl(b, {
                Size = UDim2.new(1, -200, 0, 17),
                Position = UDim2.fromOffset(78, 6),
                Text = t.name or "",
                Font = fm,
                TextSize = 13,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
            lbl(b, {
                Size = UDim2.new(1, -200, 0, 15),
                Position = UDim2.fromOffset(78, 24),
                Text = names(t.artists),
                TextColor3 = c.sub,
                TextSize = 11,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
            lbl(b, {
                Size = UDim2.fromOffset(50, 46),
                Position = UDim2.new(1, -58, 0, 0),
                Text = fmt_time(math.floor((t.duration_ms or 0) / 1000)),
                TextColor3 = c.sub,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            b.MouseButton1Click:Connect(function()
                sp:playuri(t.uri, ctx)
            end)
        end

        local function lib_row(it, kind)
            local b = row(lib_list, 56)
            local im = cover(b, 42, shut and 11 or 7, 7, kind == "artist" and 21 or 4)
            paint(im, it, it.id)
            if shut then
                tip(b, it.name or "")
                b.MouseButton1Click:Connect(function()
                    if kind == "playlist" then open_playlist(it)
                    elseif kind == "album" then open_album(it)
                    else open_artist(it.id, it) end
                end)
                return
            end

            lbl(b, {
                Size = UDim2.new(1, -62, 0, 17),
                Position = UDim2.fromOffset(58, 10),
                Text = it.name or "",
                Font = fm,
                TextSize = 13,
                TextTruncate = Enum.TextTruncate.AtEnd
            })

            local sub = kind == "playlist" and ("Playlist  -  " .. ((it.owner and it.owner.display_name) or "you"))
                or kind == "album" and ("Album  -  " .. names(it.artists))
                or "Artist"

            lbl(b, {
                Size = UDim2.new(1, -62, 0, 15),
                Position = UDim2.fromOffset(58, 28),
                Text = sub,
                TextColor3 = c.sub,
                TextSize = 11,
                TextTruncate = Enum.TextTruncate.AtEnd
            })

            b.MouseButton1Click:Connect(function()
                if kind == "playlist" then open_playlist(it)
                elseif kind == "album" then open_album(it)
                else open_artist(it.id, it) end
            end)
        end

        local function fill_library()
            wipe(lib_list)
            local kinds = filter == "all" and {"playlist", "artist", "album"} or {filter}
            for i,k in pairs(kinds) do
                for j,it in pairs(lib[k]) do lib_row(it, k) end
            end
        end

        function relib()
            local w = shut and 64 or 248
            tw:Create(side, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, w, 1, 0)}):Play()
            tw:Create(mid, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, -(w + 316), 1, 0), Position = UDim2.fromOffset(w + 8, 0)}):Play()
            lib_title.Visible = not shut
            chips.Visible = not shut
            lib_list.Position = UDim2.fromOffset(5, shut and 48 or 74)
            lib_list.Size = UDim2.new(1, -10, 1, shut and -54 or -80)
            libtog_i.Image = ico(shut and "chevrons-right" or "sidebar") or libtog_i.Image
            libtog.Position = UDim2.fromOffset(shut and 18 or 10, 10)
            fill_library()
        end

        libtog.MouseButton1Click:Connect(function()
            shut = not shut
            tip(libtog, shut and "expand your library" or "collapse your library")
            relib()
        end)

        do
            local btns = {}
            local function chip(key, text)
                local b = make("TextButton", {
                    Size = UDim2.fromOffset(#text * 7 + 22, 26),
                    BackgroundColor3 = c.raise,
                    Text = text,
                    TextColor3 = c.text,
                    Font = fr,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = chips
                })
                round(b, 13)
                btns[key] = b
                b.MouseButton1Click:Connect(function()
                    filter = filter == key and "all" or key
                    for k,v in pairs(btns) do
                        v.BackgroundColor3 = filter == k and c.text or c.raise
                        v.TextColor3 = filter == k and Color3.new(0, 0, 0) or c.text
                    end
                    fill_library()
                end)
                return b
            end
            tip(chip("playlist", "Playlists"), "only playlists")
            tip(chip("artist", "Artists"), "only artists")
            tip(chip("album", "Albums"), "only albums")
        end

        local nagged = false
        local function nag()
            if not sp.stale_scopes or nagged then return end
            nagged = true
            wipe(mid_scroll)
            lbl(mid_scroll, {
                Size = UDim2.new(1, 0, 0, 30),
                Text = "reconnect spotify to finish setting up",
                Font = fb,
                TextSize = 19,
                LayoutOrder = 1
            })
            lbl(mid_scroll, {
                Size = UDim2.new(1, 0, 0, 52),
                Text = "your saved sign in predates followed artists and top tracks, so spotify "
                    .. "answers 403 for both. signing in again grants them and nothing else changes.",
                TextColor3 = c.sub,
                TextSize = 12,
                TextWrapped = true,
                TextYAlignment = Enum.TextYAlignment.Top,
                LayoutOrder = 2
            })
            local b = make("TextButton", {
                Size = UDim2.fromOffset(150, 36),
                BackgroundColor3 = c.green,
                Text = "reconnect",
                TextColor3 = Color3.new(0, 0, 0),
                Font = fb,
                TextSize = 13,
                AutoButtonColor = false,
                LayoutOrder = 3,
                Parent = mid_scroll
            })
            round(b, 18)
            tip(b, "opens the spotify sign in page")
            b.MouseButton1Click:Connect(function()
                local url = sp:authurl()
                if url then kyri.copybox(url, "open this to reconnect") end
            end)
        end

        local function load_library()
            task.spawn(function()
                local d = fetch("/me/playlists?limit=50")
                lib.playlist = (d and d.items) or {}
                fill_library()
            end)
            task.spawn(function()
                local d = fetch("/me/following?type=artist&limit=50")
                lib.artist = (d and d.artists and d.artists.items) or {}
                fill_library()
            end)
            task.spawn(function()
                local d = fetch("/me/albums?limit=50")
                local out = {}
                for i,v in pairs((d and d.items) or {}) do out[#out + 1] = v.album end
                lib.album = out
                fill_library()
            end)
        end

        local function card_grid(items, kind, per, into)
            local holder = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = #(into or mid_scroll):GetChildren(),
                Parent = into or mid_scroll
            })
            local grid = make("UIGridLayout", {
                CellSize = UDim2.fromOffset(136, 176),
                CellPadding = UDim2.fromOffset(12, 12),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = holder
            })

            for i,it in pairs(items) do
                if i > (per or 10) then break end
                local b = make("TextButton", {
                    BackgroundColor3 = c.raise,
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = i,
                    Parent = holder
                })
                round(b, 7)
                b.MouseEnter:Connect(function()
                    tw:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
                end)
                b.MouseLeave:Connect(function()
                    tw:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
                end)

                local im = cover(b, 112, 12, 12, kind == "artist" and 56 or 5)
                paint(im, it, it.id)

                lbl(b, {
                    Size = UDim2.new(1, -20, 0, 17),
                    Position = UDim2.fromOffset(12, 130),
                    Text = it.name or "",
                    Font = fm,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                lbl(b, {
                    Size = UDim2.new(1, -20, 0, 15),
                    Position = UDim2.fromOffset(12, 148),
                    Text = kind == "artist" and "Artist" or names(it.artists),
                    TextColor3 = c.sub,
                    TextSize = 11,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })

                b.MouseButton1Click:Connect(function()
                    if kind == "artist" then open_artist(it.id, it)
                    elseif kind == "album" then open_album(it)
                    elseif kind == "playlist" then open_playlist(it)
                    else sp:playuri(it.uri, it.album and it.album.uri) end
                end)
            end
            return holder
        end

        local function page_head(it, kind, subline)
            local h = make("Frame", {
                Size = UDim2.new(1, 0, 0, 172),
                BackgroundTransparency = 1,
                LayoutOrder = #mid_scroll:GetChildren(),
                Parent = mid_scroll
            })
            local im = cover(h, 148, 0, 10, kind == "artist" and 74 or 6)
            paint(im, it, it.id)

            lbl(h, {
                Size = UDim2.new(1, -176, 0, 15),
                Position = UDim2.fromOffset(164, 48),
                Text = kind,
                TextColor3 = c.sub,
                TextSize = 11
            })
            lbl(h, {
                Size = UDim2.new(1, -176, 0, 42),
                Position = UDim2.fromOffset(164, 66),
                Text = it.name or "",
                Font = fb,
                TextSize = 30,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
            lbl(h, {
                Size = UDim2.new(1, -176, 0, 16),
                Position = UDim2.fromOffset(164, 112),
                Text = subline or "",
                TextColor3 = c.sub,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd
            })

            local play = make("TextButton", {
                Size = UDim2.fromOffset(46, 46),
                Position = UDim2.fromOffset(164, 136),
                BackgroundColor3 = c.green,
                Text = "",
                AutoButtonColor = false,
                Parent = h
            })
            round(play, 23)
            make("ImageLabel", {
                Size = UDim2.fromOffset(19, 19),
                Position = UDim2.new(0.5, -9, 0.5, -9),
                BackgroundTransparency = 1,
                Image = ico("play") or "",
                ImageColor3 = Color3.new(0, 0, 0),
                Parent = play
            })
            play.MouseButton1Click:Connect(function()
                sp:playcontext(it.uri)
            end)
            h.Size = UDim2.new(1, 0, 0, 196)
            return h
        end

        function open_playlist(it)
            view_fn = function() open_playlist(it) end
            recents_add({uri = it.uri, name = it.name, kind = "playlist", id = it.id})
            wipe(mid_scroll)
            page_head(it, "Playlist", (it.owner and it.owner.display_name or "") ..
                (it.tracks and it.tracks.total and ("  -  " .. it.tracks.total .. " songs") or ""))
            task.spawn(function()
                local d = fetch("/playlists/" .. it.id .. "/tracks?limit=50")
                local n = 0
                for i,v in pairs((d and d.items) or {}) do
                    if v.track and v.track.id then
                        n = n + 1
                        track_row(v.track, it.uri, n)
                    end
                end
            end)
        end

        function open_album(it)
            view_fn = function() open_album(it) end
            recents_add({uri = it.uri, name = it.name, kind = "album", id = it.id})
            wipe(mid_scroll)
            page_head(it, "Album", names(it.artists))
            task.spawn(function()
                local d = fetch("/albums/" .. it.id .. "/tracks?limit=50")
                for i,t in pairs((d and d.items) or {}) do
                    t.album = t.album or it
                    track_row(t, it.uri, i)
                end
            end)
        end

        function open_artist(aid, seed)
            if not aid then return end
            view_fn = function() open_artist(aid, seed) end
            wipe(mid_scroll)
            task.spawn(function()
                local a = fetch("/artists/" .. aid) or seed
                if not a then return end
                recents_add({uri = a.uri, name = a.name, kind = "artist", id = a.id})
                local f = a.followers and a.followers.total
                page_head(a, "Artist", f and (commas(f) .. " followers") or "")

                local t = fetch("/artists/" .. aid .. "/top-tracks")
                if t and t.tracks and #t.tracks > 0 then
                    sect("Popular")
                    for i,v in pairs(t.tracks) do
                        if i > 10 then break end
                        track_row(v, nil, i)
                    end
                end

                local al = fetch("/artists/" .. aid .. "/albums?limit=10&include_groups=album,single")
                if al and al.items and #al.items > 0 then
                    sect("Discography")
                    card_grid(al.items, "album", 10)
                end
            end)
        end

        function show_home()
            view_fn = show_home
            wipe(mid_scroll)
            local b1, b2, b3 = band(1), band(2), band(3)
            task.spawn(function()
                local d = fetch("/me/player/recently-played?limit=12")
                local seen, items = {}, {}
                for i,v in pairs((d and d.items) or {}) do
                    local t = v.track
                    if t and t.id and not seen[t.id] then
                        seen[t.id] = true
                        items[#items + 1] = t
                    end
                end
                if #items > 0 then
                    sect("Recently played", b1)
                    card_grid(items, "track", 10, b1)
                end
            end)
            task.spawn(function()
                local d = fetch("/me/top/tracks?limit=10&time_range=short_term")
                if d and d.items and #d.items > 0 then
                    sect("On repeat lately", b2)
                    for i,t in pairs(d.items) do track_row(t, nil, i, b2) end
                end
            end)
            task.spawn(function()
                local d = fetch("/me/top/artists?limit=10&time_range=medium_term")
                if d and d.items and #d.items > 0 then
                    sect("Your top artists", b3)
                    card_grid(d.items, "artist", 10, b3)
                end
            end)
        end

        function do_search(q)
            view_fn = function() do_search(q) end
            wipe(mid_scroll)
            task.spawn(function()
                local d = fetch("/search?q=" .. hs:UrlEncode(q) .. "&type=track,artist,album,playlist&limit=10")
                if not d then return end
                local tr = d.tracks and d.tracks.items or {}
                if #tr > 0 then
                    sect("Songs")
                    for i,t in pairs(tr) do
                        if i > 6 then break end
                        track_row(t, nil, i)
                    end
                end
                local ar = d.artists and d.artists.items or {}
                if #ar > 0 then
                    sect("Artists")
                    card_grid(ar, "artist", 6)
                end
                local ab = d.albums and d.albums.items or {}
                if #ab > 0 then
                    sect("Albums")
                    card_grid(ab, "album", 6)
                end
                local pl = d.playlists and d.playlists.items or {}
                local clean = {}
                for i,v in pairs(pl) do
                    if type(v) == "table" and v.id then clean[#clean + 1] = v end
                end
                if #clean > 0 then
                    sect("Playlists")
                    card_grid(clean, "playlist", 6)
                end
                if #tr == 0 and #ar == 0 and #ab == 0 and #clean == 0 then
                    lbl(mid_scroll, {
                        Size = UDim2.new(1, 0, 0, 40),
                        Text = "nothing found for " .. q,
                        TextColor3 = c.sub,
                        LayoutOrder = 1
                    })
                end
            end)
        end

        local drop = make("Frame", {
            Size = UDim2.fromOffset(380, 0),
            Position = UDim2.new(0.5, -190, 0, 50),
            BackgroundColor3 = c.raise,
            Visible = false,
            Active = true,
            ZIndex = 20,
            ClipsDescendants = true,
            Parent = win
        })
        round(drop, 7)
        local shut_drop = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            Visible = false,
            AutoButtonColor = false,
            ZIndex = 19,
            Parent = win
        })
        local drop_list = scroller(drop, {
            Size = UDim2.new(1, -8, 1, -12),
            Position = UDim2.fromOffset(4, 6),
            ZIndex = 20
        })

        local function show_drop()
            local r = recents_load()
            wipe(drop_list)
            if #r == 0 then
                drop.Visible = false
                return
            end
            lbl(drop_list, {
                Size = UDim2.new(1, 0, 0, 22),
                Text = "Recent searches",
                Font = fb,
                TextSize = 13,
                ZIndex = 21,
                LayoutOrder = 0
            })
            for i,it in pairs(r) do
                local b = row(drop_list, 42)
                b.ZIndex = 21
                local im = cover(b, 32, 6, 5, it.kind == "artist" and 16 or 4)
                im.ZIndex = 21
                lbl(b, {
                    Size = UDim2.new(1, -52, 0, 16),
                    Position = UDim2.fromOffset(46, 5),
                    Text = it.name or "",
                    Font = fm,
                    TextSize = 12,
                    ZIndex = 21,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                lbl(b, {
                    Size = UDim2.new(1, -52, 0, 14),
                    Position = UDim2.fromOffset(46, 22),
                    Text = (it.kind or ""):gsub("^%l", string.upper),
                    TextColor3 = c.sub,
                    TextSize = 10,
                    ZIndex = 21
                })
                task.spawn(function()
                    local obj = fetch("/" .. (it.kind == "playlist" and "playlists" or it.kind == "album" and "albums" or "artists") .. "/" .. it.id)
                    if obj then paint(im, obj, it.id) end
                end)
                b.MouseButton1Click:Connect(function()
                    drop.Visible = false
                    sfield.Text = ""
                    if it.kind == "artist" then open_artist(it.id)
                    else
                        local obj = fetch("/" .. (it.kind == "playlist" and "playlists" or "albums") .. "/" .. it.id)
                        if obj then
                            if it.kind == "playlist" then open_playlist(obj) else open_album(obj) end
                        end
                    end
                end)
            end
            drop.Visible = true
            shut_drop.Visible = true
            tw:Create(drop, TweenInfo.new(0.16), {Size = UDim2.fromOffset(380, math.min(#r * 48 + 34, 300))}):Play()
        end

        local function hide_drop()
            shut_drop.Visible = false
            tw:Create(drop, TweenInfo.new(0.12), {Size = UDim2.fromOffset(380, 0)}):Play()
            task.delay(0.13, function() drop.Visible = false end)
        end

        shut_drop.MouseButton1Click:Connect(hide_drop)

        sfield.Focused:Connect(function()
            if sfield.Text == "" then show_drop() end
        end)

        local stamp = 0
        sfield:GetPropertyChangedSignal("Text"):Connect(function()
            local q = sfield.Text
            stamp = stamp + 1
            local mine = stamp
            if q == "" then
                show_drop()
                return
            end
            hide_drop()
            task.delay(0.45, function()
                if mine == stamp and sfield.Text == q then do_search(q) end
            end)
        end)

        sfield.FocusLost:Connect(function(enter)
            if enter and sfield.Text ~= "" then do_search(sfield.Text) end
            task.delay(0.25, function()
                if not sfield:IsFocused() then hide_drop() end
            end)
        end)

        homeb.MouseButton1Click:Connect(function()
            sfield.Text = ""
            hide_drop()
            show_home()
        end)

        local np_art = cover(right, 268, 16, 16, 7)
        local np_title = lbl(right, {
            Size = UDim2.new(1, -32, 0, 24),
            Position = UDim2.fromOffset(16, 294),
            Text = "nothing playing",
            Font = fb,
            TextSize = 19,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        local np_art_btn = make("TextButton", {
            Size = UDim2.new(1, -32, 0, 18),
            Position = UDim2.fromOffset(16, 320),
            BackgroundTransparency = 1,
            Text = "",
            Parent = right
        })
        local np_artist = lbl(np_art_btn, {
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextColor3 = c.sub,
            TextSize = 13,
            TextTruncate = Enum.TextTruncate.AtEnd
        })

        local about = make("Frame", {
            Size = UDim2.new(1, -32, 0, 148),
            Position = UDim2.fromOffset(16, 352),
            BackgroundColor3 = c.raise,
            ClipsDescendants = true,
            Parent = right
        })
        round(about, 8)
        lbl(about, {
            Size = UDim2.new(1, -24, 0, 18),
            Position = UDim2.fromOffset(12, 10),
            Text = "About the artist",
            Font = fb,
            TextSize = 13
        })
        local ab_img = cover(about, 56, 12, 34, 28)
        local ab_name = lbl(about, {
            Size = UDim2.new(1, -92, 0, 18),
            Position = UDim2.fromOffset(78, 42),
            Text = "",
            Font = fm,
            TextSize = 14,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        local ab_foll = lbl(about, {
            Size = UDim2.new(1, -92, 0, 16),
            Position = UDim2.fromOffset(78, 62),
            Text = "",
            TextColor3 = c.sub,
            TextSize = 11
        })
        local ab_gen = lbl(about, {
            Size = UDim2.new(1, -24, 0, 32),
            Position = UDim2.fromOffset(12, 100),
            Text = "",
            TextColor3 = c.sub,
            TextSize = 11,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top
        })

        local b_art = cover(bar, 56, 14, 10, 5)
        local b_title = lbl(bar, {
            Size = UDim2.fromOffset(190, 18),
            Position = UDim2.fromOffset(80, 18),
            Text = "nothing playing",
            Font = fm,
            TextSize = 13,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        local b_artist = lbl(bar, {
            Size = UDim2.fromOffset(190, 16),
            Position = UDim2.fromOffset(80, 38),
            Text = "",
            TextColor3 = c.sub,
            TextSize = 11,
            TextTruncate = Enum.TextTruncate.AtEnd
        })

        local ctr = make("Frame", {
            Size = UDim2.fromOffset(190, 32),
            Position = UDim2.new(0.5, -95, 0, 8),
            BackgroundTransparency = 1,
            Parent = bar
        })

        local shuf = iconbtn(ctr, "shuffle", 16)
        shuf.Position = UDim2.fromOffset(0, 8)
        local prev = iconbtn(ctr, "skip-back", 18)
        prev.Position = UDim2.fromOffset(38, 7)
        local playb = make("TextButton", {
            Size = UDim2.fromOffset(32, 32),
            Position = UDim2.fromOffset(79, 0),
            BackgroundColor3 = c.text,
            Text = "",
            AutoButtonColor = false,
            Parent = ctr
        })
        round(playb, 16)
        local playi = make("ImageLabel", {
            Size = UDim2.fromOffset(15, 15),
            Position = UDim2.new(0.5, -7, 0.5, -7),
            BackgroundTransparency = 1,
            Image = ico("play") or "",
            ImageColor3 = Color3.new(0, 0, 0),
            Parent = playb
        })
        local nextb = iconbtn(ctr, "skip-forward", 18)
        nextb.Position = UDim2.fromOffset(125, 7)
        local loopb = iconbtn(ctr, "repeat", 16)
        loopb.Position = UDim2.fromOffset(170, 8)

        local t_left = lbl(bar, {
            Size = UDim2.fromOffset(40, 14),
            Position = UDim2.new(0.5, -268, 0, 47),
            Text = "0:00",
            TextColor3 = c.sub,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        local t_right = lbl(bar, {
            Size = UDim2.fromOffset(40, 14),
            Position = UDim2.new(0.5, 228, 0, 47),
            Text = "0:00",
            TextColor3 = c.sub,
            TextSize = 10
        })

        local strack = make("Frame", {
            Size = UDim2.fromOffset(440, 4),
            Position = UDim2.new(0.5, -220, 0, 52),
            BackgroundColor3 = c.hover,
            Parent = bar
        })
        round(strack, 2)
        local sfill = make("Frame", {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = c.text,
            Parent = strack
        })
        round(sfill, 2)
        local shit = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.fromOffset(0, -7),
            BackgroundTransparency = 1,
            Text = "",
            Parent = strack
        })

        local vol_ic = iconbtn(bar, "volume-2", 16)
        vol_ic.Position = UDim2.new(1, -152, 0, 30)
        local vtrack = make("Frame", {
            Size = UDim2.fromOffset(96, 4),
            Position = UDim2.new(1, -128, 0, 36),
            BackgroundColor3 = c.hover,
            Parent = bar
        })
        round(vtrack, 2)
        local vfill = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = c.text,
            Parent = vtrack
        })
        round(vfill, 2)
        local vhit = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.fromOffset(0, -7),
            BackgroundTransparency = 1,
            Text = "",
            Parent = vtrack
        })

        local lyrb = iconbtn(bar, "quote", 16)
        lyrb.Position = UDim2.new(1, -212, 0, 30)
        tip(lyrb, "lyrics")
        lyrb.MouseButton1Click:Connect(function()
            sp:cinema(dopts.cinema_options):toggle()
        end)

        local devb = iconbtn(bar, "monitor", 16)
        devb.Position = UDim2.new(1, -182, 0, 30)
        tip(devb, "connect to a device")
        tip(shuf, "shuffle")
        tip(prev, "previous")
        tip(playb, "play or pause")
        tip(nextb, "next")
        tip(loopb, "repeat")
        tip(shit, "seek")
        tip(vhit, "volume")
        tip(vol_ic, "volume")
        tip(np_art_btn, "go to artist")

        local shut_pop = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            Visible = false,
            AutoButtonColor = false,
            ZIndex = 28,
            Parent = win
        })

        local devpop = make("Frame", {
            Size = UDim2.fromOffset(224, 0),
            Position = UDim2.new(1, -206, 1, -164),
            BackgroundColor3 = c.raise,
            Visible = false,
            Active = true,
            ClipsDescendants = true,
            ZIndex = 30,
            Parent = win
        })
        round(devpop, 8)
        local devlist = scroller(devpop, {
            Size = UDim2.new(1, -10, 1, -12),
            Position = UDim2.fromOffset(5, 6),
            ZIndex = 30
        })

        local function devhide()
            shut_pop.Visible = false
            tw:Create(devpop, TweenInfo.new(0.12), {Size = UDim2.fromOffset(224, 0)}):Play()
            task.delay(0.13, function() devpop.Visible = false end)
        end

        shut_pop.MouseButton1Click:Connect(devhide)

        local function devplace(h)
            local ws = win.AbsoluteSize
            local bx = devb.AbsolutePosition.X - win.AbsolutePosition.X - 104
            local by = devb.AbsolutePosition.Y - win.AbsolutePosition.Y
            local y = by - h - 10
            if y < 10 then y = math.min(by + 28, ws.Y - h - 10) end
            devpop.Position = UDim2.fromOffset(math.clamp(bx, 10, math.max(ws.X - 234, 10)), y)
            tw:Create(devpop, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.fromOffset(224, h)}):Play()
        end

        devb.MouseButton1Click:Connect(function()
            if devpop.Visible then return devhide() end
            wipe(devlist)
            devpop.Visible = true
            shut_pop.Visible = true
            devplace(60)
            task.spawn(function()
                local ds = sp:devices()
                if not devpop.Visible then return end
                wipe(devlist)
                lbl(devlist, {
                    Size = UDim2.new(1, 0, 0, 22),
                    Text = "Connect to a device",
                    Font = fb,
                    TextSize = 13,
                    ZIndex = 31,
                    LayoutOrder = 0
                })
                for i,d in pairs(ds) do
                    local b = row(devlist, 38)
                    b.ZIndex = 31
                    make("ImageLabel", {
                        Size = UDim2.fromOffset(16, 16),
                        Position = UDim2.fromOffset(8, 11),
                        BackgroundTransparency = 1,
                        Image = ico(d.type == "Smartphone" and "smartphone" or d.type == "Computer" and "laptop" or "speaker") or "",
                        ImageColor3 = d.is_active and c.green or c.sub,
                        ZIndex = 31,
                        Parent = b
                    })
                    lbl(b, {
                        Size = UDim2.new(1, -40, 0, 16),
                        Position = UDim2.fromOffset(32, 4),
                        Text = d.name or "",
                        TextColor3 = d.is_active and c.green or c.text,
                        Font = fm,
                        TextSize = 12,
                        ZIndex = 31,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    })
                    lbl(b, {
                        Size = UDim2.new(1, -40, 0, 14),
                        Position = UDim2.fromOffset(32, 20),
                        Text = d.type or "",
                        TextColor3 = c.sub,
                        TextSize = 10,
                        ZIndex = 31
                    })
                    b.MouseButton1Click:Connect(function()
                        sp:transfer(d.id, sp.playing)
                        devhide()
                    end)
                end
                if #ds == 0 then
                    lbl(devlist, {
                        Size = UDim2.new(1, 0, 0, 30),
                        Text = "no devices, open spotify somewhere",
                        TextColor3 = c.sub,
                        TextSize = 11,
                        ZIndex = 31,
                        LayoutOrder = 1
                    })
                end
                devplace(math.min(math.max(#ds, 1) * 44 + 34, 260))
            end)
        end)

        playb.MouseButton1Click:Connect(function()
            sp:toggle()
            playi.Image = ico(sp.playing and "pause" or "play") or playi.Image
        end)
        prev.MouseButton1Click:Connect(function() sp:prev() end)
        nextb.MouseButton1Click:Connect(function() sp:next() end)
        shuf.MouseButton1Click:Connect(function()
            sp:setshuffle(not sp.shuffle)
            shuf.ImageColor3 = sp.shuffle and c.green or c.sub
        end)
        loopb.MouseButton1Click:Connect(function()
            local nx = sp.loop == "off" and "context" or sp.loop == "context" and "track" or "off"
            sp:setloop(nx)
            loopb.Image = ico(nx == "track" and "repeat-1" or "repeat") or loopb.Image
            loopb.ImageColor3 = nx == "off" and c.sub or c.green
        end)

        local seeking = false
        do
            local function to(x)
                local p = math.clamp((x - strack.AbsolutePosition.X) / math.max(strack.AbsoluteSize.X, 1), 0, 1)
                sfill.Size = UDim2.fromScale(p, 1)
                return p
            end
            shit.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    seeking = true
                    to(i.Position.X)
                end
            end)
            kyri.svc.inp.InputChanged:Connect(function(i)
                if not seeking then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    to(i.Position.X)
                end
            end)
            kyri.svc.inp.InputEnded:Connect(function(i)
                if not seeking then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    seeking = false
                    sp:seek(to(i.Position.X) * 100)
                end
            end)
        end

        do
            local vdrag = false
            local function to(x)
                local p = math.clamp((x - vtrack.AbsolutePosition.X) / math.max(vtrack.AbsoluteSize.X, 1), 0, 1)
                vfill.Size = UDim2.fromScale(p, 1)
                return math.floor(p * 100 + 0.5)
            end
            vhit.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    vdrag = true
                    to(i.Position.X)
                end
            end)
            kyri.svc.inp.InputChanged:Connect(function(i)
                if not vdrag then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    to(i.Position.X)
                end
            end)
            kyri.svc.inp.InputEnded:Connect(function(i)
                if not vdrag then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    vdrag = false
                    sp:volume(to(i.Position.X))
                end
            end)
        end

        local cur_artist = ""

        local function refresh_about()
            local t = sp.track
            if not t or not t.artists or not t.artists[1] then return end
            local a1 = t.artists[1]
            if a1.id == cur_artist then return end
            cur_artist = a1.id
            ab_name.Text = a1.name or ""
            ab_foll.Text = ""
            ab_gen.Text = ""
            ab_img.Image = ""
            task.spawn(function()
                local a = fetch("/artists/" .. a1.id)
                if not a or cur_artist ~= a1.id then return end
                paint(ab_img, a, a.id)
                if a.followers and a.followers.total then
                    ab_foll.Text = commas(a.followers.total) .. " followers"
                end
                if a.genres and #a.genres > 0 then
                    ab_gen.Text = table.concat(a.genres, ", ")
                end
            end)
        end

        np_art_btn.MouseButton1Click:Connect(function()
            local t = sp.track
            if t and t.artists and t.artists[1] then open_artist(t.artists[1].id, t.artists[1]) end
        end)

        local shown_id = ""

        local function refresh()
            local t = sp.track
            if not t then return end
            np_title.Text = t.name or ""
            b_title.Text = t.name or ""
            local who = sp:artists()
            np_artist.Text = who
            b_artist.Text = who
            playi.Image = ico(sp.playing and "pause" or "play") or playi.Image
            shuf.ImageColor3 = sp.shuffle and c.green or c.sub
            loopb.ImageColor3 = (sp.loop and sp.loop ~= "off") and c.green or c.sub

            if t.id ~= shown_id then
                shown_id = t.id
                paint(np_art, t, t.id)
                paint(b_art, t, t.id)
                refresh_about()
            end
            if sp.dur > 0 and not seeking then
                sfill.Size = UDim2.fromScale(math.clamp(sp.pos / sp.dur, 0, 1), 1)
            end
            t_left.Text = fmt_time(sp.pos)
            t_right.Text = fmt_time(sp.dur)
            if sp.vol_known then vfill.Size = UDim2.fromScale(sp.vol / 100, 1) end
        end

        hooks[#hooks + 1] = function()
            if gui.Enabled then pcall(refresh) end
        end

        local loaded = false

        dk = {gui = gui, win = win, colors = c}

        function dk:show()
            gui.Enabled = true
            win.Size = UDim2.fromScale(0.82, 0.84)
            shade.BackgroundTransparency = 1
            tw:Create(shade, TweenInfo.new(0.2), {BackgroundTransparency = 0.45}):Play()
            tw:Create(win, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.fromScale(0.86, 0.88)}):Play()
            if not loaded then
                loaded = true
                load_library()
                show_home()
                task.delay(0.8, function()
                    if sp.stale_scopes then nag() end
                end)
                task.delay(3.5, function()
                    if sp.stale_scopes then nag() end
                end)
            end
            pcall(refresh)
            task.spawn(function() sp:sync() end)
        end

        function dk:hide()
            tw:Create(shade, TweenInfo.new(0.16), {BackgroundTransparency = 1}):Play()
            tw:Create(win, TweenInfo.new(0.18), {Size = UDim2.fromScale(0.82, 0.84)}):Play()
            task.delay(0.19, function() gui.Enabled = false end)
        end

        function dk:toggle()
            if gui.Enabled then dk:hide() else dk:show() end
        end

        function dk:open() dk:show() end
        function dk:refresh() if view_fn then view_fn() end end
        function dk:destroy()
            pcall(function() gui:Destroy() end)
            dk = nil
        end

        closeb.MouseButton1Click:Connect(function() dk:hide() end)
        shade.MouseButton1Click:Connect(function()
            local m = kyri.svc.inp:GetMouseLocation()
            local tl, sz = win.AbsolutePosition, win.AbsoluteSize
            if m.X >= tl.X and m.X <= tl.X + sz.X and m.Y >= tl.Y and m.Y <= tl.Y + sz.Y then return end
            hide_drop()
            dk:hide()
        end)
        win.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then hide_drop() end
        end)

        return dk
    end

    local cin

    function sp:cinema(copts)
        if cin then return cin end
        copts = copts or {}

        local lp = kyri.svc.plr.LocalPlayer
        local tw = kyri.svc.tw
        local ts = kyri.svc.ts

        local fb = Enum.Font.GothamBold
        local fm = Enum.Font.GothamMedium
        local fr = Enum.Font.Gotham

        local mode = copts.mode or "nowbar"
        local compact = copts.compact == true
        local side = copts.side or "left"

        local EASE = TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local FADE = TweenInfo.new(0.26)

        local gui = make("ScreenGui", {
            Name = rnd(),
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 999999999,
            Enabled = false,
            Parent = gethui and gethui() or lp:WaitForChild("PlayerGui")
        })
        gui:SetAttribute("kyri", true)

        local back = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(18, 16, 20),
            BackgroundTransparency = 1,
            Parent = gui
        })

        local wash = make("ImageLabel", {
            Size = UDim2.fromScale(7, 7),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "",
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Crop,
            Parent = back
        })

        local wash2 = make("ImageLabel", {
            Size = UDim2.fromScale(12, 12),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "",
            ImageTransparency = 1,
            Rotation = 180,
            ScaleType = Enum.ScaleType.Crop,
            Parent = back
        })
        local wash2_g = make("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(0.5, 0.75),
                NumberSequenceKeypoint.new(1, 0.15)
            }),
            Rotation = -40,
            Parent = wash2
        })

        local vign = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(8, 7, 10),
            BackgroundTransparency = 1,
            Parent = back
        })
        make("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(0.5, 0.82),
                NumberSequenceKeypoint.new(1, 0.3)
            }),
            Rotation = 90,
            Parent = vign
        })

        local stage = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Active = true,
            Parent = gui
        })

        local card = make("Frame", {
            Size = UDim2.fromOffset(430, 560),
            BackgroundColor3 = Color3.fromRGB(16, 15, 18),
            BackgroundTransparency = 1,
            Active = true,
            Parent = stage
        })
        local card_c = make("UICorner", {CornerRadius = UDim.new(0, 14), Parent = card})
        local card_s = make("UIStroke", {
            Color = Color3.new(1, 1, 1),
            Thickness = 1,
            Transparency = 1,
            Parent = card
        })

        local pad = make("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Parent = card
        })

        local art = make("ImageLabel", {
            Size = UDim2.new(1, 0, 0, 430),
            BackgroundColor3 = Color3.fromRGB(26, 26, 30),
            Image = "",
            ScaleType = Enum.ScaleType.Crop,
            Active = true,
            Parent = pad
        })
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = art})

        local veil = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Parent = art
        })
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = veil})
        make("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.75),
                NumberSequenceKeypoint.new(0.45, 1),
                NumberSequenceKeypoint.new(1, 0.4)
            }),
            Rotation = 90,
            Parent = veil
        })

        local skin = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = art
        })

        local heart = make("ImageButton", {
            Size = UDim2.fromOffset(170, 170),
            Position = UDim2.new(0.5, -85, 0.5, -95),
            BackgroundTransparency = 1,
            Image = ico("heart") or "",
            ImageColor3 = Color3.new(1, 1, 1),
            ImageTransparency = 0.12,
            AutoButtonColor = false,
            Parent = skin
        })
        tip(heart, "save to liked songs")

        local vtrack = make("Frame", {
            Size = UDim2.fromOffset(7, 180),
            Position = UDim2.new(1, -26, 0.5, -120),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.68,
            Parent = skin
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = vtrack})
        local vfill = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 1),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = Color3.new(1, 1, 1),
            Parent = vtrack
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = vfill})
        local vhit = make("TextButton", {
            Size = UDim2.new(1, 18, 1, 12),
            Position = UDim2.fromOffset(-9, -6),
            BackgroundTransparency = 1,
            Text = "",
            Parent = vtrack
        })
        tip(vhit, "volume")
        local vicon = make("ImageLabel", {
            Size = UDim2.fromOffset(15, 15),
            Position = UDim2.new(0, -4, 1, 10),
            BackgroundTransparency = 1,
            Image = ico("volume-2") or "",
            ImageColor3 = Color3.new(1, 1, 1),
            ImageTransparency = 0.2,
            Parent = vtrack
        })

        local trow = make("Frame", {
            Size = UDim2.new(1, 0, 0, 44),
            Position = UDim2.new(0, 0, 1, -58),
            BackgroundTransparency = 1,
            Parent = skin
        })
        local trow_l = make("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 22),
            Parent = trow
        })

        local function tbtn(icon, size, label, ord)
            local b = make("ImageButton", {
                Size = UDim2.fromOffset(size, size),
                BackgroundTransparency = 1,
                Image = ico(icon) or "",
                ImageColor3 = Color3.new(1, 1, 1),
                ImageTransparency = 0.15,
                AutoButtonColor = false,
                LayoutOrder = ord,
                Parent = trow
            })
            tip(b, label)
            return b
        end

        local shufb = tbtn("shuffle", 22, "shuffle", 1)
        local prevb = tbtn("rewind", 26, "previous", 2)
        local playb = tbtn("pause", 36, "play or pause", 3)
        local nextb = tbtn("fast-forward", 26, "next", 4)
        local loopb = tbtn("repeat", 22, "repeat", 5)

        local srow = make("Frame", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 444),
            BackgroundTransparency = 1,
            Parent = pad
        })
        local t_left = make("TextLabel", {
            Size = UDim2.fromOffset(42, 20),
            BackgroundTransparency = 1,
            Text = "0:00",
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.3,
            Font = fm,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = srow
        })
        local t_right = make("TextLabel", {
            Size = UDim2.fromOffset(42, 20),
            Position = UDim2.new(1, -42, 0, 0),
            BackgroundTransparency = 1,
            Text = "0:00",
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.3,
            Font = fm,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = srow
        })
        local strack = make("Frame", {
            Size = UDim2.new(1, -108, 0, 6),
            Position = UDim2.fromOffset(54, 7),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.7,
            Parent = srow
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = strack})
        local sfill = make("Frame", {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = Color3.new(1, 1, 1),
            Parent = strack
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sfill})
        local shit = make("TextButton", {
            Size = UDim2.new(1, 0, 1, 18),
            Position = UDim2.fromOffset(0, -9),
            BackgroundTransparency = 1,
            Text = "",
            Parent = strack
        })
        tip(shit, "seek")

        local c_title = make("TextLabel", {
            Size = UDim2.new(1, -24, 0, 34),
            Position = UDim2.fromOffset(12, 476),
            BackgroundTransparency = 1,
            Text = "nothing playing",
            TextColor3 = Color3.new(1, 1, 1),
            Font = fb,
            TextSize = 25,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = pad
        })
        local c_artist = make("TextLabel", {
            Size = UDim2.new(1, -24, 0, 22),
            Position = UDim2.fromOffset(12, 510),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.35,
            Font = fr,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = pad
        })

        local tool = make("Frame", {
            Size = UDim2.fromOffset(276, 48),
            Position = UDim2.new(0.5, -138, 0, 14),
            BackgroundColor3 = Color3.fromRGB(26, 24, 28),
            BackgroundTransparency = 0.22,
            ZIndex = 8,
            Parent = pad
        })
        make("UICorner", {CornerRadius = UDim.new(0, 24), Parent = tool})
        make("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 1, Transparency = 0.86, Parent = tool})
        make("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = tool
        })

        local function toolbtn(icon, label, ord)
            local b = make("ImageButton", {
                Size = UDim2.fromOffset(36, 36),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Image = "",
                AutoButtonColor = false,
                ZIndex = 9,
                LayoutOrder = ord,
                Parent = tool
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = b})
            local im = make("ImageLabel", {
                Size = UDim2.fromOffset(17, 17),
                Position = UDim2.new(0.5, -8, 0.5, -8),
                BackgroundTransparency = 1,
                Image = ico(icon) or "",
                ImageColor3 = Color3.new(1, 1, 1),
                ZIndex = 10,
                Parent = b
            })
            tip(b, label)
            b.MouseEnter:Connect(function()
                tw:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0.82}):Play()
            end)
            b.MouseLeave:Connect(function()
                tw:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
            end)
            return b, im
        end

        local compactb, compacti = toolbtn("square", "compact mode", 1)
        local swapb = toolbtn("arrow-left-right", "swap side", 2)
        local cineb, cinei = toolbtn("maximize", "cinema view", 3)
        local queueb = toolbtn("list", "queue", 4)
        local setb = toolbtn("settings", "settings", 5)
        local closeb = toolbtn("x", "close", 6)

        local lyrbg = make("Frame", {
            Size = UDim2.fromOffset(420, 526),
            BackgroundColor3 = Color3.fromRGB(16, 15, 18),
            BackgroundTransparency = 0.08,
            Visible = false,
            Active = true,
            Parent = stage
        })
        make("UICorner", {CornerRadius = UDim.new(0, 14), Parent = lyrbg})
        local lyrbg_s = make("UIStroke", {
            Color = Color3.new(1, 1, 1),
            Thickness = 1,
            Transparency = 0.9,
            Parent = lyrbg
        })

        local clip = make("Frame", {
            Size = UDim2.fromOffset(600, 600),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Visible = false,
            Active = true,
            Parent = stage
        })
        local reel = make("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Parent = clip
        })

        local foot = make("Frame", {
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundTransparency = 1,
            Parent = reel
        })
        local f_writers = make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.34,
            Font = fm,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = foot
        })
        local f_credit = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.fromOffset(0, 20),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.52,
            Font = fr,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = foot
        })
        tip(f_credit, "copy the credit links")

        local DISCORD = copts.discord or "https://discord.gg/y52Npnsp4G"

        local blank = make("Frame", {
            Size = UDim2.fromOffset(540, 226),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = clip
        })
        local b_head = make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Text = "No lyrics for this song yet",
            TextColor3 = Color3.new(1, 1, 1),
            Font = fb,
            TextSize = 27,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = blank
        })
        local b_body = make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 72),
            Position = UDim2.fromOffset(0, 44),
            BackgroundTransparency = 1,
            Text = "We could not find lyrics for this track in any of our sources. New lyrics are"
                .. " added all the time, so check back later. If you know this song has lyrics,"
                .. " copy the details and send them over so we can look into it.",
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.38,
            Font = fr,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = blank
        })

        local brow = make("Frame", {
            Size = UDim2.new(1, 0, 0, 38),
            Position = UDim2.fromOffset(0, 130),
            BackgroundTransparency = 1,
            Parent = blank
        })
        make("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = brow
        })

        local function pill(text, icon, ord, cb)
            local b = make("TextButton", {
                Size = UDim2.fromOffset(#text * 7 + 52, 38),
                LayoutOrder = ord,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.88,
                Text = "",
                AutoButtonColor = false,
                Parent = brow
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = b})
            make("ImageLabel", {
                Size = UDim2.fromOffset(15, 15),
                Position = UDim2.fromOffset(16, 11),
                BackgroundTransparency = 1,
                Image = ico(icon) or "",
                ImageColor3 = Color3.new(1, 1, 1),
                Parent = b
            })
            make("TextLabel", {
                Size = UDim2.new(1, -38, 1, 0),
                Position = UDim2.fromOffset(38, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.new(1, 1, 1),
                Font = fm,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = b
            })
            b.MouseEnter:Connect(function()
                tw:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0.78}):Play()
            end)
            b.MouseLeave:Connect(function()
                tw:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0.88}):Play()
            end)
            b.MouseButton1Click:Connect(cb)
            return b
        end

        local copyb = pill("Copy details", "copy", 1, function()
            local t = sp.track or {}
            local bits = {
                "track: " .. tostring(t.name),
                "artist: " .. sp:artists(),
                "album: " .. tostring(t.album and t.album.name),
                "spotify id: " .. tostring(t.id),
                "isrc: " .. tostring(t.external_ids and t.external_ids.isrc),
                "duration: " .. fmt_time(math.floor((t.duration_ms or 0) / 1000)),
                "tried: spicy lyrics, lrc.red, lrclib"
            }
            kyri.copybox(table.concat(bits, "\n"), "track details")
        end)
        tip(copyb, "copy what the providers were asked for")

        local helpb = pill("Get help on Discord", "message-circle", 2, function()
            kyri.copybox(DISCORD, "discord invite")
        end)
        tip(helpb, DISCORD)

        local b_code = make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.fromOffset(0, 180),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.66,
            Font = fr,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = blank
        })

        local catch = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            Visible = false,
            AutoButtonColor = false,
            ZIndex = 38,
            Parent = stage
        })

        local pop = make("Frame", {
            Size = UDim2.fromOffset(250, 0),
            BackgroundColor3 = Color3.fromRGB(24, 22, 26),
            BackgroundTransparency = 0.08,
            Visible = false,
            Active = true,
            ClipsDescendants = true,
            ZIndex = 40,
            Parent = stage
        })
        make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = pop})
        make("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 1, Transparency = 0.86, Parent = pop})
        local poplist = make("Frame", {
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.fromOffset(8, 8),
            BackgroundTransparency = 1,
            ZIndex = 41,
            Parent = pop
        })
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            Parent = poplist
        })

        local function popclear()
            for i,v in pairs(poplist:GetChildren()) do
                if not v:IsA("UIListLayout") then v:Destroy() end
            end
        end

        local pop_open = false

        local function pophide()
            if not pop_open then return end
            pop_open = false
            catch.Visible = false
            tw:Create(pop, TweenInfo.new(0.14), {Size = UDim2.fromOffset(250, 0)}):Play()
            task.delay(0.15, function()
                if not pop_open then pop.Visible = false end
            end)
        end

        local function popshow(h)
            local vp = gui.AbsoluteSize
            local bx = tool.AbsolutePosition.X + tool.AbsoluteSize.X / 2 - 125
            local below = tool.AbsolutePosition.Y + tool.AbsoluteSize.Y + 8
            local y = below
            if below + h > vp.Y - 12 then
                y = math.max(tool.AbsolutePosition.Y - h - 8, 12)
            end
            pop.Position = UDim2.fromOffset(math.clamp(bx, 12, math.max(vp.X - 262, 12)), y)
            pop.Visible = true
            pop_open = true
            catch.Visible = true
            tw:Create(pop, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.fromOffset(250, h)}):Play()
        end

        catch.MouseButton1Click:Connect(pophide)

        local function poprow(text, cb, ord)
            local b = make("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Text = "   " .. text,
                TextColor3 = Color3.new(1, 1, 1),
                Font = fr,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 42,
                LayoutOrder = ord or 0,
                Parent = poplist
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = b})
            b.MouseEnter:Connect(function()
                tw:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0.88}):Play()
            end)
            b.MouseLeave:Connect(function()
                tw:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
            end)
            if cb then b.MouseButton1Click:Connect(cb) end
            return b
        end

        local cued, lines, built_w, built_sz = nil, {}, 0, 0
        local active = 0

        local function atoms_of(ln)
            local list = {}
            if ln.words then
                for i,w in pairs(ln.words) do
                    local s = ln.text:sub((w.at or 0) + 1, w.to or 0)
                    if s:gsub("%s", "") ~= "" then
                        list[#list + 1] = {
                            s = s,
                            t = w.t,
                            gap = ln.text:sub((w.to or 0) + 1, (w.to or 0) + 1) == " "
                        }
                    end
                end
            end
            if #list == 0 then
                for word in ln.text:gmatch("%S+") do
                    list[#list + 1] = {s = word, t = nil, gap = true}
                end
            end
            return list
        end

        local function tsize()
            if mode ~= "cinema" then return 26 end
            return compact and 30 or 40
        end

        local function build()
            for i,v in pairs(reel:GetChildren()) do
                if v ~= foot then v:Destroy() end
            end
            lines = {}
            active = 0

            local w = clip.AbsoluteSize.X
            if w < 40 then w = 600 end
            built_w = w

            local sz = tsize()
            built_sz = sz

            if not cued then
                foot.Position = UDim2.fromOffset(0, 0)
                reel.Size = UDim2.new(1, 0, 0, 60)
                reel.Position = UDim2.fromOffset(0, 0)
                reel.Visible = not blank.Visible
                return
            end
            blank.Visible = false
            reel.Visible = true

            local lh = math.floor(sz * 1.2)
            local y = 0

            for i,ln in pairs(cued) do
                local list = atoms_of(ln)
                if #list > 0 then
                    local f = make("Frame", {
                        Size = UDim2.new(1, 0, 0, lh),
                        Position = UDim2.fromOffset(0, y),
                        BackgroundTransparency = 1,
                        Parent = reel
                    })

                    local x, rows = 0, 1
                    local parts = {}
                    local spw = ts:GetTextSize(" ", sz, fb, Vector2.new(9999, 9999)).X

                    for j,a in pairs(list) do
                        local aw = ts:GetTextSize(a.s, sz, fb, Vector2.new(9999, 9999)).X
                        if x > 0 and x + aw > w then
                            x = 0
                            rows = rows + 1
                        end
                        local t = make("TextLabel", {
                            Size = UDim2.fromOffset(aw + 2, lh),
                            Position = UDim2.fromOffset(x, (rows - 1) * lh),
                            BackgroundTransparency = 1,
                            Text = a.s,
                            TextColor3 = Color3.new(1, 1, 1),
                            TextTransparency = 0.74,
                            Font = fb,
                            TextSize = sz,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = f
                        })
                        parts[#parts + 1] = {o = t, t = a.t}
                        x = x + aw + (a.gap and spw or 0)
                    end

                    f.Size = UDim2.new(1, 0, 0, rows * lh)
                    lines[#lines + 1] = {frame = f, parts = parts, t = ln.t, y = y}
                    y = y + rows * lh + math.floor(sz * 0.34)
                end
            end

            foot.Position = UDim2.fromOffset(0, y + 16)
            reel.Size = UDim2.new(1, 0, 0, y + 78)
        end

        local function paint_line(i, now)
            local L = lines[i]
            if not L then return end
            local far = math.abs(i - active)
            local base = i == active and 0 or (far == 1 and 0.48 or far == 2 and 0.64 or 0.76)

            for j,p in pairs(L.parts) do
                local want = base
                if i == active and p.t then
                    want = now >= p.t and 0 or 0.54
                end
                if math.abs(p.o.TextTransparency - want) > 0.01 then
                    tw:Create(p.o, TweenInfo.new(0.22), {TextTransparency = want}):Play()
                end
            end
        end

        local function scroll_to(i)
            local L = lines[i]
            if not L then return end
            local h = clip.AbsoluteSize.Y
            local want = -L.y + h * 0.36
            local floor = math.min(-(reel.Size.Y.Offset - h + 20), 0)
            want = math.clamp(want, floor, h * 0.36)
            tw:Create(reel, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Position = UDim2.fromOffset(0, want)}):Play()
        end

        local function rebuild_if_needed()
            if math.abs(clip.AbsoluteSize.X - built_w) > 4 or tsize() ~= built_sz then
                build()
                if active > 0 then scroll_to(active) end
            end
        end

        local function place(anim)
            local vp = gui.AbsoluteSize
            if vp.X < 40 then return end

            local cine = mode == "cinema"
            local cw = compact and 250 or (cine and 360 or 430)
            local ah = cw - (cine and 0 or 24)
            local inset = cine and 0 or 12
            local edge = compact and 40 or 64

            local ch = ah + (cine and 108 or 120)
            local gap = 14
            local lwn = compact and 280 or 420
            if not cine then
                local room = vp.X - cw - edge * 2 - gap
                if room < lwn then lwn = math.max(room, 200) end
            end

            local cx, cy, lx
            cy = math.floor((vp.Y - ch) / 2)

            if cine then
                cx = side == "left" and edge or (vp.X - cw - edge)
            else
                local total = cw + gap + lwn
                local gx = side == "left" and edge or math.max(vp.X - total - edge, edge)
                cx = side == "left" and gx or (gx + lwn + gap)
                lx = side == "left" and (gx + cw + gap) or gx
            end

            local goal_card = {
                Size = UDim2.fromOffset(cw, ch),
                Position = UDim2.fromOffset(cx, cy),
                BackgroundTransparency = cine and 1 or 0.08
            }
            if anim then
                tw:Create(card, EASE, goal_card):Play()
            else
                for k,v in pairs(goal_card) do card[k] = v end
            end
            tw:Create(card_s, FADE, {Transparency = cine and 1 or 0.9}):Play()

            pad.Size = UDim2.new(1, -inset * 2, 1, -inset * 2)
            pad.Position = UDim2.fromOffset(inset, inset)

            art.Size = UDim2.new(1, 0, 0, ah)
            srow.Position = UDim2.fromOffset(0, ah + 14)
            c_title.Position = UDim2.fromOffset(12, ah + 42)
            c_artist.Position = UDim2.fromOffset(12, ah + 76)
            c_title.TextSize = compact and 19 or (cine and 23 or 25)
            c_artist.TextSize = compact and 12 or 15

            local hs_ = math.floor(ah * 0.38)
            heart.Size = UDim2.fromOffset(hs_, hs_)
            heart.Position = UDim2.new(0.5, -math.floor(hs_ / 2), 0.5, -math.floor(hs_ * 0.58))

            vtrack.Size = UDim2.fromOffset(7, math.floor(ah * 0.4))
            vtrack.Position = UDim2.new(1, -24, 0.5, -math.floor(ah * 0.27))

            trow.Position = UDim2.new(0, 0, 1, compact and -42 or -56)
            trow_l.Padding = UDim.new(0, compact and 14 or 22)
            playb.Size = UDim2.fromOffset(compact and 28 or 36, compact and 28 or 36)
            prevb.Size = UDim2.fromOffset(compact and 21 or 26, compact and 21 or 26)
            nextb.Size = UDim2.fromOffset(compact and 21 or 26, compact and 21 or 26)
            shufb.Size = UDim2.fromOffset(compact and 18 or 22, compact and 18 or 22)
            loopb.Size = UDim2.fromOffset(compact and 18 or 22, compact and 18 or 22)

            local tw_ = compact and 240 or 276
            tool.Size = UDim2.fromOffset(tw_, compact and 42 or 48)
            tool.Position = UDim2.new(0.5, -math.floor(tw_ / 2), 0, compact and 8 or 12)

            clip.Visible = true
            vign.Visible = cine
            wash.Visible = cine
            wash2.Visible = cine
            lyrbg.Visible = not cine

            local goal_clip
            if cine then
                local lpad = compact and 54 or 78
                local clx = side == "left" and (cx + cw + lpad) or edge
                local lw = vp.X - cw - edge * 2 - lpad
                if lw < 260 then lw = 260 end
                goal_clip = {
                    Size = UDim2.fromOffset(lw, math.floor(vp.Y * 0.8)),
                    Position = UDim2.fromOffset(clx, math.floor(vp.Y * 0.1))
                }
            else
                local inn = compact and 14 or 20
                goal_clip = {
                    Size = UDim2.fromOffset(lwn - inn * 2, ch - inn * 2),
                    Position = UDim2.fromOffset(lx + inn, cy + inn)
                }
                local goal_bg = {
                    Size = UDim2.fromOffset(lwn, ch),
                    Position = UDim2.fromOffset(lx, cy)
                }
                if anim then
                    tw:Create(lyrbg, EASE, goal_bg):Play()
                else
                    for k,v in pairs(goal_bg) do lyrbg[k] = v end
                end
            end
            if anim then
                tw:Create(clip, EASE, goal_clip):Play()
            else
                for k,v in pairs(goal_clip) do clip[k] = v end
            end

            blank.Size = UDim2.fromOffset(math.min(clip.AbsoluteSize.X - 20, 540), 226)
            cinei.Image = ico(cine and "minimize" or "maximize") or cinei.Image
            compacti.Image = ico(compact and "maximize-2" or "square") or compacti.Image

            tw:Create(back, FADE, {BackgroundTransparency = cine and 0 or 1}):Play()
            tw:Create(wash, FADE, {ImageTransparency = (cine and wash.Image ~= "") and 0.28 or 1}):Play()
            tw:Create(wash2, FADE, {ImageTransparency = (cine and wash2.Image ~= "") and 0.5 or 1}):Play()
            tw:Create(vign, FADE, {BackgroundTransparency = cine and 0 or 1}):Play()

            task.delay(anim and 0.46 or 0.06, rebuild_if_needed)
        end

        local idle, hidden = os.clock(), false

        local function wake()
            idle = os.clock()
            if not hidden then return end
            hidden = false
            tw:Create(tool, FADE, {BackgroundTransparency = 0.22}):Play()
            for i,v in pairs(tool:GetDescendants()) do
                if v:IsA("ImageLabel") then tw:Create(v, FADE, {ImageTransparency = 0}):Play() end
                if v:IsA("UIStroke") then tw:Create(v, FADE, {Transparency = 0.86}):Play() end
            end
            for i,v in pairs({shufb, prevb, playb, nextb, loopb}) do
                tw:Create(v, FADE, {ImageTransparency = 0.15}):Play()
            end
            tw:Create(heart, FADE, {ImageTransparency = 0.12}):Play()
            tw:Create(vtrack, FADE, {BackgroundTransparency = 0.68}):Play()
            tw:Create(vfill, FADE, {BackgroundTransparency = 0}):Play()
            tw:Create(vicon, FADE, {ImageTransparency = 0.2}):Play()
            tw:Create(veil, FADE, {BackgroundTransparency = 1}):Play()
        end

        local function doze()
            if hidden or mode ~= "cinema" then return end
            hidden = true
            local slow = TweenInfo.new(0.5)
            tw:Create(tool, slow, {BackgroundTransparency = 1}):Play()
            for i,v in pairs(tool:GetDescendants()) do
                if v:IsA("ImageLabel") then tw:Create(v, slow, {ImageTransparency = 1}):Play() end
                if v:IsA("UIStroke") then tw:Create(v, slow, {Transparency = 1}):Play() end
            end
            for i,v in pairs({shufb, prevb, playb, nextb, loopb}) do
                tw:Create(v, slow, {ImageTransparency = 1}):Play()
            end
            tw:Create(heart, slow, {ImageTransparency = 1}):Play()
            tw:Create(vtrack, slow, {BackgroundTransparency = 1}):Play()
            tw:Create(vfill, slow, {BackgroundTransparency = 1}):Play()
            tw:Create(vicon, slow, {ImageTransparency = 1}):Play()
            tw:Create(veil, slow, {BackgroundTransparency = 1}):Play()
        end

        kyri.svc.inp.InputChanged:Connect(function(i)
            if gui.Enabled and i.UserInputType == Enum.UserInputType.MouseMovement then wake() end
        end)
        kyri.svc.inp.InputBegan:Connect(function()
            if gui.Enabled then wake() end
        end)

        heart.MouseButton1Click:Connect(function()
            sp:like()
            local s = heart.Size.X.Offset
            tw:Create(heart, TweenInfo.new(0.1), {Size = UDim2.fromOffset(s + 18, s + 18)}):Play()
            task.delay(0.12, function()
                tw:Create(heart, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Size = UDim2.fromOffset(s, s)}):Play()
            end)
        end)

        compactb.MouseButton1Click:Connect(function()
            compact = not compact
            pophide()
            place(true)
        end)
        swapb.MouseButton1Click:Connect(function()
            side = side == "left" and "right" or "left"
            pophide()
            place(true)
        end)
        cineb.MouseButton1Click:Connect(function()
            mode = mode == "cinema" and "nowbar" or "cinema"
            wake()
            pophide()
            place(true)
        end)

        queueb.MouseButton1Click:Connect(function()
            if pop_open then return pophide() end
            popclear()
            poprow("loading queue", nil, 0)
            popshow(50)
            task.spawn(function()
                local r = api("GET", "/me/player/queue")
                local d
                if r and r.StatusCode == 200 then
                    local ok, j = pcall(function() return hs:JSONDecode(r.Body) end)
                    if ok then d = j end
                end
                if not pop_open then return end
                popclear()
                local q = d and d.queue or {}
                if #q == 0 then
                    poprow("queue is empty", nil, 1)
                else
                    for i,t in pairs(q) do
                        if i > 8 then break end
                        poprow((t.name or ""):sub(1, 30), function()
                            sp:playuri(t.uri)
                            pophide()
                        end, i)
                    end
                end
                popshow(math.min(math.max(#q, 1), 8) * 34 + 16)
            end)
        end)

        setb.MouseButton1Click:Connect(function()
            if pop_open then return pophide() end
            popclear()
            local srcs = {{"auto", nil}, {"spicy", "spicy"}, {"lrc.red", "lrc.red"}, {"lrclib", "lrclib"}}
            for i,v in pairs(srcs) do
                poprow(v[1] .. ((sp.lyric_source == v[2]) and "   o" or ""), function()
                    sp.lyric_source = v[2]
                    sp.lyric_rev = (sp.lyric_rev or 0) + 1
                    pophide()
                end, i)
            end
            poprow("nudge lyrics  -0.5s", function() sp:nudge(-0.5) end, 10)
            poprow("nudge lyrics  +0.5s", function() sp:nudge(0.5) end, 11)
            popshow(6 * 34 + 16)
        end)

        f_credit.MouseButton1Click:Connect(function()
            if cin.credit_full then kyri.copybox(cin.credit_full, "lyric credit") end
        end)

        playb.MouseButton1Click:Connect(function()
            sp:toggle()
            playb.Image = ico(sp.playing and "pause" or "play") or playb.Image
        end)
        prevb.MouseButton1Click:Connect(function() sp:prev() end)
        nextb.MouseButton1Click:Connect(function() sp:next() end)
        shufb.MouseButton1Click:Connect(function()
            sp:setshuffle(not sp.shuffle)
        end)
        loopb.MouseButton1Click:Connect(function()
            local nx = sp.loop == "off" and "context" or sp.loop == "context" and "track" or "off"
            sp:setloop(nx)
            loopb.Image = ico(nx == "track" and "repeat-1" or "repeat") or loopb.Image
        end)

        local seeking = false
        do
            local function to(x)
                local p = math.clamp((x - strack.AbsolutePosition.X) / math.max(strack.AbsoluteSize.X, 1), 0, 1)
                sfill.Size = UDim2.fromScale(p, 1)
                return p
            end
            shit.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    seeking = true
                    to(i.Position.X)
                end
            end)
            kyri.svc.inp.InputChanged:Connect(function(i)
                if not seeking then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    to(i.Position.X)
                end
            end)
            kyri.svc.inp.InputEnded:Connect(function(i)
                if not seeking then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    seeking = false
                    sp:seek(to(i.Position.X) * 100)
                end
            end)
        end

        do
            local vdrag = false
            local function to(y)
                local top = vtrack.AbsolutePosition.Y
                local h = math.max(vtrack.AbsoluteSize.Y, 1)
                local p = math.clamp(1 - (y - top) / h, 0, 1)
                vfill.Size = UDim2.fromScale(1, p)
                return math.floor(p * 100 + 0.5)
            end
            vhit.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    vdrag = true
                    to(i.Position.Y)
                end
            end)
            kyri.svc.inp.InputChanged:Connect(function(i)
                if not vdrag then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    to(i.Position.Y)
                end
            end)
            kyri.svc.inp.InputEnded:Connect(function(i)
                if not vdrag then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    vdrag = false
                    sp:volume(to(i.Position.Y))
                end
            end)
        end

        local shown_id = ""

        local function refresh_track()
            local t = sp.track
            if not t then return end
            c_title.Text = t.name or ""
            c_artist.Text = sp:artists()
            playb.Image = ico(sp.playing and "pause" or "play") or playb.Image
            if not hidden then
                shufb.ImageTransparency = sp.shuffle and 0 or 0.4
                loopb.ImageTransparency = (sp.loop and sp.loop ~= "off") and 0 or 0.4
            end

            if t.id ~= shown_id then
                shown_id = t.id
                local u = t.album and t.album.images and t.album.images[1] and t.album.images[1].url
                if u then
                    load_art(u, t.id, function(a)
                        if shown_id ~= t.id then return end
                        art.Image = a
                        wash.Image = a
                        wash2.Image = a
                        if gui.Enabled and mode == "cinema" then
                            tw:Create(wash, TweenInfo.new(0.6), {ImageTransparency = 0.28}):Play()
                            tw:Create(wash2, TweenInfo.new(0.6), {ImageTransparency = 0.5}):Play()
                        end
                    end)
                end
            end

            if sp.dur > 0 and not seeking then
                sfill.Size = UDim2.fromScale(math.clamp(sp.pos / sp.dur, 0, 1), 1)
            end
            t_left.Text = fmt_time(sp.pos)
            t_right.Text = fmt_time(sp.dur)
            if sp.vol_known then
                vfill.Size = UDim2.fromScale(1, sp.vol / 100)
                vicon.Image = ico(sp.vol == 0 and "volume-x" or sp.vol < 50 and "volume-1" or "volume-2") or vicon.Image
            end
        end

        hooks[#hooks + 1] = function()
            if gui.Enabled then pcall(refresh_track) end
        end

        gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() place(false) end)

        cin = {gui = gui, card = card, stage = stage}

        local alive_cin = true

        task.spawn(function()
            local for_id, for_rev
            while alive_cin and task.wait(0.07) do
                if not gui.Enabled then continue end

                if not hidden and os.clock() - idle > 3 and not pop_open then doze() end

                local drift = os.clock()
                wash.Rotation = math.sin(drift / 11) * 4
                wash2.Rotation = 180 + math.cos(drift / 14) * 5
                wash2_g.Rotation = -40 + math.cos(drift / 9) * 20

                if not sp.ready or not sp.track then continue end

                local id = sp.track.id or sp.track.name
                if id ~= for_id or sp.lyric_rev ~= for_rev then
                    for_id = id
                    for_rev = sp.lyric_rev
                    cued = nil
                    cin.credit_full = nil
                    f_writers.Text = ""
                    f_credit.Text = "looking for lyrics"
                    build()
                    task.spawn(function()
                        local got = sp:lyrics()
                        if not sp.track or (sp.track.id or sp.track.name) ~= for_id then return end
                        cued = got and got.synced or nil
                        if got then
                            cin.credit_full = got.credit_full
                            local w = got.writers
                            if type(w) == "table" then w = table.concat(w, ", ") end
                            f_writers.Text = (type(w) == "string" and w ~= "") and ("Written by " .. w) or ""
                            local kind = got.source == "spicy_lyrics" and "Community lyrics" or
                                (got.words and "Word synced" or "Line synced")
                            f_credit.Text = cued and (kind .. "  -  " .. tostring(got.credit)) or ""
                        else
                            f_credit.Text = ""
                        end

                        if not cued then
                            local net = sp.lyric_error == "network"
                            b_head.Text = net and "Could not reach the lyric servers"
                                or (got and got.plain) and "Only plain lyrics for this song"
                                or "No lyrics for this song yet"
                            b_body.Text = net
                                and ("A provider did not answer, so this is not a miss. It will try"
                                    .. " again on its own, or skip away and back to retry now.")
                                or (got and got.plain)
                                and ("This track has lyrics but nobody has timed them yet, so there is"
                                    .. " nothing to follow along to. Copy the details and send them over"
                                    .. " if you want it synced.")
                                or ("We could not find lyrics for this track in any of our sources. New"
                                    .. " lyrics are added all the time, so check back later. If you know"
                                    .. " this song has lyrics, copy the details and send them over so we"
                                    .. " can look into it.")
                            b_code.Text = net and "Code: provider-unreachable"
                                or (got and got.plain) and "Code: lyrics-not-synced"
                                or "Code: lyrics-not-found (404)"
                            blank.Visible = true
                            reel.Visible = false
                        end
                        build()
                        active = 0
                    end)
                end

                if not cued then continue end

                local now = sp:now()
                local k = 0
                for i,L in pairs(lines) do
                    if L.t <= now then k = i else break end
                end
                if k == 0 then k = 1 end

                if k ~= active then
                    local was = active
                    active = k
                    scroll_to(k)
                    for i = math.max(k - 3, 1), math.min(k + 3, #lines) do paint_line(i, now) end
                    if was > 0 then
                        for i = math.max(was - 3, 1), math.min(was + 3, #lines) do paint_line(i, now) end
                    end
                else
                    paint_line(k, now)
                end
            end
        end)

        function cin:show()
            gui.Enabled = true
            wake()
            place(false)
            card.Size = UDim2.fromOffset(card.Size.X.Offset * 0.94, card.Size.Y.Offset * 0.94)
            place(true)
            pcall(refresh_track)
            task.spawn(function() sp:sync() end)
        end

        function cin:hide()
            pophide()
            tw:Create(back, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            tw:Create(card, TweenInfo.new(0.2), {
                Size = UDim2.fromOffset(card.Size.X.Offset * 0.94, card.Size.Y.Offset * 0.94),
                BackgroundTransparency = 1
            }):Play()
            task.delay(0.21, function()
                if not gui then return end
                gui.Enabled = false
            end)
        end

        function cin:toggle()
            if gui.Enabled then cin:hide() else cin:show() end
        end

        function cin:mode(m)
            mode = m or mode
            place(true)
        end

        function cin:side(s)
            side = s or side
            place(true)
        end

        function cin:compact(on)
            compact = on == true
            place(true)
        end

        function cin:destroy()
            alive_cin = false
            pcall(function() gui:Destroy() end)
            cin = nil
        end

        closeb.MouseButton1Click:Connect(function() cin:hide() end)

        place(false)
        return cin
    end

    function sp:destroy()
        alive = false
        if cin then pcall(function() cin:destroy() end) end
        if dk then pcall(function() dk:destroy() end) end
        if isl and own_island then pcall(function() isl:destroy() end) end
    end

    dirs()
    if load_tokens() then
        sp.ready = true
        task.spawn(new_token)
    end

    own_island = opts.island ~= false
    if opts.island ~= true and opts.window and opts.window.isl then
        isl = opts.window.isl
        own_island = false
    end

    if own_island and not opts.window and opts.tabs == false and opts.splash ~= false then
        kyri.splash({Splash = true, Logo = opts.logo, SplashTime = opts.splash_time or 1.2})
    end

    if own_island then
        isl = kyri.island({
            id = "spotify",
            font = opts.font,
            font_bold = opts.font_bold,
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

        if opts.desktop ~= false then
            local ob = isl:button("music", function()
                sp:desktop(opts.desktop_options):toggle()
            end, "open spotify")
            task.spawn(function()
                local a = spot_logo()
                if a and ob.img then
                    ob.img.Image = a
                    ob.img.ImageColor3 = Color3.new(1, 1, 1)
                    ob.img.Size = UDim2.fromOffset(18, 18)
                    ob.img.Position = UDim2.new(0.5, -9, 0.5, -9)
                end
            end)
        end

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

        local results = isl:list(opts.island_results or 5)
        local finder
        local pasting = false
        local standalone = not opts.window and opts.tabs == false

        local function show_tracks(items)
            local rows = {}
            for i,tr in pairs(items) do
                local a = {}
                for j,v in pairs(tr.artists or {}) do a[#a + 1] = v.name end
                local cover
                if tr.album and tr.album.images and #tr.album.images > 0 then
                    cover = tr.album.images[#tr.album.images].url
                end
                rows[#rows + 1] = {
                    text = tr.name .. "  -  " .. table.concat(a, ", "),
                    icon = cover,
                    cb = function()
                        if sp:playuri(tr.uri, tr.album and tr.album.uri) then
                            isl:notify(tr.name, 2.5)
                        end
                        results:clear()
                    end
                }
            end
            results:set(rows)
        end

        local function show_lists(items)
            local rows = {}
            for i,pl in pairs(items) do
                local cover
                if pl.images and #pl.images > 0 then cover = pl.images[#pl.images].url end
                local owner = (pl.owner and pl.owner.display_name) or ""
                rows[#rows + 1] = {
                    text = pl.name .. (owner ~= "" and ("  -  " .. owner) or ""),
                    icon = cover,
                    cb = function()
                        if sp:playcontext(pl.uri) then isl:notify(pl.name, 2.5) end
                        results:clear()
                    end
                }
            end
            results:set(rows)
        end

        local function show_devices()
            local rows = {}
            for i,d in pairs(sp:devices()) do
                rows[#rows + 1] = {
                    text = d.name .. (d.is_active and "   playing here" or "   " .. (d.type or "")),
                    icon = d.is_active and "volume-2" or "monitor",
                    cb = function()
                        if sp:transfer(d.id) then isl:notify("moved to " .. d.name, 2.5) end
                        results:clear()
                    end
                }
            end
            if #rows == 0 then
                isl:notify("no devices, open spotify somewhere", 3)
            end
            results:set(rows)
        end

        finder = isl:input("search spotify", function(q, kind)
            if pasting then
                pasting = false
                finder:set("")
                finder:show(false)
                local ok = sp:submit(q)
                if ok then
                    results:clear()
                    isl:notify("connected to spotify", 3)
                    sp:sync()
                else
                    isl:notify("that url did not work, copy it again", 4)
                end
                return
            end

            if kind == "device" then
                show_devices()
                return
            end

            if q == "" then
                if kind == "playlist" then
                    show_lists(sp:playlists(opts.island_results or 5))
                else
                    results:clear()
                end
                return
            end

            local items = sp:search(q, opts.island_results or 5, kind)
            if #items == 0 then
                isl:notify("no results", 2)
                results:clear()
                return
            end
            if kind == "playlist" then show_lists(items) else show_tracks(items) end
        end, {{"track", "songs"}, {"playlist", "lists"}, {"device", "on"}})

        isl:button("search", function()
            local on = not finder:visible()
            finder:show(on)
            if not on then results:clear() end
            if on then finder:focus() end
        end, "search")

        local function auth_rows()
            results:set({
                {
                    text = "1. copy the spotify sign in url",
                    icon = "link",
                    cb = function()
                        local u = sp:authurl()
                        if setclipboard then
                            pcall(setclipboard, u)
                            isl:notify("copied, approve it in your browser", 4)
                        else
                            kyri.copybox(u, "spotify sign in url")
                        end
                    end
                },
                {
                    text = "2. paste the url you land on",
                    icon = "clipboard",
                    cb = function()
                        pasting = true
                        finder:set("")
                        finder:show(true)
                        finder:focus()
                        isl:notify("paste the whole url, then press enter", 5)
                    end
                }
            })
        end

        if standalone and not sp.ready then
            auth_rows()
            isl:notify("tap to open, then sign in", 5)
        end

        local words = opts.lyrics ~= false and isl:lyrics() or nil
        local cued, at_pos, at_clock = nil, 0, os.clock()

        if words then
            local base_sync = sp.sync
            sp.sync = function(self, ...)
                local r = base_sync(self, ...)
                at_pos, at_clock = sp.pos or 0, os.clock()
                return r
            end

            task.spawn(function()
                local for_id, for_rev
                while alive and task.wait(0.08) do
                    if not sp.ready or not sp.track then
                        words:show(false)
                    else
                        local id = sp.track.id or sp.track.name
                        if id ~= for_id or sp.lyric_rev ~= for_rev then
                            for_id = id
                            for_rev = sp.lyric_rev
                            cued = nil
                            words:show(false)
                            words:credit(nil)
                            task.spawn(function()
                                local got = sp:lyrics()
                                if sp.track and (sp.track.id or sp.track.name) == for_id then
                                    cued = got and got.synced or nil
                                    if cued then words:credit(got.credit, got.credit_full) end
                                end
                            end)
                        end

                        if cued then
                            local now = at_pos
                                + (sp.playing and (os.clock() - at_clock) or 0)
                                - (sp.lyric_offset or 0)

                            local k = 0
                            for i,ln in pairs(cued) do
                                if ln.t <= now then k = i else break end
                            end

                            if k > 0 then
                                local ln = cued[k]
                                if ln.words then
                                    words:line(ln.text, ln.words, now, for_id .. "#" .. k)
                                else
                                    local a = ln.t
                                    local b = cued[k + 1] and cued[k + 1].t or ln.e or (a + 4)
                                    local run = math.max(b - a, 0.25)
                                    words:set(ln.text, (now - a) / run, for_id .. "#" .. k)
                                end
                            else
                                words:set(cued[1] and cued[1].text or "", 0, for_id .. "#0")
                            end
                            words:show(true)
                        else
                            words:show(false)
                        end
                    end
                end
            end)
        end

        sp.finder = finder
        sp.island_results = results
        sp.words = words

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

        np:space()
        np:section("device")

        local dev_row = rnd()

        local function list_devices()
            for i,c in pairs(np.page:GetChildren()) do
                if c.Name == dev_row then c:Destroy() end
            end

            local found = sp:devices()
            if #found == 0 then
                local none = np:label("no devices, open spotify somewhere first")
                none.lbl.Name = dev_row
                return
            end

            for i,d in pairs(found) do
                local tag = d.name .. (d.is_active and "   playing here" or "")
                local b = np:button(tag, function()
                    if sp:transfer(d.id) then
                        w:notify("spotify", "moved to " .. d.name, 3, "check")
                        task.delay(0.8, list_devices)
                    end
                end, d.is_active and "volume-2" or "monitor")
                b.box.Name = dev_row
            end
        end

        np:button("find devices", list_devices, "refresh-cw")

        local srch = w:tab("Search", "search")
        srch:label("type a song name and press enter")

        local queue_mode = false
        srch:toggle("queue instead of play", false, function(v)
            queue_mode = v
        end, "sp_queue_mode")

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
                    local cover
                    if tr.album and tr.album.images and #tr.album.images > 0 then
                        cover = tr.album.images[#tr.album.images].url
                    end

                    local rb = srch:button(tr.name .. "  -  " .. table.concat(a, ", "), function()
                        if queue_mode then
                            if sp:queue(tr.uri) then
                                w:notify("queued", tr.name, 3, "list")
                            end
                        elseif sp:playuri(tr.uri) then
                            w:notify("playing", tr.name, 3)
                            if isl then isl:notify(tr.name, 2.5) end
                        end
                    end, cover)
                    rb.box.Name = "SpotifyResult"
                end
            end
        end)

        local at = w:tab("Auth", "key")
        at:section("connect spotify")
        at:paragraph("how to authenticate",
            "1. click 'copy auth url'\n2. open it in your browser and approve\n3. the page will fail to load - that is normal\n4. copy the whole url from the address bar\n5. paste it below and submit")

        local st_lbl
        at:button("copy auth url", function()
            if not setclipboard then
                kyri.copybox(sp:authurl(), "spotify auth url")
                return
            end
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
            lyrics = function(a)
                local n = tonumber(a[1])
                if n then
                    say(sp:uselyrics(n) and ("using match " .. n) or "no such match")
                    return
                end
                local alts = sp:lyricsalts()
                if #alts == 0 then say("no synced matches on lrclib") return end
                for i,v in pairs(alts) do
                    say(i .. ". " .. v.name .. "  off by " .. string.format("%.0f", v.drift) .. "s")
                end
            end,
            bpm = function()
                sp:features()
                say(sp.bpm and (sp.bpm .. " bpm") or "spotify did not return audio features")
            end,
            sync = function(a)
                local n = tonumber(a[1])
                if not n then
                    say("lyric offset " .. string.format("%.2f", sp.lyric_offset or 0) .. "s")
                else
                    say("lyric offset " .. string.format("%.2f", sp:nudge(n)) .. "s")
                end
            end,
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

function kyri.splash(options)
    options = options or {}
    local localPlayer = kyri.svc.plr.LocalPlayer

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
        if options.Splash == false then
            load_gui:Destroy()
            loaded = true
            return
        end

        local url = "https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/kyriliblogo.png"
        local path = "kyrilib_logo.png"
        local shown = false

        local function try(img)
            if not img or img == "" then return false end

            local probe = make("ImageLabel", {
                Size = UDim2.fromOffset(1, 1),
                BackgroundTransparency = 1,
                Image = img,
                Parent = load_gui
            })

            pcall(function() kyri.svc.cp:PreloadAsync({probe}) end)
            local t0 = os.clock()
            while not probe.IsLoaded and os.clock() - t0 < 1.5 do
                task.wait(0.05)
            end

            local got = probe.IsLoaded
            probe:Destroy()
            if got then logo.Image = img end
            return got
        end

        if options.Logo then
            shown = try(options.Logo)
        end

        if not shown and isfile and writefile and not isfile(path) then
            local data = http_get(url)
            if data then pcall(function() writefile(path, data) end) end
        end

        if not shown and isfile and getcustomasset and isfile(path) then
            pcall(function() shown = try(getcustomasset(path)) end)
        end

        if not shown then
            shown = try("rbxassetid://88259917092947")
        end

        local mark = logo
        if not shown then
            logo:Destroy()
            mark = make("TextLabel", {
                Size = UDim2.fromOffset(460, 140),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Text = "KyriLib",
                TextColor3 = Color3.fromRGB(238, 236, 230),
                TextTransparency = 1,
                Font = Enum.Font.Merriweather,
                TextSize = 64,
                Parent = load_gui
            })
        end

        local into = shown and {ImageTransparency = 0} or {TextTransparency = 0}
        local outof = shown and {ImageTransparency = 1} or {TextTransparency = 1}

        kyri.svc.tw:Create(mark, TweenInfo.new(0.4), into):Play()
        task.wait(options.SplashTime or 1.5)
        kyri.svc.tw:Create(mark, TweenInfo.new(0.4), outof):Play()
        task.wait(0.4)
        load_gui:Destroy()
        loaded = true
    end)

    repeat task.wait() until loaded
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

    for i,g in pairs(localPlayer.PlayerGui:GetChildren()) do
        if g:IsA("ScreenGui") and g:GetAttribute("kyri") then g:Destroy() end
    end

    kyri.splash(options)

    if options.KeySystem then
        local ks = options.KeySettings or {}
        local validKeys = ks.Key or {}
        if type(validKeys) == "string" then validKeys = {validKeys} end
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
                Size = UDim2.fromOffset(480, 216),
                Position = UDim2.new(0.5, -240, 0.5, -108),
                BackgroundColor3 = th.bg,
                Parent = keyGui
            })
            make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = dialog })
            make("UIStroke", { Color = th.border, Thickness = 1, Transparency = 0.3, Parent = dialog })

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

            local closeBtn = make("ImageButton", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(1, -20, 0, 20),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Image = ico("x") or "",
                ImageColor3 = th.subtext,
                Parent = dialog
            })
            closeBtn.MouseEnter:Connect(function()
                kyri.svc.tw:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = th.text}):Play()
            end)
            closeBtn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = th.subtext}):Play()
            end)

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
                Size = UDim2.fromOffset(ks.Link and 150 or 240, 32),
                Position = UDim2.fromOffset(20, 148),
                BackgroundColor3 = th.accent,
                Text = "Submit",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                Parent = dialog
            })
            make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = submitBtn })

            if ks.Link then
                local linkBtn = make("TextButton", {
                    Size = UDim2.fromOffset(86, 32),
                    Position = UDim2.fromOffset(178, 148),
                    BackgroundColor3 = th.element,
                    Text = "get key",
                    TextColor3 = th.text,
                    TextSize = 12,
                    Font = Enum.Font.GothamMedium,
                    AutoButtonColor = false,
                    Parent = dialog
                })
                make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = linkBtn })
                linkBtn.MouseButton1Click:Connect(function()
                    if setclipboard then
                        pcall(setclipboard, ks.Link)
                    else
                        kyri.copybox(ks.Link, "key link")
                    end
                end)
            end

            local errLabel = make("TextLabel", {
                Size = UDim2.new(0.52, 0, 0, 18),
                Position = UDim2.fromOffset(20, 186),
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

            local function submit()
                if keyDone then return end
                local ok, trimmed = tryKey(keyInput.Text)
                if ok then
                    if mode == "Once" and fileName then
                        pcall(function() writefile(fileName, trimmed) end)
                    end
                    submitBtn.Text = "unlocked"
                    errLabel.Text = ""
                    kyri.svc.tw:Create(submitBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(86, 196, 128)
                    }):Play()
                    keyAccepted = true
                    task.wait(0.35)
                    keyDone = true
                else
                    errLabel.Text = keyInput.Text == "" and "enter a key" or "invalid key"
                    keyInput.Text = ""
                end
            end

            submitBtn.MouseButton1Click:Connect(submit)

            keyInput.FocusLost:Connect(function(enter)
                if enter then submit() end
            end)

            closeBtn.MouseButton1Click:Connect(function()
                keyDone = true
            end)

            repeat task.wait() until keyDone
            keyGui:Destroy()

            if not keyAccepted then return end
        end

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

    local mode = options.Mode
    if options.Island == true then mode = "island" end
    if options.Island == false and mode == nil then mode = "window" end
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
            letter = (w.title or "k"):sub(1, 1):upper(),
            bars = false,
            seek = false,
            volume = false,
            id = "hub",
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

        top = make("Frame", {
            Size = UDim2.new(1, 0, 0, 52),
            BackgroundColor3 = t.container,
            Parent = main
        })

        make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = top})

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

        tip(minimize, "minimise")
        tip(close, "close")

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

            if type(icon) == "string" and icon:find("^https://") then
                task.spawn(function()
                    local ok, err = pcall(function()
                        local http = request or http_request or syn and syn.request
                        if not http then return end
                        local res = http({ Url = icon, Method = "GET" })
                        if not res or res.StatusCode ~= 200 or not res.Body then return end
                        if not getcustomasset then return end
                        local fname = "kyrilib_icons/" .. icon:gsub("[^%w]", "_"):sub(1, 64) .. ".png"
                        if not isfolder("kyrilib_icons") then makefolder("kyrilib_icons") end
                        writefile(fname, res.Body)
                        local asset = getcustomasset(fname)
                        icon_img.Image = asset
                    end)
                    if not ok then
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
                ClipsDescendants = true,
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
                local d = math.max(box.AbsoluteSize.X, box.AbsoluteSize.Y) * 1.6
                ripple.Size = UDim2.fromOffset(0, 0)
                ripple.ImageTransparency = 0.62
                kyri.svc.tw:Create(ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(d, d),
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

            local handle = make("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 2,
                Parent = track
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = handle})

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
                    Text = "-",
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
            if typeof(default) == "EnumItem" then default = default.Name end
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
        if w.settings_tab then return w.settings_tab end
        local settings = self:tab("Settings")
        w.settings_tab = settings

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

    function w:notify(title, text, duration, icon)
        duration = duration or 3
        text = text or ""

        local gui = w.notif_gui
        if not gui or not gui.Parent then
            gui = make("ScreenGui", {
                Name = rnd(),
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = false,
                DisplayOrder = 999999998,
                Parent = w.localPlayer.PlayerGui
            })
            gui:SetAttribute("kyri", true)
            w.notif_gui = gui

            local vpx = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 1280
            w.notif_w = math.clamp(math.floor(vpx - 40), 200, 300)

            local holder = make("Frame", {
                Name = "Container",
                Size = UDim2.new(0, w.notif_w, 1, -40),
                Position = UDim2.new(1, -20, 0, 20),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Parent = gui
            })
            make("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Parent = holder
            })
        end

        local holder = gui.Container
        local cw = w.notif_w or 300
        local h = text ~= "" and 58 or 52

        local slot = make("Frame", {
            Size = UDim2.fromOffset(cw, h),
            BackgroundTransparency = 1,
            Parent = holder
        })

        local card = make(has_cg and "CanvasGroup" or "Frame", {
            Size = UDim2.fromOffset(cw, h),
            Position = UDim2.fromOffset(44, 0),
            BackgroundColor3 = t.bg,
            GroupTransparency = has_cg and 1 or nil,
            ClipsDescendants = true,
            Parent = slot
        })
        make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = card})

        local stroke = make("UIStroke", {
            Color = t.border,
            Thickness = 1,
            Transparency = 1,
            Parent = card
        })

        local gid = ico(icon) or ico("bell")

        local tile = make("Frame", {
            Size = UDim2.fromOffset(28, 28),
            Position = UDim2.fromOffset(12, (h - 28) / 2),
            BackgroundColor3 = t.accent,
            BackgroundTransparency = 0.84,
            Parent = card
        })
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = tile})

        if gid then
            make("ImageLabel", {
                Size = UDim2.fromOffset(15, 15),
                Position = UDim2.new(0.5, -7, 0.5, -7),
                BackgroundTransparency = 1,
                Image = gid,
                ImageColor3 = t.accent,
                Parent = tile
            })
        else
            tile.Size = UDim2.fromOffset(8, 8)
            tile.Position = UDim2.fromOffset(22, (h - 8) / 2)
            tile.BackgroundTransparency = 0.15
        end

        local count = make("TextLabel", {
            Size = UDim2.fromOffset(30, 16),
            Position = UDim2.new(1, -12, 0, 11),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Text = tostring(math.ceil(duration)),
            TextColor3 = t.subtext,
            TextTransparency = 0.25,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = card
        })

        local tl = make("TextLabel", {
            Size = UDim2.new(1, -98, 0, 17),
            Position = UDim2.fromOffset(52, 11),
            BackgroundTransparency = 1,
            Text = title or "",
            TextColor3 = t.text,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card
        })

        if text == "" then
            tl.Position = UDim2.fromOffset(52, 0)
            tl.Size = UDim2.new(1, -98, 1, 0)
            count.Position = UDim2.new(1, -12, 0.5, 0)
            count.AnchorPoint = Vector2.new(1, 0.5)
        else
            make("TextLabel", {
                Size = UDim2.new(1, -98, 0, 16),
                Position = UDim2.fromOffset(52, 29),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = card
            })
        end

        local hit = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 5,
            Parent = card
        })

        local gone = false
        local function dismiss()
            if gone then return end
            gone = true
            local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            kyri.svc.tw:Create(card, ti, {Position = UDim2.fromOffset(44, 0)}):Play()
            kyri.svc.tw:Create(stroke, TweenInfo.new(0.16), {Transparency = 1}):Play()
            fade(card, 1, 0.2)
            task.delay(0.26, function()
                if slot and slot.Parent then slot:Destroy() end
            end)
        end

        hit.MouseButton1Click:Connect(dismiss)
        hit.MouseEnter:Connect(function()
            if gone then return end
            kyri.svc.tw:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
        end)
        hit.MouseLeave:Connect(function()
            if gone then return end
            kyri.svc.tw:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = t.bg}):Play()
        end)

        kyri.svc.tw:Create(card, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(0, 0)
        }):Play()
        kyri.svc.tw:Create(stroke, TweenInfo.new(0.26), {Transparency = 0.3}):Play()
        fade(card, 0, 0.26)

        task.spawn(function()
            local left = duration
            while left > 0 do
                if gone or not card.Parent then return end
                count.Text = tostring(math.ceil(left))
                task.wait(0.1)
                left = left - 0.1
            end
        end)

        task.delay(duration, dismiss)
        return slot
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

        if w.mode == "island" and w.isl and opts.island ~= true then
            local old = w.isl
            local kept = {}

            for i,c in pairs(old.body:GetChildren()) do
                if c:IsA("GuiObject") then
                    c.Visible = false
                    c.Parent = w.gui
                    kept[#kept + 1] = c
                end
            end

            local fresh = kyri.island({
                title = w.title,
                letter = (w.title or "k"):sub(1, 1):upper(),
                id = "hub",
                expanded_width = w.pan_w,
                body_height = w.pan_h,
                total_height = math.min(w.pan_h + 170, math.max(math.floor(vp.Y * 0.82), w.pan_h)),
                on_close = function() w:destroy() end
            })
            for i,c in pairs(kept) do
                c.Parent = fresh.body
                c.Visible = true
            end

            fresh.root.AnchorPoint = old.root.AnchorPoint
            fresh.root.Position = old.root.Position

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
