local NexusLib = {
	Flags = {},
	Themes = {
		Dark = {
			Text = Color3.fromRGB(245, 245, 245),
			BG = Color3.fromRGB(18, 18, 18),
			Top = Color3.fromRGB(28, 28, 28),
			Shade = Color3.fromRGB(12, 12, 12),
			NotifBG = Color3.fromRGB(15, 15, 15),
			NotifActions = Color3.fromRGB(235, 235, 235),
			TabBG = Color3.fromRGB(70, 70, 70),
			TabStroke = Color3.fromRGB(80, 80, 80),
			TabSelected = Color3.fromRGB(220, 220, 220),
			TabText = Color3.fromRGB(240, 240, 240),
			SelectedText = Color3.fromRGB(40, 40, 40),
			ElBG = Color3.fromRGB(30, 30, 30),
			ElHover = Color3.fromRGB(35, 35, 35),
			SecondaryElBG = Color3.fromRGB(22, 22, 22),
			ElStroke = Color3.fromRGB(45, 45, 45),
			SecondaryElStroke = Color3.fromRGB(38, 38, 38),
			Slider = Color3.fromRGB(60, 150, 230),
			SliderProgress = Color3.fromRGB(60, 150, 230),
			SliderStroke = Color3.fromRGB(70, 170, 255),
			ToggleBG = Color3.fromRGB(25, 25, 25),
			ToggleOn = Color3.fromRGB(0, 160, 230),
			ToggleOff = Color3.fromRGB(90, 90, 90),
			ToggleOnStroke = Color3.fromRGB(0, 180, 255),
			ToggleOffStroke = Color3.fromRGB(110, 110, 110),
			ToggleOnOuter = Color3.fromRGB(95, 95, 95),
			ToggleOffOuter = Color3.fromRGB(60, 60, 60),
			Input = Color3.fromRGB(25, 25, 25),
			InputStroke = Color3.fromRGB(60, 60, 60),
			Placeholder = Color3.fromRGB(170, 170, 170),
			Dropdown = Color3.fromRGB(35, 35, 35),
			DropdownUnsel = Color3.fromRGB(25, 25, 25)
		},
		Blue = {
			Text = Color3.fromRGB(240, 245, 250),
			BG = Color3.fromRGB(15, 20, 30),
			Top = Color3.fromRGB(25, 30, 45),
			Shade = Color3.fromRGB(10, 15, 25),
			NotifBG = Color3.fromRGB(20, 28, 38),
			NotifActions = Color3.fromRGB(240, 245, 250),
			TabBG = Color3.fromRGB(30, 50, 70),
			TabStroke = Color3.fromRGB(40, 60, 80),
			TabSelected = Color3.fromRGB(80, 140, 200),
			TabText = Color3.fromRGB(200, 220, 240),
			SelectedText = Color3.fromRGB(15, 30, 50),
			ElBG = Color3.fromRGB(25, 40, 60),
			ElHover = Color3.fromRGB(30, 50, 70),
			SecondaryElBG = Color3.fromRGB(25, 38, 52),
			ElStroke = Color3.fromRGB(40, 65, 90),
			SecondaryElStroke = Color3.fromRGB(38, 60, 82),
			Slider = Color3.fromRGB(0, 120, 200),
			SliderProgress = Color3.fromRGB(0, 130, 210),
			SliderStroke = Color3.fromRGB(0, 140, 230),
			ToggleBG = Color3.fromRGB(25, 40, 55),
			ToggleOn = Color3.fromRGB(0, 130, 220),
			ToggleOff = Color3.fromRGB(70, 80, 90),
			ToggleOnStroke = Color3.fromRGB(0, 160, 250),
			ToggleOffStroke = Color3.fromRGB(80, 90, 100),
			ToggleOnOuter = Color3.fromRGB(45, 95, 95),
			ToggleOffOuter = Color3.fromRGB(40, 60, 60),
			Input = Color3.fromRGB(20, 35, 50),
			InputStroke = Color3.fromRGB(50, 70, 90),
			Placeholder = Color3.fromRGB(135, 155, 165),
			Dropdown = Color3.fromRGB(30, 60, 80),
			DropdownUnsel = Color3.fromRGB(20, 35, 50)
		},
		Purple = {
			Text = Color3.fromRGB(245, 240, 250),
			BG = Color3.fromRGB(25, 15, 35),
			Top = Color3.fromRGB(35, 20, 50),
			Shade = Color3.fromRGB(18, 10, 28),
			NotifBG = Color3.fromRGB(28, 18, 38),
			NotifActions = Color3.fromRGB(245, 240, 250),
			TabBG = Color3.fromRGB(55, 35, 75),
			TabStroke = Color3.fromRGB(65, 40, 85),
			TabSelected = Color3.fromRGB(170, 120, 210),
			TabText = Color3.fromRGB(230, 220, 245),
			SelectedText = Color3.fromRGB(45, 15, 55),
			ElBG = Color3.fromRGB(40, 25, 55),
			ElHover = Color3.fromRGB(45, 30, 65),
			SecondaryElBG = Color3.fromRGB(38, 28, 50),
			ElStroke = Color3.fromRGB(65, 45, 80),
			SecondaryElStroke = Color3.fromRGB(60, 40, 75),
			Slider = Color3.fromRGB(110, 50, 160),
			SliderProgress = Color3.fromRGB(120, 60, 170),
			SliderStroke = Color3.fromRGB(140, 70, 190),
			ToggleBG = Color3.fromRGB(40, 25, 50),
			ToggleOn = Color3.fromRGB(130, 50, 170),
			ToggleOff = Color3.fromRGB(85, 40, 105),
			ToggleOnStroke = Color3.fromRGB(150, 70, 190),
			ToggleOffStroke = Color3.fromRGB(110, 60, 130),
			ToggleOnOuter = Color3.fromRGB(85, 35, 115),
			ToggleOffOuter = Color3.fromRGB(75, 50, 105),
			Input = Color3.fromRGB(35, 20, 50),
			InputStroke = Color3.fromRGB(75, 45, 100),
			Placeholder = Color3.fromRGB(170, 145, 195),
			Dropdown = Color3.fromRGB(45, 30, 65),
			DropdownUnsel = Color3.fromRGB(30, 20, 45)
		},
		Green = {
			Text = Color3.fromRGB(25, 55, 25),
			BG = Color3.fromRGB(240, 248, 240),
			Top = Color3.fromRGB(215, 235, 215),
			Shade = Color3.fromRGB(205, 225, 205),
			NotifBG = Color3.fromRGB(245, 252, 245),
			NotifActions = Color3.fromRGB(225, 240, 225),
			TabBG = Color3.fromRGB(220, 240, 220),
			TabStroke = Color3.fromRGB(195, 215, 195),
			TabSelected = Color3.fromRGB(250, 258, 250),
			TabText = Color3.fromRGB(45, 75, 45),
			SelectedText = Color3.fromRGB(15, 55, 15),
			ElBG = Color3.fromRGB(230, 245, 230),
			ElHover = Color3.fromRGB(215, 230, 215),
			SecondaryElBG = Color3.fromRGB(240, 248, 240),
			ElStroke = Color3.fromRGB(185, 205, 185),
			SecondaryElStroke = Color3.fromRGB(185, 205, 185),
			Slider = Color3.fromRGB(85, 155, 85),
			SliderProgress = Color3.fromRGB(65, 125, 65),
			SliderStroke = Color3.fromRGB(95, 175, 95),
			ToggleBG = Color3.fromRGB(220, 240, 220),
			ToggleOn = Color3.fromRGB(55, 125, 55),
			ToggleOff = Color3.fromRGB(145, 170, 145),
			ToggleOnStroke = Color3.fromRGB(75, 145, 75),
			ToggleOffStroke = Color3.fromRGB(125, 145, 125),
			ToggleOnOuter = Color3.fromRGB(95, 155, 95),
			ToggleOffOuter = Color3.fromRGB(155, 175, 155),
			Input = Color3.fromRGB(240, 248, 240),
			InputStroke = Color3.fromRGB(185, 205, 185),
			Placeholder = Color3.fromRGB(115, 135, 115),
			Dropdown = Color3.fromRGB(230, 245, 230),
			DropdownUnsel = Color3.fromRGB(215, 230, 215)
		},
		Light = {
			Text = Color3.fromRGB(35, 35, 35),
			BG = Color3.fromRGB(248, 248, 248),
			Top = Color3.fromRGB(235, 235, 235),
			Shade = Color3.fromRGB(205, 205, 205),
			NotifBG = Color3.fromRGB(252, 252, 252),
			NotifActions = Color3.fromRGB(245, 245, 245),
			TabBG = Color3.fromRGB(240, 240, 240),
			TabStroke = Color3.fromRGB(220, 220, 220),
			TabSelected = Color3.fromRGB(258, 258, 258),
			TabText = Color3.fromRGB(75, 75, 75),
			SelectedText = Color3.fromRGB(0, 0, 0),
			ElBG = Color3.fromRGB(245, 245, 245),
			ElHover = Color3.fromRGB(230, 230, 230),
			SecondaryElBG = Color3.fromRGB(240, 240, 240),
			ElStroke = Color3.fromRGB(215, 215, 215),
			SecondaryElStroke = Color3.fromRGB(215, 215, 215),
			Slider = Color3.fromRGB(145, 175, 215),
			SliderProgress = Color3.fromRGB(95, 145, 195),
			SliderStroke = Color3.fromRGB(115, 165, 215),
			ToggleBG = Color3.fromRGB(225, 225, 225),
			ToggleOn = Color3.fromRGB(0, 140, 210),
			ToggleOff = Color3.fromRGB(145, 145, 145),
			ToggleOnStroke = Color3.fromRGB(0, 165, 250),
			ToggleOffStroke = Color3.fromRGB(165, 165, 165),
			ToggleOnOuter = Color3.fromRGB(95, 95, 95),
			ToggleOffOuter = Color3.fromRGB(175, 175, 175),
			Input = Color3.fromRGB(245, 245, 245),
			InputStroke = Color3.fromRGB(185, 185, 185),
			Placeholder = Color3.fromRGB(135, 135, 135),
			Dropdown = Color3.fromRGB(235, 235, 235),
			DropdownUnsel = Color3.fromRGB(225, 225, 225)
		}
	}
}

