-- Nexus UI Library
local Nexus = {
    Flags = {},
    Windows = {},
    Connections = {}
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Utils
local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.3, Enum.EasingStyle.Quad), props):Play()
end

local function makeDraggable(frame)
    local dragging, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function saveConfig(flags, name)
    if not writefile then return end
    local data = {}
    for flag, element in pairs(flags) do
        if element.Type == "Toggle" then
            data[flag] = element.Value
        elseif element.Type == "Slider" then
            data[flag] = element.Value
        elseif element.Type == "Dropdown" then
            data[flag] = element.Selected
        elseif element.Type == "Input" then
            data[flag] = element.Value
        elseif element.Type == "Keybind" then
            data[flag] = element.Key
        end
    end
    writefile("nexus_" .. name .. ".json", HttpService:JSONEncode(data))
end

local function loadConfig(flags, name)
    if not isfile or not readfile then return end
    if not isfile("nexus_" .. name .. ".json") then return end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("nexus_" .. name .. ".json"))
    end)
    
    if success and data then
        for flag, value in pairs(data) do
            if flags[flag] and flags[flag].Set then
                flags[flag]:Set(value)
            end
        end
    end
end

function Nexus:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Nexus UI"
    local windowFlags = {}
    
    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI_" .. windowName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -300, 0.5, -250)
    Main.Size = UDim2.new(0, 600, 0, 500)
    Main.Parent = ScreenGui
    Main.ClipsDescendants = true
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.Parent = Main
    
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 8)
    
    local TopbarTitle = Instance.new("TextLabel")
    TopbarTitle.Name = "Title"
    TopbarTitle.BackgroundTransparency = 1
    TopbarTitle.Position = UDim2.new(0, 15, 0, 0)
    TopbarTitle.Size = UDim2.new(1, -15, 1, 0)
    TopbarTitle.Font = Enum.Font.GothamBold
    TopbarTitle.Text = windowName
    TopbarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TopbarTitle.TextSize = 16
    TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopbarTitle.Parent = Topbar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 12
    CloseBtn.Parent = Topbar
    
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.Parent = Main
    
    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 5)
    
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)
    
    -- Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 150, 0, 40)
    Container.Size = UDim2.new(1, -150, 1, -40)
    Container.Parent = Main
    
    local ContainerList = Instance.new("UIListLayout", Container)
    ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerList.Padding = UDim.new(0, 8)
    
    local ContainerPadding = Instance.new("UIPadding", Container)
    ContainerPadding.PaddingTop = UDim.new(0, 15)
    ContainerPadding.PaddingLeft = UDim.new(0, 15)
    ContainerPadding.PaddingRight = UDim.new(0, 15)
    
    makeDraggable(Topbar)
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Flags = windowFlags
    }
    
    function Window:CreateTab(name)
        local Tab = {
            Name = name,
            Elements = {},
            Container = Instance.new("ScrollingFrame")
        }
        
        Tab.Container.Name = name
        Tab.Container.BackgroundTransparency = 1
        Tab.Container.BorderSizePixel = 0
        Tab.Container.Size = UDim2.new(1, 0, 1, 0)
        Tab.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.Container.ScrollBarThickness = 4
        Tab.Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        Tab.Container.Visible = false
        Tab.Container.Parent = Container
        
        local TabList = Instance.new("UIListLayout", Tab.Container)
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Padding = UDim.new(0, 8)
        
        Instance.new("UIPadding", Tab.Container).PaddingRight = UDim.new(0, 10)
        
        TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.Container.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 15)
        end)
        
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        
        local TabCorner = Instance.new("UICorner", TabBtn)
        TabCorner.CornerRadius = UDim.new(0, 6)
        
        local TabPadding = Instance.new("UIPadding", TabBtn)
        TabPadding.PaddingLeft = UDim.new(0, 10)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Container.Visible = false
                local btn = Sidebar:FindFirstChild(tab.Name)
                if btn then
                    tween(btn, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            Tab.Container.Visible = true
            tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(60, 120, 255)})
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = Tab
        end)
        
        if not Window.CurrentTab then
            Tab.Container.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = Tab
        end
        
        function Tab:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Name = "Button"
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Btn.BorderSizePixel = 0
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.TextSize = 14
            Btn.Parent = Tab.Container
            
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            Btn.MouseEnter:Connect(function()
                tween(Btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            end)
            
            Btn.MouseLeave:Connect(function()
                tween(Btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
            end)
            
            Btn.MouseButton1Click:Connect(function()
                tween(Btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                task.wait(0.1)
                tween(Btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                callback()
            end)
            
            return Btn
        end
        
        function Tab:CreateToggle(text, default, flag, callback)
            local toggled = default or false
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle"
            Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.Parent = Tab.Container
            
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle
            
            local Switch = Instance.new("Frame")
            Switch.BackgroundColor3 = toggled and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(50, 50, 50)
            Switch.BorderSizePixel = 0
            Switch.Position = UDim2.new(1, -48, 0.5, -10)
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Parent = Toggle
            
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            
            local Circle = Instance.new("Frame")
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BorderSizePixel = 0
            Circle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Parent = Switch
            
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.Text = ""
            ToggleBtn.Parent = Toggle
            
            local function toggle(state)
                toggled = state
                tween(Switch, {BackgroundColor3 = toggled and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(50, 50, 50)})
                tween(Circle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                callback(toggled)
                if flag then
                    saveConfig(windowFlags, windowName)
                end
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                toggle(not toggled)
            end)
            
            local ToggleObj = {
                Type = "Toggle",
                Value = toggled,
                Set = function(self, val)
                    toggle(val)
                end
            }
            
            if flag then
                windowFlags[flag] = ToggleObj
            end
            
            return ToggleObj
        end
        
        function Tab:CreateSlider(text, min, max, default, flag, callback)
            local value = default or min
            
            local Slider = Instance.new("Frame")
            Slider.Name = "Slider"
            Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Slider.BorderSizePixel = 0
            Slider.Size = UDim2.new(1, 0, 0, 55)
            Slider.Parent = Tab.Container
            
            Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 5)
            Label.Size = UDim2.new(1, -24, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Slider
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0, 12, 0, 5)
            ValueLabel.Size = UDim2.new(1, -24, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(value)
            ValueLabel.TextColor3 = Color3.fromRGB(60, 120, 255)
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Slider
            
            local SliderBar = Instance.new("Frame")
            SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 12, 1, -18)
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Parent = Slider
            
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame")
            Fill.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            Fill.BorderSizePixel = 0
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.Parent = SliderBar
            
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            
            local function slide(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                callback(value)
                if flag then
                    saveConfig(windowFlags, windowName)
                end
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    slide(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    slide(input)
                end
            end)
            
            local SliderObj = {
                Type = "Slider",
                Value = value,
                Set = function(self, val)
                    value = math.clamp(val, min, max)
                    Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    callback(value)
                    if flag then
                        saveConfig(windowFlags, windowName)
                    end
                end
            }
            
            if flag then
                windowFlags[flag] = SliderObj
            end
            
            return SliderObj
        end
        
        function Tab:CreateDropdown(text, options, default, flag, callback)
            local selected = default or options[1]
            local open = false
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown"
            Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Dropdown.BorderSizePixel = 0
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.ClipsDescendants = true
            Dropdown.Parent = Tab.Container
            
            Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)
            
            local Header = Instance.new("TextButton")
            Header.BackgroundTransparency = 1
            Header.Size = UDim2.new(1, 0, 0, 40)
            Header.Font = Enum.Font.Gotham
            Header.Text = text .. ": " .. selected
            Header.TextColor3 = Color3.fromRGB(220, 220, 220)
            Header.TextSize = 14
            Header.Parent = Dropdown
            
            local Arrow = Instance.new("TextLabel")
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.Size = UDim2.new(0, 30, 1, 0)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Text = "v"
            Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
            Arrow.TextSize = 16
            Arrow.Parent = Dropdown
            
            local List = Instance.new("Frame")
            List.BackgroundTransparency = 1
            List.Position = UDim2.new(0, 0, 0, 40)
            List.Size = UDim2.new(1, 0, 0, #options * 35)
            List.Parent = Dropdown
            
            local ListLayout = Instance.new("UIListLayout", List)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            for _, option in ipairs(options) do
                local Opt = Instance.new("TextButton")
                Opt.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                Opt.BorderSizePixel = 0
                Opt.Size = UDim2.new(1, 0, 0, 35)
                Opt.Font = Enum.Font.Gotham
                Opt.Text = option
                Opt.TextColor3 = Color3.fromRGB(200, 200, 200)
                Opt.TextSize = 13
                Opt.Parent = List
                
                Opt.MouseEnter:Connect(function()
                    tween(Opt, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
                end)
                
                Opt.MouseLeave:Connect(function()
                    tween(Opt, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
                end)
                
                Opt.MouseButton1Click:Connect(function()
                    selected = option
                    Header.Text = text .. ": " .. selected
                    tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40)})
                    tween(Arrow, {Rotation = 0})
                    open = false
                    callback(selected)
                    if flag then
                        saveConfig(windowFlags, windowName)
                    end
                end)
            end
            
            Header.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40 + #options * 35)})
                    tween(Arrow, {Rotation = 180})
                else
                    tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40)})
                    tween(Arrow, {Rotation = 0})
                end
            end)
            
            local DropdownObj = {
                Type = "Dropdown",
                Selected = selected,
                Set = function(self, val)
                    selected = val
                    Header.Text = text .. ": " .. selected
                    callback(selected)
                    if flag then
                        saveConfig(windowFlags, windowName)
                    end
                end
            }
            
            if flag then
                windowFlags[flag] = DropdownObj
            end
            
            return DropdownObj
        end
        
        function Tab:CreateInput(text, placeholder, flag, callback)
            local currentValue = ""
            
            local Input = Instance.new("Frame")
            Input.Name = "Input"
            Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Input.BorderSizePixel = 0
            Input.Size = UDim2.new(1, 0, 0, 65)
            Input.Parent = Tab.Container
            
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 5)
            Label.Size = UDim2.new(1, -24, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Input
            
            local Box = Instance.new("TextBox")
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Box.BorderSizePixel = 0
            Box.Position = UDim2.new(0, 12, 0, 30)
            Box.Size = UDim2.new(1, -24, 0, 28)
            Box.Font = Enum.Font.Gotham
            Box.PlaceholderText = placeholder or ""
            Box.Text = ""
            Box.TextColor3 = Color3.fromRGB(200, 200, 200)
            Box.TextSize = 13
            Box.Parent = Input
            
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            
            Box.FocusLost:Connect(function()
                currentValue = Box.Text
                callback(currentValue)
                if flag then
                    saveConfig(windowFlags, windowName)
                end
            end)
            
            local InputObj = {
                Type = "Input",
                Value = currentValue,
                Set = function(self, val)
                    currentValue = val
                    Box.Text = val
                    callback(currentValue)
                    if flag then
                        saveConfig(windowFlags, windowName)
                    end
                end
            }
            
            if flag then
                windowFlags[flag] = InputObj
            end
            
            return InputObj
        end
        
        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Label.BorderSizePixel = 0
            Label.Size = UDim2.new(1, 0, 0, 35)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 14
            Label.Parent = Tab.Container
            
            Instance.new("UICorner", Label).CornerRadius = UDim.new(0, 6)
            
            local LabelObj = {
                Set = function(self, val)
                    Label.Text = val
                end
            }
            
            return LabelObj
        end
        
        function Tab:CreateKeybind(text, default, flag, callback)
            local currentKey = default or "None"
            local listening = false
            
            local Keybind = Instance.new("Frame")
            Keybind.Name = "Keybind"
            Keybind.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Keybind.BorderSizePixel = 0
            Keybind.Size = UDim2.new(1, 0, 0, 40)
            Keybind.Parent = Tab.Container
            
            Instance.new("UICorner", Keybind).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -100, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Keybind
            
            local KeyBtn = Instance.new("TextButton")
            KeyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            KeyBtn.BorderSizePixel = 0
            KeyBtn.Position = UDim2.new(1, -80, 0.5, -15)
            KeyBtn.Size = UDim2.new(0, 70, 0, 30)
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.Text = currentKey
            KeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            KeyBtn.TextSize = 12
            KeyBtn.Parent = Keybind
            
            Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)
            
            KeyBtn.MouseButton1Click:Connect(function()
                listening = true
                KeyBtn.Text = "..."
                KeyBtn.TextColor3 = Color3.fromRGB(60, 120, 255)
            end)
            
            local connection = UserInputService.InputBegan:Connect(function(input)
                if listening then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        currentKey = input.KeyCode.Name
                        KeyBtn.Text = currentKey
                        KeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        listening = false
                        callback(currentKey)
                        if flag then
                            saveConfig(windowFlags, windowName)
                        end
                    end
                elseif input.KeyCode.Name == currentKey then
                    callback(true)
                end
            end)
            
            table.insert(Nexus.Connections, connection)
            
            local KeybindObj = {
                Type = "Keybind",
                Key = currentKey,
                Set = function(self, val)
                    currentKey = val
                    KeyBtn.Text = val
                    if flag then
                        saveConfig(windowFlags, windowName)
                    end
                end
            }
            
            if flag then
                windowFlags[flag] = KeybindObj
            end
            
            return KeybindObj
        end
        
        function Tab:CreateSection(text)
            local Section = Instance.new("TextLabel")
            Section.Name = "Section"
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, 0, 0, 25)
            Section.Font = Enum.Font.GothamBold
            Section.Text = text
            Section.TextColor3 = Color3.fromRGB(150, 150, 150)
            Section.TextSize = 13
            Section.TextXAlignment = Enum.TextXAlignment.Left
            Section.Parent = Tab.Container
            
            local Line = Instance.new("Frame")
            Line.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Line.BorderSizePixel = 0
            Line.Position = UDim2.new(0, 0, 1, -1)
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Parent = Section
            
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    function Window:Notify(config)
        local title = config.Title or "Notification"
        local message = config.Message or ""
        local duration = config.Duration or 3
        
        local Notif = Instance.new("Frame")
        Notif.Name = "Notification"
        Notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Notif.BorderSizePixel = 0
        Notif.Position = UDim2.new(1, -320, 1, 100)
        Notif.Size = UDim2.new(0, 300, 0, 80)
        Notif.Parent = ScreenGui
        
        Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 8)
        
        local NotifStroke = Instance.new("UIStroke", Notif)
        NotifStroke.Color = Color3.fromRGB(60, 120, 255)
        NotifStroke.Thickness = 2
        
        local Title = Instance.new("TextLabel")
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 15, 0, 10)
        Title.Size = UDim2.new(1, -30, 0, 20)
        Title.Font = Enum.Font.GothamBold
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 15
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Notif
        
        local Message = Instance.new("TextLabel")
        Message.BackgroundTransparency = 1
        Message.Position = UDim2.new(0, 15, 0, 35)
        Message.Size = UDim2.new(1, -30, 1, -45)
        Message.Font = Enum.Font.Gotham
        Message.Text = message
        Message.TextColor3 = Color3.fromRGB(200, 200, 200)
        Message.TextSize = 13
        Message.TextWrapped = true
        Message.TextXAlignment = Enum.TextXAlignment.Left
        Message.TextYAlignment = Enum.TextYAlignment.Top
        Message.Parent = Notif
        
        tween(Notif, {Position = UDim2.new(1, -320, 1, -100)}, 0.5)
        
        task.delay(duration, function()
            tween(Notif, {Position = UDim2.new(1, -320, 1, 100)}, 0.5)
            task.wait(0.5)
            Notif:Destroy()
        end)
    end
    
    function Window:LoadConfig()
        loadConfig(windowFlags, windowName)
    end
    
    function Window:SaveConfig()
        saveConfig(windowFlags, windowName)
    end
    
    function Window:Destroy()
        for _, connection in pairs(Nexus.Connections) do
            connection:Disconnect()
        end
        ScreenGui:Destroy()
    end
    
    table.insert(Nexus.Windows, Window)
    
    -- Auto-load config if enabled
    if config.AutoLoad then
        task.delay(1, function()
            Window:LoadConfig()
        end)
    end
    
    return Window
end

return Nexus
