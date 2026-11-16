local svc = {}
local gs = cloneref or function(o) return o end
local function call(n)
    return gs(game:GetService(n))
end

svc.plr = call("Players")
svc.run = call("RunService")

getgenv().KYRI_SPICY_KEY = getgenv().KYRI_SPICY_KEY or ""

local lp = svc.plr.LocalPlayer
local cam = workspace.CurrentCamera
repeat wait() until lp:FindFirstChild("PlayerGui")

local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua"))()

local sp = kyri.spotify({
    tabs = false,
    commands = true,
    island_results = 6,
    id = "isl"
})

local isl = sp.island

if not sp:authed() then
    isl:notify("tap me, then sign in", 5)
end

local maxd = 1500
local held = {}
local cfg = {esp = true, box = true, nm = true, dt = true, hp = true}

local col = Color3.fromRGB(255, 255, 255)
local low = Color3.fromRGB(235, 70, 70)
--local col = Color3.fromRGB(138, 116, 249)

local skins = {}
for k in pairs(kyri.presets) do skins[#skins + 1] = k end
table.sort(skins)
local si = 1

do
    local gui = isl.gui or (sp.words and sp.words.box and sp.words.box:FindFirstAncestorOfClass("ScreenGui"))
    local root = gui and gui:FindFirstChildOfClass("Frame")

    local function repaint(was, new)
        if not root then return end
        local function one(o)
            pcall(function()
                if o:IsA("GuiObject") and o.BackgroundColor3 == was then o.BackgroundColor3 = new end
                if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
                    if o.TextColor3 == was then o.TextColor3 = new end
                end
                if o:IsA("UIStroke") and o.Color == was then o.Color = new end
                if o:IsA("ImageLabel") or o:IsA("ImageButton") then
                    if o.ImageColor3 == was then o.ImageColor3 = new end
                end
            end)
        end
        one(root)
        for i,o in pairs(root:GetDescendants()) do one(o) end
    end

    local function skin(name)
        local pre = kyri.presets[name]
        if not pre then return end
        if isl.theme then
            isl:theme(pre)
            return
        end
        for k,v in pairs(pre) do
            local was = kyri.theme[k]
            if was and was ~= v then repaint(was, v) end
            kyri.theme[k] = v
        end
    end

    local menu = isl:list(6)

    local function paint()
        local function row(k, label)
            return {
                text = label .. "   " .. (cfg[k] and "on" or "off"),
                icon = cfg[k] and "toggle-right" or "toggle-left",
                cb = function()
                    cfg[k] = not cfg[k]
                    paint()
                end
            }
        end

        menu:set({
            row("esp", "esp"),
            row("box", "boxes"),
            row("nm", "names"),
            row("dt", "distance"),
            row("hp", "health"),
            {
                text = "theme   " .. skins[si],
                icon = "palette",
                cb = function()
                    si = si % #skins + 1
                    skin(skins[si])
                    paint()
                end
            }
        })
    end

    paint()
end

local function mk(p)
    local d = {}

    d.box = Drawing.new("Square")
    d.box.Thickness = 1
    d.box.Filled = false
    d.box.Color = col
    d.box.Visible = false

    d.nm = Drawing.new("Text")
    d.nm.Size = 13
    d.nm.Center = true
    d.nm.Outline = false
    d.nm.Color = col
    d.nm.Visible = false

    d.dt = Drawing.new("Text")
    d.dt.Size = 12
    d.dt.Center = true
    d.dt.Outline = false
    d.dt.Color = Color3.fromRGB(190, 190, 200)
    d.dt.Visible = false

    d.bg = Drawing.new("Line")
    d.bg.Thickness = 3
    d.bg.Color = Color3.new(0, 0, 0)
    d.bg.Transparency = 0.6
    d.bg.Visible = false

    d.hp = Drawing.new("Line")
    d.hp.Thickness = 1
    d.hp.Visible = false

    held[p] = d
    return d
end

local function hide(d)
    for i,v in pairs(d) do
        v.Visible = false
    end
end

local function kill(p)
    local d = held[p]
    if not d then return end
    for i,v in pairs(d) do
        pcall(function() v:Remove() end)
    end
    held[p] = nil
end

if Drawing then
    for i,v in pairs(svc.plr:GetPlayers()) do
        if v ~= lp then mk(v) end
    end

    svc.plr.PlayerAdded:Connect(function(p)
        if p ~= lp then mk(p) end
    end)

    svc.plr.PlayerRemoving:Connect(kill)

    svc.run.RenderStepped:Connect(function()
        local me = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

        for p,d in pairs(held) do
            local chr = p.Character
            local grm = chr and chr:FindFirstChild("HumanoidRootPart")
            local hum = chr and chr:FindFirstChildOfClass("Humanoid")

            if not cfg.esp or not grm or not hum or hum.Health <= 0 then
                hide(d)
                continue
            end

            local far = me and (grm.Position - me.Position).Magnitude or 0
            if far > maxd then
                hide(d)
                continue
            end

            local mid, vis = cam:WorldToViewportPoint(grm.Position)
            if not vis then
                hide(d)
                continue
            end

            local top = cam:WorldToViewportPoint(grm.Position + Vector3.new(0, 2.9, 0))
            local bot = cam:WorldToViewportPoint(grm.Position - Vector3.new(0, 3.1, 0))

            local h = math.abs(bot.Y - top.Y)
            local w = h / 2
            local x = mid.X - w / 2
            local y = top.Y

            d.box.Size = Vector2.new(w, h)
            d.box.Position = Vector2.new(x, y)
            d.box.Visible = cfg.box

            d.nm.Text = p.DisplayName
            d.nm.Position = Vector2.new(mid.X, y - 16)
            d.nm.Visible = cfg.nm

            d.dt.Text = math.floor(far) .. "m"
            d.dt.Position = Vector2.new(mid.X, y + h + 2)
            d.dt.Visible = cfg.dt

            local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            local bx = x - 5

            d.bg.From = Vector2.new(bx, y)
            d.bg.To = Vector2.new(bx, y + h)
            d.bg.Visible = cfg.hp

            d.hp.From = Vector2.new(bx, y + h)
            d.hp.To = Vector2.new(bx, y + h - (h * pct))
            d.hp.Color = pct > 0.35 and Color3.fromRGB(90, 230, 120) or low
            d.hp.Visible = cfg.hp
        end
    end)
end