local function svc(n)
	local s = game:GetService(n)
	return cloneref and cloneref(s) or s
end

local HttpService = svc("HttpService")
local RS = svc("RunService")
local UIS = svc("UserInputService")
local TS = svc("TweenService")
local Players = svc("Players")
local CG = svc("CoreGui")

local useStudio = RS:IsStudio()
local NexusFolder = "Nexus"
local ConfigFolder = NexusFolder.."/Configs"
local ConfigExt = ".nxs"

local curTheme = NexusLib.Themes.Dark
local mainUI, mainFrame, topbar, tabList, pages, notifs
local dragging, minimized, hidden = false, false, false
local debounce = false
local cfgName, cfgEnabled = nil, false
local globalLoaded = false

local function tween(obj, time, props)
	TS:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Exponential), props):Play()
end

local function packColor(c)
	return {R = c.R * 255, G = c.G * 255, B = c.B * 255}
end

local function unpackColor(c)
	return Color3.fromRGB(c.R, c.G, c.B)
end

local function saveConfig()
	if not cfgEnabled or not globalLoaded then return end
	local data = {}
	for i, v in pairs(NexusLib.Flags) do
		if v.Type == "ColorPicker" then
			data[i] = packColor(v.Color)
		else
			data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
		end
	end
	if writefile then
		writefile(ConfigFolder.."/"..cfgName..ConfigExt, HttpService:JSONEncode(data))
	end
end

local function loadConfig(cfg)
	local success, data = pcall(function() return HttpService:JSONDecode(cfg) end)
	if not success then return end
	for flagName, flag in pairs(NexusLib.Flags) do
		local flagVal = data[flagName]
		if flagVal then
			task.spawn(function()
				if flag.Type == "ColorPicker" then
					flag:Set(unpackColor(flagVal))
				else
					flag:Set(flagVal)
				end
			end)
		end
	end
end

function NexusLib:Notify(data)
	task.spawn(function()
		local notif = notifs.Template:Clone()
		notif.Name = data.Title or "Notification"
		notif.Parent = notifs
		notif.Visible = false
		
		notif.Title.Text = data.Title or "Title"
		notif.Desc.Text = data.Content or "Content"
		notif.Title.TextColor3 = curTheme.Text
		notif.Desc.TextColor3 = curTheme.Text
		notif.BackgroundColor3 = curTheme.NotifBG
		notif.UIStroke.Color = curTheme.Text
		
		notif.BackgroundTransparency = 1
		notif.Title.TextTransparency = 1
		notif.Desc.TextTransparency = 1
		notif.UIStroke.Transparency = 1
		notif.Size = UDim2.new(1, 0, 0, 0)
		
		task.wait()
		notif.Visible = true
		
		local bounds = {notif.Title.TextBounds.Y, notif.Desc.TextBounds.Y}
		tween(notif, 0.5, {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 25, 55))})
		task.wait(0.15)
		tween(notif, 0.4, {BackgroundTransparency = 0.4})
		tween(notif.Title, 0.3, {TextTransparency = 0})
		task.wait(0.05)
		tween(notif.Desc, 0.3, {TextTransparency = 0.3})
		tween(notif.UIStroke, 0.4, {Transparency = 0.9})
		
		task.wait(data.Duration or 3)
		
		tween(notif, 0.4, {BackgroundTransparency = 1})
		tween(notif.UIStroke, 0.4, {Transparency = 1})
		tween(notif.Title, 0.3, {TextTransparency = 1})
		tween(notif.Desc, 0.3, {TextTransparency = 1})
		tween(notif, 0.8, {Size = UDim2.new(1, -80, 0, 0)})
		task.wait(0.8)
		notif:Destroy()
	end)
end

