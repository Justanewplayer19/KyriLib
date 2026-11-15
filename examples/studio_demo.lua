local kyri = require(game:GetService("ReplicatedStorage"):WaitForChild("KyriLib"))

local svc = {}
local function call(n)
    return game:GetService(n)
end

svc.plr = call("Players")
svc.run = call("RunService")
svc.uis = call("UserInputService")

local lp = svc.plr.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

local chr = lp.Character
local grm = chr:WaitForChild("HumanoidRootPart")
local hum = chr:WaitForChild("Humanoid")

local fly = false
local fspd = 60
local wspd = 16
local jpow = 50
local spin = false

local function setjump(v)
    jpow = v
    if not hum then return end
    hum.JumpPower = v
    hum.JumpHeight = v * 0.144
end

lp.CharacterAdded:Connect(function(c)
    chr = c
    grm = c:WaitForChild("HumanoidRootPart")
    hum = c:WaitForChild("Humanoid")
    hum.WalkSpeed = wspd
    setjump(jpow)
end)

setjump(jpow)

svc.run.RenderStepped:Connect(function(dt)
    if not grm or not grm.Parent then return end

    if spin then
        grm.CFrame = grm.CFrame * CFrame.Angles(0, math.rad(180 * dt), 0)
    end

    if not fly then return end
    grm.AssemblyLinearVelocity = Vector3.zero

    local cam = workspace.CurrentCamera
    local d = Vector3.zero
    if svc.uis:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
    if svc.uis:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
    if svc.uis:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
    if svc.uis:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
    if svc.uis:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.yAxis end
    if svc.uis:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.yAxis end

    if d.Magnitude > 0 then
        grm.CFrame = grm.CFrame + d.Unit * fspd * dt
    end
end)

local w = kyri.new("studio demo", {
    Island = true,
    GameName = "StudioDemo",
    AutoLoad = "default"
})

local mv = w:tab("Main", "sword")

mv:section("movement")

mv:toggle("fly", false, function(s)
    fly = s
    if not s and grm then grm.AssemblyLinearVelocity = Vector3.zero end
    w:notify("fly", s and "wasd, space up, shift down" or "off", 3, s and "check" or "x")
end, "fly")

mv:slider("fly speed", 10, 200, 60, function(v)
    fspd = v
end, "fly_speed", 5)

mv:slider("walkspeed", 8, 150, 16, function(v)
    wspd = v
    if hum then hum.WalkSpeed = v end
end, "walkspeed", 1)

mv:slider("jump", 20, 250, 50, function(v)
    setjump(v)
end, "jump", 5)

mv:space()
mv:section("character")

mv:toggle("spin", false, function(s)
    spin = s
    if hum then hum.AutoRotate = not s end
end, "spin")

mv:button("reset character", function()
    if hum then hum.Health = 0 end
    w:notify("character", "respawning", 2)
end, "refresh-cw")

mv:button("face spawn", function()
    if not grm then return end
    grm.CFrame = CFrame.lookAt(grm.Position, Vector3.new(0, grm.Position.Y, 0))
end, "compass")

mv:keybind("toggle fly", Enum.KeyCode.F, false, function()
    fly = not fly
    w.flags.fly_set(fly, false)
    w:notify("fly", fly and "on" or "off", 2)
end, "fly_key")

local tp = w:tab("Teleport", "map-pin")

tp:paragraph("not wired up",
    "this place has nothing to teleport to, so these are examples. the dropdown and the button work, they just report the choice instead of moving you.")

local spot = "spawn"

tp:dropdown("destination", {"spawn", "shop", "arena", "boss room"}, "spawn", function(v)
    spot = v
end, "tp_spot")

tp:button("teleport", function()
    w:notify("teleport", "would go to " .. spot, 3, "map-pin")
end, "map-pin")

tp:space()
tp:section("this one does move you")

local nudge = 10

tp:slider("nudge height", 0, 60, 10, function(v)
    nudge = v
end, "nudge_amt", 1)

tp:button("nudge up", function()
    if not grm then return end
    grm.CFrame = grm.CFrame + Vector3.new(0, nudge, 0)
    w:notify("nudge", "moved up " .. nudge .. " studs", 2, "arrow-up")
end, "arrow-up")

local vis = w:tab("Visuals", "eye")

vis:section("theme")

vis:colorpicker("accent", kyri.theme.accent, function(c)
    w:accent(c)
end, "accent")

vis:dropdown("preset", {"kyri", "midnight", "rose", "forest", "slate"}, "kyri", function(v)
    w:apply_theme(kyri.presets[v])
    w:notify("theme", v, 2, "palette")
end, "preset")

vis:space()
vis:section("preview")

vis:image("rbxassetid://7733911828", 90, Enum.ScaleType.Fit)

vis:label("the island tile and tab glyphs come from the same pack")

local tst = w:tab("Test", "box")

tst:search("filter this tab")

tst:label("label")

tst:paragraph("paragraph", "a title and a body, used for longer explanations that do not fit on one line.")

tst:input("input", "type something", function(v)
    w:notify("input", v == "" and "cleared" or v, 2, "pencil")
end, "test_input")

tst:multiselect("multiselect", {"alpha", "bravo", "charlie", "delta"}, {"alpha"}, function(v)
    w:notify("multiselect", #v == 0 and "none" or table.concat(v, ", "), 2, "list")
end, "test_multi")

tst:keybind("keybind", Enum.KeyCode.G, false, function()
    w:notify("keybind", "g pressed", 2, "command")
end, "test_key")

local bar = tst:progressbar("progress", 100)

tst:button("fill progress", function()
    task.spawn(function()
        for i = 0, 100, 4 do
            if bar and bar.set then bar:set(i) end
            task.wait(0.03)
        end
        w:notify("progress", "done", 2, "check")
    end)
end, "loader")

tst:space()
tst:section("notifications")

tst:button("short", function()
    w:notify("saved", "config written", 3, "check")
end, "bell")

tst:button("title only", function()
    w:notify("nothing else to say", "", 3)
end, "bell")

tst:button("long, truncates", function()
    w:notify("a much longer title that will not fit on one line at all",
        "and a body line that is also far too long to fit inside the card", 4, "alert-triangle")
end, "bell")

tst:button("three at once", function()
    w:notify("one", "first", 4, "check")
    w:notify("two", "second", 4, "info")
    w:notify("three", "third", 4, "bell")
end, "layers")

w:notify("studio demo", "f toggles fly, right control hides the ui", 5, "check")