local function hide()
	debounce = true
	tween(mainFrame, 0.5, {Size = UDim2.new(0, 480, 0, 0)})
	tween(topbar, 0.5, {Size = UDim2.new(0, 480, 0, 40)})
	tween(mainFrame, 0.5, {BackgroundTransparency = 1})
	tween(topbar, 0.5, {BackgroundTransparency = 1})
	tween(topbar.Title, 0.5, {TextTransparency = 1})
	for _, btn in ipairs(topbar:GetChildren()) do
		if btn:IsA("TextButton") then
			tween(btn, 0.5, {TextTransparency = 1})
		end
	end
	for _, tab in ipairs(tabList:GetChildren()) do
		if tab:IsA("TextButton") then
			tween(tab, 0.3, {BackgroundTransparency = 1})
			tween(tab, 0.3, {TextTransparency = 1})
		end
	end
	for _, page in ipairs(pages:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, el in ipairs(page:GetChildren()) do
				if el:IsA("Frame") then
					el.Visible = false
				end
			end
		end
	end
	task.wait(0.5)
	mainFrame.Visible = false
	debounce = false
end

local function unhide()
	debounce = true
	mainFrame.Visible = true
	tween(mainFrame, 0.5, {Size = UDim2.new(0, 520, 0, 420)})
	tween(topbar, 0.5, {Size = UDim2.new(1, 0, 0, 40)})
	tween(mainFrame, 0.5, {BackgroundTransparency = 0})
	tween(topbar, 0.5, {BackgroundTransparency = 0})
	tween(topbar.Title, 0.5, {TextTransparency = 0})
	for _, btn in ipairs(topbar:GetChildren()) do
		if btn:IsA("TextButton") then
			tween(btn, 0.5, {TextTransparency = 0})
		end
	end
	for _, tab in ipairs(tabList:GetChildren()) do
		if tab:IsA("TextButton") then
			tween(tab, 0.3, {BackgroundTransparency = 0.7})
			tween(tab, 0.3, {TextTransparency = 0.2})
		end
	end
	for _, page in ipairs(pages:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, el in ipairs(page:GetChildren()) do
				if el:IsA("Frame") then
					el.Visible = true
				end
			end
		end
	end
	task.wait(0.5)
	hidden = false
	debounce = false
end

local function minimize()
	debounce = true
	for _, tab in ipairs(tabList:GetChildren()) do
		if tab:IsA("TextButton") then
			tween(tab, 0.3, {BackgroundTransparency = 1})
			tween(tab, 0.3, {TextTransparency = 1})
		end
	end
	for _, page in ipairs(pages:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, el in ipairs(page:GetChildren()) do
				if el:IsA("Frame") then
					el.Visible = false
				end
			end
		end
	end
	tween(mainFrame, 0.5, {Size = UDim2.new(0, 520, 0, 40)})
	task.wait(0.5)
	pages.Visible = false
	tabList.Visible = false
	debounce = false
end

local function maximize()
	debounce = true
	tween(mainFrame, 0.5, {Size = UDim2.new(0, 520, 0, 420)})
	tabList.Visible = true
	task.wait(0.2)
	pages.Visible = true
	for _, page in ipairs(pages:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, el in ipairs(page:GetChildren()) do
				if el:IsA("Frame") then
					el.Visible = true
				end
			end
		end
	end
	for _, tab in ipairs(tabList:GetChildren()) do
		if tab:IsA("TextButton") then
			tween(tab, 0.3, {BackgroundTransparency = 0.7})
			tween(tab, 0.3, {TextTransparency = 0.2})
		end
	end
	task.wait(0.5)
	debounce = false
end

function NexusLib:Init(cfg)
	cfg = cfg or {}
	local name = cfg.Name or "Nexus"
	local theme = cfg.Theme or "Dark"
	local keybind = cfg.Keybind or "K"
	
	if NexusLib.Themes[theme] then
		curTheme = NexusLib.Themes[theme]
	end
	
	if cfg.ConfigSaving then
		cfgName = cfg.ConfigSaving.FileName or tostring(game.PlaceId)
		cfgEnabled = cfg.ConfigSaving.Enabled or false
		if cfgEnabled then
			if not isfolder(NexusFolder) then makefolder(NexusFolder) end
			if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
		end
	end
	
	mainUI = Instance.new("ScreenGui")
	mainUI.Name = "Nexus_"..math.random(1000, 9999)
	mainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	mainUI.DisplayOrder = 100
	
	if gethui then
		mainUI.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(mainUI)
		mainUI.Parent = CG
	else
		mainUI.Parent = CG
	end
	
	notifs = Instance.new("Frame")
	notifs.Name = "Notifs"
	notifs.Size = UDim2.new(0, 300, 1, -20)
	notifs.Position = UDim2.new(1, -310, 0, 10)
	notifs.BackgroundTransparency = 1
	notifs.Parent = mainUI
	
	local notifLayout = Instance.new("UIListLayout")
	notifLayout.Padding = UDim.new(0, 8)
	notifLayout.Parent = notifs
	
	local notifTemplate = Instance.new("Frame")
	notifTemplate.Name = "Template"
	notifTemplate.Size = UDim2.new(1, 0, 0, 60)
	notifTemplate.BackgroundColor3 = curTheme.NotifBG
	notifTemplate.BorderSizePixel = 0
	notifTemplate.Visible = false
	notifTemplate.Parent = notifs
	
	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 6)
	notifCorner.Parent = notifTemplate
	
	local notifStroke = Instance.new("UIStroke")
	notifStroke.Color = curTheme.Text
	notifStroke.Thickness = 1
	notifStroke.Transparency = 0.9
	notifStroke.Parent = notifTemplate
	
	local notifTitle = Instance.new("TextLabel")
	notifTitle.Name = "Title"
	notifTitle.Size = UDim2.new(1, -20, 0, 20)
	notifTitle.Position = UDim2.new(0, 10, 0, 8)
	notifTitle.BackgroundTransparency = 1
	notifTitle.Text = "Title"
	notifTitle.TextColor3 = curTheme.Text
	notifTitle.TextSize = 14
	notifTitle.Font = Enum.Font.GothamBold
	notifTitle.TextXAlignment = Enum.TextXAlignment.Left
	notifTitle.Parent = notifTemplate
	
	local notifDesc = Instance.new("TextLabel")
	notifDesc.Name = "Desc"
	notifDesc.Size = UDim2.new(1, -20, 0, 25)
	notifDesc.Position = UDim2.new(0, 10, 0, 28)
	notifDesc.BackgroundTransparency = 1
	notifDesc.Text = "Description"
	notifDesc.TextColor3 = curTheme.Text
	notifDesc.TextSize = 12
	notifDesc.Font = Enum.Font.Gotham
	notifDesc.TextXAlignment = Enum.TextXAlignment.Left
	notifDesc.TextWrapped = true
	notifDesc.Parent = notifTemplate
	
	mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(0, 520, 0, 420)
	mainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
	mainFrame.BackgroundColor3 = curTheme.BG
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = mainUI
	
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 6)
	mainCorner.Parent = mainFrame
	
	topbar = Instance.new("Frame")
	topbar.Name = "Top"
	topbar.Size = UDim2.new(1, 0, 0, 40)
	topbar.BackgroundColor3 = curTheme.Top
	topbar.BorderSizePixel = 0
	topbar.Parent = mainFrame
	
	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 6)
	topCorner.Parent = topbar
	
	local topFix = Instance.new("Frame")
	topFix.Size = UDim2.new(1, 0, 0, 6)
	topFix.Position = UDim2.new(0, 0, 1, -6)
	topFix.BackgroundColor3 = curTheme.Top
	topFix.BorderSizePixel = 0
	topFix.Parent = topbar
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -100, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = curTheme.Text
	title.TextSize = 17
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topbar
	
	local minBtn = Instance.new("TextButton")
	minBtn.Name = "Min"
	minBtn.Size = UDim2.new(0, 30, 0, 30)
	minBtn.Position = UDim2.new(1, -70, 0, 5)
	minBtn.BackgroundTransparency = 1
	minBtn.Text = "_"
	minBtn.TextColor3 = curTheme.Text
	minBtn.TextSize = 18
	minBtn.Font = Enum.Font.GothamBold
	minBtn.Parent = topbar
	
	minBtn.MouseButton1Click:Connect(function()
		if debounce then return end
		if minimized then
			minimized = false
			maximize()
		else
			minimized = true
			minimize()
		end
	end)
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "Close"
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 5)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "X"
	closeBtn.TextColor3 = curTheme.Text
	closeBtn.TextSize = 18
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = topbar
	
	closeBtn.MouseButton1Click:Connect(function()
		mainUI:Destroy()
	end)
	
	local dragArea = Instance.new("Frame")
	dragArea.Name = "Drag"
	dragArea.Size = UDim2.new(1, -80, 1, 0)
	dragArea.BackgroundTransparency = 1
	dragArea.Parent = topbar
	
	local dragStart, startPos
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UIS.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == Enum.KeyCode[keybind] then
			if hidden then
				unhide()
			else
				hide()
				hidden = true
			end
		end
	end)
	
	tabList = Instance.new("Frame")
	tabList.Name = "Tabs"
	tabList.Size = UDim2.new(1, -10, 0, 35)
	tabList.Position = UDim2.new(0, 5, 0, 45)
	tabList.BackgroundTransparency = 1
	tabList.Parent = mainFrame
	
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.Parent = tabList
	
	pages = Instance.new("Frame")
	pages.Name = "Pages"
	pages.Size = UDim2.new(1, -10, 1, -90)
	pages.Position = UDim2.new(0, 5, 0, 85)
	pages.BackgroundTransparency = 1
	pages.Parent = mainFrame
	
	local win = {}
	win.Tabs = {}
	
	function win:Tab(tabName)
		local tab = {}
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tabName
		tabBtn.Size = UDim2.new(0, 100, 0, 30)
		tabBtn.BackgroundColor3 = curTheme.TabBG
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = tabName
		tabBtn.TextColor3 = curTheme.TabText
		tabBtn.TextSize = 14
		tabBtn.Font = Enum.Font.Gotham
		tabBtn.Parent = tabList
		
		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0, 4)
		tabCorner.Parent = tabBtn
		
		local tabStroke = Instance.new("UIStroke")
		tabStroke.Color = curTheme.TabStroke
		tabStroke.Thickness = 1
		tabStroke.Transparency = 0.5
		tabStroke.Parent = tabBtn
		
		local page = Instance.new("ScrollingFrame")
		page.Name = tabName
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 4
		page.ScrollBarImageColor3 = curTheme.Text
		page.ScrollBarImageTransparency = 0.7
		page.Visible = false
		page.Parent = pages
		
		local pageLayout = Instance.new("UIListLayout")
		pageLayout.Padding = UDim.new(0, 8)
		pageLayout.Parent = page
		
		tabBtn.MouseButton1Click:Connect(function()
			for _, p in pairs(pages:GetChildren()) do
				if p:IsA("ScrollingFrame") then
					p.Visible = false
				end
			end
			for _, t in pairs(tabList:GetChildren()) do
				if t:IsA("TextButton") then
					t.BackgroundColor3 = curTheme.TabBG
					t.TextColor3 = curTheme.TabText
				end
			end
			page.Visible = true
			tabBtn.BackgroundColor3 = curTheme.TabSelected
			tabBtn.TextColor3 = curTheme.SelectedText
		end)
		
		if #win.Tabs == 0 then
			page.Visible = true
			tabBtn.BackgroundColor3 = curTheme.TabSelected
			tabBtn.TextColor3 = curTheme.SelectedText
		end
		
		table.insert(win.Tabs, tab)
		
		function tab:Section(secName)
			local sec = Instance.new("TextLabel")
			sec.Name = "Section"
			sec.Size = UDim2.new(1, -5, 0, 25)
			sec.BackgroundTransparency = 1
			sec.Text = secName
			sec.TextColor3 = curTheme.Text
			sec.TextSize = 15
			sec.Font = Enum.Font.GothamBold
			sec.TextXAlignment = Enum.TextXAlignment.Left
			sec.TextTransparency = 0.4
			sec.Parent = page
			return sec
		end
		
		function tab:Divider()
			local div = Instance.new("Frame")
			div.Name = "Divider"
			div.Size = UDim2.new(1, -5, 0, 1)
			div.BackgroundColor3 = curTheme.ElStroke
			div.BorderSizePixel = 0
			div.BackgroundTransparency = 0.8
			div.Parent = page
			return div
		end
		
		function tab:Label(txt)
			local lbl = Instance.new("TextLabel")
			lbl.Name = "Label"
			lbl.Size = UDim2.new(1, -5, 0, 30)
			lbl.BackgroundColor3 = curTheme.SecondaryElBG
			lbl.BorderSizePixel = 0
			lbl.Text = txt
			lbl.TextColor3 = curTheme.Text
			lbl.TextSize = 13
			lbl.Font = Enum.Font.Gotham
			lbl.Parent = page
			
			local lblCorner = Instance.new("UICorner")
			lblCorner.CornerRadius = UDim.new(0, 4)
			lblCorner.Parent = lbl
			
			local lblStroke = Instance.new("UIStroke")
			lblStroke.Color = curTheme.SecondaryElStroke
			lblStroke.Thickness = 1
			lblStroke.Parent = lbl
			
			local lblObj = {}
			function lblObj:Set(val)
				lbl.Text = val
			end
			return lblObj
		end
		
		function tab:Paragraph(parCfg)
			local par = Instance.new("Frame")
			par.Name = "Paragraph"
			par.Size = UDim2.new(1, -5, 0, 60)
			par.BackgroundColor3 = curTheme.SecondaryElBG
			par.BorderSizePixel = 0
			par.Parent = page
			
			local parCorner = Instance.new("UICorner")
			parCorner.CornerRadius = UDim.new(0, 4)
			parCorner.Parent = par
			
			local parStroke = Instance.new("UIStroke")
			parStroke.Color = curTheme.SecondaryElStroke
			parStroke.Thickness = 1
			parStroke.Parent = par
			
			local parTitle = Instance.new("TextLabel")
			parTitle.Size = UDim2.new(1, -20, 0, 20)
			parTitle.Position = UDim2.new(0, 10, 0, 5)
			parTitle.BackgroundTransparency = 1
			parTitle.Text = parCfg.Title
			parTitle.TextColor3 = curTheme.Text
			parTitle.TextSize = 14
			parTitle.Font = Enum.Font.GothamBold
			parTitle.TextXAlignment = Enum.TextXAlignment.Left
			parTitle.Parent = par
			
			local parContent = Instance.new("TextLabel")
			parContent.Size = UDim2.new(1, -20, 0, 30)
			parContent.Position = UDim2.new(0, 10, 0, 25)
			parContent.BackgroundTransparency = 1
			parContent.Text = parCfg.Content
			parContent.TextColor3 = curTheme.Text
			parContent.TextSize = 12
			parContent.Font = Enum.Font.Gotham
			parContent.TextXAlignment = Enum.TextXAlignment.Left
			parContent.TextWrapped = true
			parContent.Parent = par
			
			local parObj = {}
			function parObj:Set(newCfg)
				parTitle.Text = newCfg.Title
				parContent.Text = newCfg.Content
			end
			return parObj
		end
		
		function tab:Button(btnCfg)
			local btn = Instance.new("TextButton")
			btn.Name = btnCfg.Name
			btn.Size = UDim2.new(1, -5, 0, 40)
			btn.BackgroundColor3 = curTheme.ElBG
			btn.BorderSizePixel = 0
			btn.Text = btnCfg.Name
			btn.TextColor3 = curTheme.Text
			btn.TextSize = 14
			btn.Font = Enum.Font.Gotham
			btn.Parent = page
			
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 4)
			btnCorner.Parent = btn
			
			local btnStroke = Instance.new("UIStroke")
			btnStroke.Color = curTheme.ElStroke
			btnStroke.Thickness = 1
			btnStroke.Parent = btn
			
			btn.MouseEnter:Connect(function()
				tween(btn, 0.3, {BackgroundColor3 = curTheme.ElHover})
			end)
			
			btn.MouseLeave:Connect(function()
				tween(btn, 0.3, {BackgroundColor3 = curTheme.ElBG})
			end)
			
			btn.MouseButton1Click:Connect(function()
				pcall(btnCfg.Callback)
				saveConfig()
			end)
			
			local btnObj = {}
			function btnObj:Set(newName)
				btn.Text = newName
			end
			return btnObj
		end
		
		function tab:Toggle(togCfg)
			togCfg.Type = "Toggle"
			local togVal = togCfg.Default or false
			
			local togFrame = Instance.new("Frame")
			togFrame.Name = togCfg.Name
			togFrame.Size = UDim2.new(1, -5, 0, 40)
			togFrame.BackgroundColor3 = curTheme.ElBG
			togFrame.BorderSizePixel = 0
			togFrame.Parent = page
			
			local togCorner = Instance.new("UICorner")
			togCorner.CornerRadius = UDim.new(0, 4)
			togCorner.Parent = togFrame
			
			local togStroke = Instance.new("UIStroke")
			togStroke.Color = curTheme.ElStroke
			togStroke.Thickness = 1
			togStroke.Parent = togFrame
			
			local togLabel = Instance.new("TextLabel")
			togLabel.Size = UDim2.new(1, -60, 1, 0)
			togLabel.Position = UDim2.new(0, 10, 0, 0)
			togLabel.BackgroundTransparency = 1
			togLabel.Text = togCfg.Name
			togLabel.TextColor3 = curTheme.Text
			togLabel.TextSize = 14
			togLabel.Font = Enum.Font.Gotham
			togLabel.TextXAlignment = Enum.TextXAlignment.Left
			togLabel.Parent = togFrame
			
			local togSwitch = Instance.new("Frame")
			togSwitch.Size = UDim2.new(0, 45, 0, 22)
			togSwitch.Position = UDim2.new(1, -50, 0.5, -11)
			togSwitch.BackgroundColor3 = curTheme.ToggleBG
			togSwitch.BorderSizePixel = 0
			togSwitch.Parent = togFrame
			
			local switchCorner = Instance.new("UICorner")
			switchCorner.CornerRadius = UDim.new(1, 0)
			switchCorner.Parent = togSwitch
			
			local switchStroke = Instance.new("UIStroke")
			switchStroke.Color = togVal and curTheme.ToggleOnOuter or curTheme.ToggleOffOuter
			switchStroke.Thickness = 1
			switchStroke.Parent = togSwitch
			
			local togCircle = Instance.new("Frame")
			togCircle.Size = UDim2.new(0, 16, 0, 16)
			togCircle.Position = togVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
			togCircle.BackgroundColor3 = togVal and curTheme.ToggleOn or curTheme.ToggleOff
			togCircle.BorderSizePixel = 0
			togCircle.Parent = togSwitch
			
			local circleCorner = Instance.new("UICorner")
			circleCorner.CornerRadius = UDim.new(1, 0)
			circleCorner.Parent = togCircle
			
			local circleStroke = Instance.new("UIStroke")
			circleStroke.Color = togVal and curTheme.ToggleOnStroke or curTheme.ToggleOffStroke
			circleStroke.Thickness = 1
			circleStroke.Parent = togCircle
			
			local togBtn = Instance.new("TextButton")
			togBtn.Size = UDim2.new(1, 0, 1, 0)
			togBtn.BackgroundTransparency = 1
			togBtn.Text = ""
			togBtn.Parent = togFrame
			
			togFrame.MouseEnter:Connect(function()
				tween(togFrame, 0.3, {BackgroundColor3 = curTheme.ElHover})
			end)
			
			togFrame.MouseLeave:Connect(function()
				tween(togFrame, 0.3, {BackgroundColor3 = curTheme.ElBG})
			end)
			
			togBtn.MouseButton1Click:Connect(function()
				togVal = not togVal
				tween(togCircle, 0.3, {
					Position = togVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = togVal and curTheme.ToggleOn or curTheme.ToggleOff
				})
				tween(circleStroke, 0.3, {Color = togVal and curTheme.ToggleOnStroke or curTheme.ToggleOffStroke})
				tween(switchStroke, 0.3, {Color = togVal and curTheme.ToggleOnOuter or curTheme.ToggleOffOuter})
				pcall(togCfg.Callback, togVal)
				saveConfig()
			end)
			
			togCfg.CurrentValue = togVal
			
			function togCfg:Set(val)
				togVal = val
				togCfg.CurrentValue = val
				tween(togCircle, 0.3, {
					Position = togVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = togVal and curTheme.ToggleOn or curTheme.ToggleOff
				})
				tween(circleStroke, 0.3, {Color = togVal and curTheme.ToggleOnStroke or curTheme.ToggleOffStroke})
				tween(switchStroke, 0.3, {Color = togVal and curTheme.ToggleOnOuter or curTheme.ToggleOffOuter})
				pcall(togCfg.Callback, togVal)
				saveConfig()
			end
			
			if togCfg.Flag then
				NexusLib.Flags[togCfg.Flag] = togCfg
			end
			
			return togCfg
		end
		
		function tab:Slider(sldCfg)
			sldCfg.Type = "Slider"
			local sldVal = sldCfg.Default or sldCfg.Min
			local sldDrag = false
			
			local sldFrame = Instance.new("Frame")
			sldFrame.Name = sldCfg.Name
			sldFrame.Size = UDim2.new(1, -5, 0, 50)
			sldFrame.BackgroundColor3 = curTheme.ElBG
			sldFrame.BorderSizePixel = 0
			sldFrame.Parent = page
			
			local sldCorner = Instance.new("UICorner")
			sldCorner.CornerRadius = UDim.new(0, 4)
			sldCorner.Parent = sldFrame
			
			local sldStroke = Instance.new("UIStroke")
			sldStroke.Color = curTheme.ElStroke
			sldStroke.Thickness = 1
			sldStroke.Parent = sldFrame
			
			local sldLabel = Instance.new("TextLabel")
			sldLabel.Size = UDim2.new(1, -20, 0, 20)
			sldLabel.Position = UDim2.new(0, 10, 0, 5)
			sldLabel.BackgroundTransparency = 1
			sldLabel.Text = sldCfg.Name
			sldLabel.TextColor3 = curTheme.Text
			sldLabel.TextSize = 14
			sldLabel.Font = Enum.Font.Gotham
			sldLabel.TextXAlignment = Enum.TextXAlignment.Left
			sldLabel.Parent = sldFrame
			
			local sldValue = Instance.new("TextLabel")
			sldValue.Size = UDim2.new(0, 50, 0, 20)
			sldValue.Position = UDim2.new(1, -60, 0, 5)
			sldValue.BackgroundTransparency = 1
			sldValue.Text = tostring(sldVal)..(sldCfg.Suffix or "")
			sldValue.TextColor3 = curTheme.Text
			sldValue.TextSize = 14
			sldValue.Font = Enum.Font.GothamBold
			sldValue.TextXAlignment = Enum.TextXAlignment.Right
			sldValue.Parent = sldFrame
			
			local sldBar = Instance.new("Frame")
			sldBar.Size = UDim2.new(1, -20, 0, 6)
			sldBar.Position = UDim2.new(0, 10, 1, -15)
			sldBar.BackgroundColor3 = curTheme.Input
			sldBar.BorderSizePixel = 0
			sldBar.Parent = sldFrame
			
			local barCorner = Instance.new("UICorner")
			barCorner.CornerRadius = UDim.new(1, 0)
			barCorner.Parent = sldBar
			
			local barStroke = Instance.new("UIStroke")
			barStroke.Color = curTheme.SliderStroke
			barStroke.Thickness = 1
			barStroke.Transparency = 0.4
			barStroke.Parent = sldBar
			
			local sldFill = Instance.new("Frame")
			sldFill.Size = UDim2.new((sldVal - sldCfg.Min) / (sldCfg.Max - sldCfg.Min), 0, 1, 0)
			sldFill.BackgroundColor3 = curTheme.SliderProgress
			sldFill.BorderSizePixel = 0
			sldFill.Parent = sldBar
			
			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1, 0)
			fillCorner.Parent = sldFill
			
			local fillStroke = Instance.new("UIStroke")
			fillStroke.Color = curTheme.SliderStroke
			fillStroke.Thickness = 1
			fillStroke.Transparency = 0.3
			fillStroke.Parent = sldFill
			
			sldFrame.MouseEnter:Connect(function()
				tween(sldFrame, 0.3, {BackgroundColor3 = curTheme.ElHover})
			end)
			
			sldFrame.MouseLeave:Connect(function()
				tween(sldFrame, 0.3, {BackgroundColor3 = curTheme.ElBG})
			end)
			
			sldBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sldDrag = true
					tween(barStroke, 0.3, {Transparency = 1})
					tween(fillStroke, 0.3, {Transparency = 1})
				end
			end)
			
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sldDrag = false
					tween(barStroke, 0.3, {Transparency = 0.4})
					tween(fillStroke, 0.3, {Transparency = 0.3})
				end
			end)
			
			RS.RenderStepped:Connect(function()
				if sldDrag then
					local mousePos = UIS:GetMouseLocation().X
					local barPos = sldBar.AbsolutePosition.X
					local barSize = sldBar.AbsoluteSize.X
					local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
					local newVal = sldCfg.Min + (sldCfg.Max - sldCfg.Min) * percent
					newVal = math.floor(newVal / (sldCfg.Increment or 1) + 0.5) * (sldCfg.Increment or 1)
					newVal = math.clamp(newVal, sldCfg.Min, sldCfg.Max)
					if sldVal ~= newVal then
						sldVal = newVal
						sldCfg.CurrentValue = newVal
						tween(sldFill, 0.2, {Size = UDim2.new(percent, 0, 1, 0)})
						sldValue.Text = tostring(sldVal)..(sldCfg.Suffix or "")
						pcall(sldCfg.Callback, sldVal)
						saveConfig()
					end
				end
			end)
			
			sldCfg.CurrentValue = sldVal
			
			function sldCfg:Set(val)
				sldVal = math.clamp(val, sldCfg.Min, sldCfg.Max)
				sldCfg.CurrentValue = sldVal
				local percent = (sldVal - sldCfg.Min) / (sldCfg.Max - sldCfg.Min)
				tween(sldFill, 0.3, {Size = UDim2.new(percent, 0, 1, 0)})
				sldValue.Text = tostring(sldVal)..(sldCfg.Suffix or "")
				pcall(sldCfg.Callback, sldVal)
				saveConfig()
			end
			
			if sldCfg.Flag then
				NexusLib.Flags[sldCfg.Flag] = sldCfg
			end
			
			return sldCfg
		end
		
		function tab:Dropdown(ddCfg)
			ddCfg.Type = "Dropdown"
			local ddVal = ddCfg.Default or ddCfg.Options[1]
			local ddOpen = false
			
			local ddFrame = Instance.new("Frame")
			ddFrame.Name = ddCfg.Name
			ddFrame.Size = UDim2.new(1, -5, 0, 40)
			ddFrame.BackgroundColor3 = curTheme.ElBG
			ddFrame.BorderSizePixel = 0
			ddFrame.Parent = page
			
			local ddCorner = Instance.new("UICorner")
			ddCorner.CornerRadius = UDim.new(0, 4)
			ddCorner.Parent = ddFrame
			
			local ddStroke = Instance.new("UIStroke")
			ddStroke.Color = curTheme.ElStroke
			ddStroke.Thickness = 1
			ddStroke.Parent = ddFrame
			
			local ddLabel = Instance.new("TextLabel")
			ddLabel.Size = UDim2.new(1, -100, 1, 0)
			ddLabel.Position = UDim2.new(0, 10, 0, 0)
			ddLabel.BackgroundTransparency = 1
			ddLabel.Text = ddCfg.Name
			ddLabel.TextColor3 = curTheme.Text
			ddLabel.TextSize = 14
			ddLabel.Font = Enum.Font.Gotham
			ddLabel.TextXAlignment = Enum.TextXAlignment.Left
			ddLabel.Parent = ddFrame
			
			local ddSelected = Instance.new("TextLabel")
			ddSelected.Size = UDim2.new(0, 80, 0, 25)
			ddSelected.Position = UDim2.new(1, -90, 0.5, -12.5)
			ddSelected.BackgroundColor3 = curTheme.Input
			ddSelected.BorderSizePixel = 0
			ddSelected.Text = ddVal
			ddSelected.TextColor3 = curTheme.Text
			ddSelected.TextSize = 12
			ddSelected.Font = Enum.Font.Gotham
			ddSelected.Parent = ddFrame
			
			local selCorner = Instance.new("UICorner")
			selCorner.CornerRadius = UDim.new(0, 4)
			selCorner.Parent = ddSelected
			
			local selStroke = Instance.new("UIStroke")
			selStroke.Color = curTheme.InputStroke
			selStroke.Thickness = 1
			selStroke.Parent = ddSelected
			
			local ddArrow = Instance.new("TextLabel")
			ddArrow.Size = UDim2.new(0, 20, 1, 0)
			ddArrow.Position = UDim2.new(1, -25, 0, 0)
			ddArrow.BackgroundTransparency = 1
			ddArrow.Text = "▼"
			ddArrow.TextColor3 = curTheme.Text
			ddArrow.TextSize = 10
			ddArrow.Font = Enum.Font.Gotham
			ddArrow.Rotation = 180
			ddArrow.Parent = ddFrame
			
			local ddList = Instance.new("Frame")
			ddList.Size = UDim2.new(1, -5, 0, 0)
			ddList.Position = UDim2.new(0, 0, 1, 5)
			ddList.BackgroundColor3 = curTheme.ElBG
			ddList.BorderSizePixel = 0
			ddList.Visible = false
			ddList.ClipsDescendants = true
			ddList.Parent = ddFrame
			
			local listCorner = Instance.new("UICorner")
			listCorner.CornerRadius = UDim.new(0, 4)
			listCorner.Parent = ddList
			
			local listStroke = Instance.new("UIStroke")
			listStroke.Color = curTheme.ElStroke
			listStroke.Thickness = 1
			listStroke.Parent = ddList
			
			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0, 2)
			listLayout.Parent = ddList
			
			for _, opt in pairs(ddCfg.Options) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1, 0, 0, 30)
				optBtn.BackgroundColor3 = curTheme.DropdownUnsel
				optBtn.BorderSizePixel = 0
				optBtn.Text = opt
				optBtn.TextColor3 = curTheme.Text
				optBtn.TextSize = 12
				optBtn.Font = Enum.Font.Gotham
				optBtn.Parent = ddList
				
				local optCorner = Instance.new("UICorner")
				optCorner.CornerRadius = UDim.new(0, 4)
				optCorner.Parent = optBtn
				
				local optStroke = Instance.new("UIStroke")
				optStroke.Color = curTheme.ElStroke
				optStroke.Thickness = 1
				optStroke.Transparency = opt == ddVal and 1 or 0
				optStroke.Parent = optBtn
				
				if opt == ddVal then
					optBtn.BackgroundColor3 = curTheme.Dropdown
				end
				
				optBtn.MouseButton1Click:Connect(function()
					ddVal = opt
					ddCfg.CurrentOption = opt
					ddSelected.Text = opt
					ddOpen = false
					ddList.Visible = false
					tween(ddFrame, 0.2, {Size = UDim2.new(1, -5, 0, 40)})
					tween(ddArrow, 0.3, {Rotation = 180})
					for _, o in pairs(ddList:GetChildren()) do
						if o:IsA("TextButton") then
							if o.Text == opt then
								o.BackgroundColor3 = curTheme.Dropdown
								o.UIStroke.Transparency = 1
							else
								o.BackgroundColor3 = curTheme.DropdownUnsel
								o.UIStroke.Transparency = 0
							end
						end
					end
					pcall(ddCfg.Callback, opt)
					saveConfig()
				end)
			end
			
			local ddBtn = Instance.new("TextButton")
			ddBtn.Size = UDim2.new(1, 0, 1, 0)
			ddBtn.BackgroundTransparency = 1
			ddBtn.Text = ""
			ddBtn.ZIndex = 2
			ddBtn.Parent = ddFrame
			
			ddFrame.MouseEnter:Connect(function()
				if not ddOpen then
					tween(ddFrame, 0.3, {BackgroundColor3 = curTheme.ElHover})
				end
			end)
			
			ddFrame.MouseLeave:Connect(function()
				tween(ddFrame, 0.3, {BackgroundColor3 = curTheme.ElBG})
			end)
			
			ddBtn.MouseButton1Click:Connect(function()
				if debounce then return end
				ddOpen = not ddOpen
				if ddOpen then
					debounce = true
					ddList.Visible = true
					local listHeight = #ddCfg.Options * 32
					tween(ddFrame, 0.3, {Size = UDim2.new(1, -5, 0, 40 + listHeight + 5)})
					tween(ddList, 0.3, {Size = UDim2.new(1, -5, 0, listHeight)})
					tween(ddArrow, 0.3, {Rotation = 0})
					for _, o in pairs(ddList:GetChildren()) do
						if o:IsA("TextButton") then
							tween(o, 0.2, {BackgroundTransparency = 0})
							tween(o, 0.2, {TextTransparency = 0})
						end
					end
					task.wait(0.3)
					debounce = false
				else
					debounce = true
					tween(ddFrame, 0.3, {Size = UDim2.new(1, -5, 0, 40)})
					tween(ddArrow, 0.3, {Rotation = 180})
					for _, o in pairs(ddList:GetChildren()) do
						if o:IsA("TextButton") then
							tween(o, 0.2, {BackgroundTransparency = 1})
							tween(o, 0.2, {TextTransparency = 1})
						end
					end
					task.wait(0.3)
					ddList.Visible = false
					debounce = false
				end
			end)
			
			ddCfg.CurrentOption = ddVal
			
			function ddCfg:Set(val)
				ddVal = val
				ddCfg.CurrentOption = val
				ddSelected.Text = val
				for _, o in pairs(ddList:GetChildren()) do
					if o:IsA("TextButton") then
						if o.Text == val then
							o.BackgroundColor3 = curTheme.Dropdown
							o.UIStroke.Transparency = 1
						else
							o.BackgroundColor3 = curTheme.DropdownUnsel
							o.UIStroke.Transparency = 0
						end
					end
				end
				pcall(ddCfg.Callback, val)
				saveConfig()
			end
			
			if ddCfg.Flag then
				NexusLib.Flags[ddCfg.Flag] = ddCfg
			end
			
			return ddCfg
		end
		
		function tab:Input(inCfg)
			inCfg.Type = "Input"
			
			local inFrame = Instance.new("Frame")
			inFrame.Name = inCfg.Name
			inFrame.Size = UDim2.new(1, -5, 0, 40)
			inFrame.BackgroundColor3 = curTheme.ElBG
			inFrame.BorderSizePixel = 0
			inFrame.Parent = page
			
			local inCorner = Instance.new("UICorner")
			inCorner.CornerRadius = UDim.new(0, 4)
			inCorner.Parent = inFrame
			
			local inStroke = Instance.new("UIStroke")
			inStroke.Color = curTheme.ElStroke
			inStroke.Thickness = 1
			inStroke.Parent = inFrame
			
			local inLabel = Instance.new("TextLabel")
			inLabel.Size = UDim2.new(1, -200, 1, 0)
			inLabel.Position = UDim2.new(0, 10, 0, 0)
			inLabel.BackgroundTransparency = 1
			inLabel.Text = inCfg.Name
			inLabel.TextColor3 = curTheme.Text
			inLabel.TextSize = 14
			inLabel.Font = Enum.Font.Gotham
			inLabel.TextXAlignment = Enum.TextXAlignment.Left
			inLabel.Parent = inFrame
			
			local inBox = Instance.new("TextBox")
			inBox.Size = UDim2.new(0, 180, 0, 25)
			inBox.Position = UDim2.new(1, -190, 0.5, -12.5)
			inBox.BackgroundColor3 = curTheme.Input
			inBox.BorderSizePixel = 0
			inBox.Text = inCfg.Default or ""
			inBox.PlaceholderText = inCfg.Placeholder or ""
			inBox.PlaceholderColor3 = curTheme.Placeholder
			inBox.TextColor3 = curTheme.Text
			inBox.TextSize = 12
			inBox.Font = Enum.Font.Gotham
			inBox.ClearTextOnFocus = false
			inBox.Parent = inFrame
			
			local boxCorner = Instance.new("UICorner")
			boxCorner.CornerRadius = UDim.new(0, 4)
			boxCorner.Parent = inBox
			
			local boxStroke = Instance.new("UIStroke")
			boxStroke.Color = curTheme.InputStroke
			boxStroke.Thickness = 1
			boxStroke.Parent = inBox
			
			inFrame.MouseEnter:Connect(function()
				tween(inFrame, 0.3, {BackgroundColor3 = curTheme.ElHover})
			end)
			
			inFrame.MouseLeave:Connect(function()
				tween(inFrame, 0.3, {BackgroundColor3 = curTheme.ElBG})
			end)
			
			inBox.FocusLost:Connect(function()
				inCfg.CurrentValue = inBox.Text
				pcall(inCfg.Callback, inBox.Text)
				if inCfg.RemoveTextAfterFocusLost then
					inBox.Text = ""
				end
				saveConfig()
			end)
			
			inCfg.CurrentValue = inCfg.Default or ""
			
			function inCfg:Set(val)
				inBox.Text = val
				inCfg.CurrentValue = val
				pcall(inCfg.Callback, val)
				saveConfig()
			end
			
			if inCfg.Flag then
				NexusLib.Flags[inCfg.Flag] = inCfg
			end
			
			return inCfg
		end
		
		function tab:Keybind(kbCfg)
			kbCfg.Type = "Keybind"
			local checking = false
			
			local kbFrame = Instance.new("Frame")
			kbFrame.Name = kbCfg.Name
			kbFrame.Size = UDim2.new(1, -5, 0, 40)
			kbFrame.BackgroundColor3 = curTheme.ElBG
			kbFrame.BorderSizePixel = 0
			kbFrame.Parent = page
			
			local kbCorner = Instance.new("UICorner")
			kbCorner.CornerRadius = UDim.new(0, 4)
			kbCorner.Parent = kbFrame
			
			local kbStroke = Instance.new("UIStroke")
			kbStroke.Color = curTheme.ElStroke
			kbStroke.Thickness = 1
			kbStroke.Parent = kbFrame
			
			local kbLabel = Instance.new("TextLabel")
			kbLabel.Size = UDim2.new(1, -120, 1, 0)
			kbLabel.Position = UDim2.new(0, 10, 0, 0)
			kbLabel.BackgroundTransparency = 1
			kbLabel.Text = kbCfg.Name
			kbLabel.TextColor3 = curTheme.Text
			kbLabel.TextSize = 14
			kbLabel.Font = Enum.Font.Gotham
			kbLabel.TextXAlignment = Enum.TextXAlignment.Left
			kbLabel.Parent = kbFrame
			
			local kbBox = Instance.new("TextBox")
			kbBox.Size = UDim2.new(0, 100, 0, 25)
			kbBox.Position = UDim2.new(1, -110, 0.5, -12.5)
			kbBox.BackgroundColor3 = curTheme.Input
			kbBox.BorderSizePixel = 0
			kbBox.Text = kbCfg.Default or "None"
			kbBox.TextColor3 = curTheme.Text
			kbBox.TextSize = 12
			kbBox.Font = Enum.Font.Gotham
			kbBox.ClearTextOnFocus = false
			kbBox.Parent = kbFrame
			
			local boxCorner = Instance.new("UICorner")
			boxCorner.CornerRadius = UDim.new(0, 4)
			boxCorner.Parent = kbBox
			
			local boxStroke = Instance.new("UIStroke")
			boxStroke.Color = curTheme.InputStroke
			boxStroke.Thickness = 1
			boxStroke.Parent = kbBox
			
			kbFrame.MouseEnter:Connect(function()
				tween(kbFrame, 0.3, {BackgroundColor3 = curTheme.ElHover})
			end)
			
			kbFrame.MouseLeave:Connect(function()
				tween(kbFrame, 0.3, {BackgroundColor3 = curTheme.ElBG})
			end)
			
			kbBox.Focused:Connect(function()
				checking = true
				kbBox.Text = "..."
			end)
			
			kbBox.FocusLost:Connect(function()
				checking = false
				if kbBox.Text == "" or kbBox.Text == "..." then
					kbBox.Text = kbCfg.CurrentKeybind or "None"
				end
			end)
			
			UIS.InputBegan:Connect(function(input, gpe)
				if checking then
					if input.KeyCode ~= Enum.KeyCode.Unknown then
						local key = input.KeyCode.Name
						kbBox.Text = key
						kbCfg.CurrentKeybind = key
						kbBox:ReleaseFocus()
						saveConfig()
					end
				elseif kbCfg.CurrentKeybind and input.KeyCode == Enum.KeyCode[kbCfg.CurrentKeybind] and not gpe then
					pcall(kbCfg.Callback, kbCfg.CurrentKeybind)
				end
			end)
			
			kbCfg.CurrentKeybind = kbCfg.Default or "None"
			
			function kbCfg:Set(val)
				kbBox.Text = val
				kbCfg.CurrentKeybind = val
				saveConfig()
			end
			
			if kbCfg.Flag then
				NexusLib.Flags[kbCfg.Flag] = kbCfg
			end
			
			return kbCfg
		end
		
		function tab:ColorPicker(cpCfg)
			cpCfg.Type = "ColorPicker"
			local h, s, v = cpCfg.Default:ToHSV()
			local mainDrag, sliderDrag = false, false
			local mouse = Players.LocalPlayer:GetMouse()
			
			local cpFrame = Instance.new("Frame")
			cpFrame.Name = cpCfg.Name
			cpFrame.Size = UDim2.new(1, -5, 0, 45)
			cpFrame.BackgroundColor3 = curTheme.ElBG
			cpFrame.BorderSizePixel = 0
			cpFrame.ClipsDescendants = true
			cpFrame.Parent = page
			
			local cpCorner = Instance.new("UICorner")
			cpCorner.CornerRadius = UDim.new(0, 4)
			cpCorner.Parent = cpFrame
			
			local cpStroke = Instance.new("UIStroke")
			cpStroke.Color = curTheme.ElStroke
			cpStroke.Thickness = 1
			cpStroke.Parent = cpFrame
			
			local cpLabel = Instance.new("TextLabel")
			cpLabel.Size = UDim2.new(1, -60, 0, 45)
			cpLabel.Position = UDim2.new(0, 10, 0, 0)
			cpLabel.BackgroundTransparency = 1
			cpLabel.Text = cpCfg.Name
			cpLabel.TextColor3 = curTheme.Text
			cpLabel.TextSize = 14
			cpLabel.Font = Enum.Font.Gotham
			cpLabel.TextXAlignment = Enum.TextXAlignment.Left
			cpLabel.Parent = cpFrame
			
			local cpDisplay = Instance.new("Frame")
			cpDisplay.Size = UDim2.new(0, 35, 0, 20)
			cpDisplay.Position = UDim2.new(1, -45, 0, 12.5)
			cpDisplay.BackgroundColor3 = Color3.fromHSV(h, s, v)
			cpDisplay.BorderSizePixel = 0
			cpDisplay.Parent = cpFrame
			
			local dispCorner = Instance.new("UICorner")
			dispCorner.CornerRadius = UDim.new(0, 4)
			dispCorner.Parent = cpDisplay
			
			local cpBG = Instance.new("Frame")
			cpBG.Name = "BG"
			cpBG.Size = UDim2.new(0, 35, 0, 20)
			cpBG.Position = UDim2.new(1, -45, 0, 12.5)
			cpBG.BackgroundTransparency = 1
			cpBG.Parent = cpFrame
			
			local cpMain = Instance.new("ImageLabel")
			cpMain.Name = "Main"
			cpMain.Size = UDim2.new(0, 150, 0, 75)
			cpMain.Position = UDim2.new(0, 10, 0, 50)
			cpMain.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			cpMain.BorderSizePixel = 0
			cpMain.Image = "rbxassetid://4155801252"
			cpMain.ImageTransparency = 1
			cpMain.Parent = cpFrame
			
			local mainCorner = Instance.new("UICorner")
			mainCorner.CornerRadius = UDim.new(0, 4)
			mainCorner.Parent = cpMain
			
			local cpPoint = Instance.new("Frame")
			cpPoint.Size = UDim2.new(0, 8, 0, 8)
			cpPoint.Position = UDim2.new(s, -4, 1 - v, -4)
			cpPoint.BackgroundColor3 = Color3.fromHSV(h, s, v)
			cpPoint.BorderSizePixel = 0
			cpPoint.Parent = cpMain
			
			local pointCorner = Instance.new("UICorner")
			pointCorner.CornerRadius = UDim.new(1, 0)
			pointCorner.Parent = cpPoint
			
			local cpSlider = Instance.new("Frame")
			cpSlider.Size = UDim2.new(0, 150, 0, 10)
			cpSlider.Position = UDim2.new(0, 10, 0, 130)
			cpSlider.BorderSizePixel = 0
			cpSlider.Parent = cpFrame
			
			local sliderCorner = Instance.new("UICorner")
			sliderCorner.CornerRadius = UDim.new(1, 0)
			sliderCorner.Parent = cpSlider
			
			local sliderGrad = Instance.new("UIGradient")
			sliderGrad.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
			}
			sliderGrad.Parent = cpSlider
			
			local sliderPoint = Instance.new("Frame")
			sliderPoint.Size = UDim2.new(0, 8, 0, 8)
			sliderPoint.Position = UDim2.new(h, -4, 0.5, -4)
			sliderPoint.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			sliderPoint.BorderSizePixel = 0
			sliderPoint.Parent = cpSlider
			
			local sliderPCorner = Instance.new("UICorner")
			sliderPCorner.CornerRadius = UDim.new(1, 0)
			sliderPCorner.Parent = sliderPoint
			
			local cpBtn = Instance.new("TextButton")
			cpBtn.Size = UDim2.new(1, 0, 0, 45)
			cpBtn.BackgroundTransparency = 1
			cpBtn.Text = ""
			cpBtn.ZIndex = 2
			cpBtn.Parent = cpFrame
			
			local opened = false
			
			cpBtn.MouseButton1Click:Connect(function()
				opened = not opened
				if opened then
					tween(cpFrame, 0.4, {Size = UDim2.new(1, -5, 0, 150)})
					tween(cpBG, 0.4, {Size = UDim2.new(0, 15, 0, 15)})
					tween(cpDisplay, 0.4, {BackgroundTransparency = 1})
					tween(cpMain, 0.2, {ImageTransparency = 0.1})
					tween(cpLabel, 0.4, {Position = UDim2.new(0.28, 0, 0, 0)})
					tween(cpBtn, 0.4, {Size = UDim2.new(0.57, 0, 1, 0)})
				else
					tween(cpFrame, 0.4, {Size = UDim2.new(1, -5, 0, 45)})
					tween(cpBG, 0.4, {Size = UDim2.new(0, 35, 0, 20)})
					tween(cpDisplay, 0.4, {BackgroundTransparency = 0})
					tween(cpMain, 0.2, {ImageTransparency = 1})
					tween(cpLabel, 0.4, {Position = UDim2.new(0, 10, 0, 0)})
					tween(cpBtn, 0.4, {Size = UDim2.new(1, 0, 0, 45)})
				end
			end)
			
			cpMain.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					mainDrag = true
				end
			end)
			
			cpSlider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliderDrag = true
				end
			end)
			
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					mainDrag = false
					sliderDrag = false
				end
			end)
			
			RS.RenderStepped:Connect(function()
				if mainDrag then
					local localX = math.clamp(mouse.X - cpMain.AbsolutePosition.X, 0, cpMain.AbsoluteSize.X)
					local localY = math.clamp(mouse.Y - cpMain.AbsolutePosition.Y, 0, cpMain.AbsoluteSize.Y)
					s = localX / cpMain.AbsoluteSize.X
					v = 1 - (localY / cpMain.AbsoluteSize.Y)
					cpPoint.Position = UDim2.new(s, -4, 1 - v, -4)
					local col = Color3.fromHSV(h, s, v)
					cpDisplay.BackgroundColor3 = col
					cpPoint.BackgroundColor3 = col
					cpCfg.Color = col
					pcall(cpCfg.Callback, col)
					saveConfig()
				end
				if sliderDrag then
					local localX = math.clamp(mouse.X - cpSlider.AbsolutePosition.X, 0, cpSlider.AbsoluteSize.X)
					h = localX / cpSlider.AbsoluteSize.X
					sliderPoint.Position = UDim2.new(h, -4, 0.5, -4)
					sliderPoint.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
					cpMain.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
					local col = Color3.fromHSV(h, s, v)
					cpDisplay.BackgroundColor3 = col
					cpPoint.BackgroundColor3 = col
					cpCfg.Color = col
					pcall(cpCfg.Callback, col)
					saveConfig()
				end
			end)
			
			cpCfg.Color = Color3.fromHSV(h, s, v)
			
			function cpCfg:Set(col)
				h, s, v = col:ToHSV()
				cpCfg.Color = col
				cpPoint.Position = UDim2.new(s, -4, 1 - v, -4)
				sliderPoint.Position = UDim2.new(h, -4, 0.5, -4)
				cpDisplay.BackgroundColor3 = col
				cpPoint.BackgroundColor3 = col
				sliderPoint.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				cpMain.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			end
			
			if cpCfg.Flag then
				NexusLib.Flags[cpCfg.Flag] = cpCfg
			end
			
			return cpCfg
		end
		
		return tab
	end
	
	task.wait(0.5)
	globalLoaded = true
	
	if cfgEnabled and isfile and isfile(ConfigFolder.."/"..cfgName..ConfigExt) then
		loadConfig(readfile(ConfigFolder.."/"..cfgName..ConfigExt))
	end
	
	return win
end

function NexusLib:Destroy()
	if mainUI then
		mainUI:Destroy()
	end
end

return NexusLib
