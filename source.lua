local NexusLib = {Flags = {}, Themes = {}}

local function svc(n)
	local s = game:GetService(n)
	return cloneref and cloneref(s) or s
end

local UIS = svc("UserInputService")
local TS = svc("TweenService")
local Players = svc("Players")
local CG = svc("CoreGui")
local RS = svc("RunService")

NexusLib.Themes = {
	Dark = {
		Text = Color3.fromRGB(245, 245, 245),
		BG = Color3.fromRGB(18, 18, 18),
		Top = Color3.fromRGB(28, 28, 28),
		Shade = Color3.fromRGB(12, 12, 12),
		TabBG = Color3.fromRGB(70, 70, 70),
		TabStroke = Color3.fromRGB(80, 80, 80),
		TabSelected = Color3.fromRGB(220, 220, 220),
		TabText = Color3.fromRGB(240, 240, 240),
		SelectedText = Color3.fromRGB(40, 40, 40),
		ElBG = Color3.fromRGB(30, 30, 30),
		ElHover = Color3.fromRGB(35, 35, 35),
		ElStroke = Color3.fromRGB(45, 45, 45),
		Slider = Color3.fromRGB(60, 150, 230),
		SliderStroke = Color3.fromRGB(70, 170, 255),
		ToggleBG = Color3.fromRGB(25, 25, 25),
		ToggleOn = Color3.fromRGB(0, 160, 230),
		ToggleOff = Color3.fromRGB(90, 90, 90),
		ToggleOnStroke = Color3.fromRGB(0, 180, 255),
		ToggleOffStroke = Color3.fromRGB(110, 110, 110),
		Input = Color3.fromRGB(25, 25, 25),
		InputStroke = Color3.fromRGB(60, 60, 60),
		Dropdown = Color3.fromRGB(35, 35, 35),
		DropdownUnsel = Color3.fromRGB(25, 25, 25)
	},
	Blue = {
		Text = Color3.fromRGB(240, 245, 250),
		BG = Color3.fromRGB(15, 20, 30),
		Top = Color3.fromRGB(25, 30, 45),
		Shade = Color3.fromRGB(10, 15, 25),
		TabBG = Color3.fromRGB(30, 50, 70),
		TabStroke = Color3.fromRGB(40, 60, 80),
		TabSelected = Color3.fromRGB(80, 140, 200),
		TabText = Color3.fromRGB(200, 220, 240),
		SelectedText = Color3.fromRGB(15, 30, 50),
		ElBG = Color3.fromRGB(25, 40, 60),
		ElHover = Color3.fromRGB(30, 50, 70),
		ElStroke = Color3.fromRGB(40, 65, 90),
		Slider = Color3.fromRGB(0, 120, 200),
		SliderStroke = Color3.fromRGB(0, 140, 230),
		ToggleBG = Color3.fromRGB(25, 40, 55),
		ToggleOn = Color3.fromRGB(0, 130, 220),
		ToggleOff = Color3.fromRGB(70, 80, 90),
		ToggleOnStroke = Color3.fromRGB(0, 160, 250),
		ToggleOffStroke = Color3.fromRGB(80, 90, 100),
		Input = Color3.fromRGB(20, 35, 50),
		InputStroke = Color3.fromRGB(50, 70, 90),
		Dropdown = Color3.fromRGB(30, 60, 80),
		DropdownUnsel = Color3.fromRGB(20, 35, 50)
	},
	Purple = {
		Text = Color3.fromRGB(245, 240, 250),
		BG = Color3.fromRGB(25, 15, 35),
		Top = Color3.fromRGB(35, 20, 50),
		Shade = Color3.fromRGB(18, 10, 28),
		TabBG = Color3.fromRGB(55, 35, 75),
		TabStroke = Color3.fromRGB(65, 40, 85),
		TabSelected = Color3.fromRGB(170, 120, 210),
		TabText = Color3.fromRGB(230, 220, 245),
		SelectedText = Color3.fromRGB(45, 15, 55),
		ElBG = Color3.fromRGB(40, 25, 55),
		ElHover = Color3.fromRGB(45, 30, 65),
		ElStroke = Color3.fromRGB(65, 45, 80),
		Slider = Color3.fromRGB(110, 50, 160),
		SliderStroke = Color3.fromRGB(140, 70, 190),
		ToggleBG = Color3.fromRGB(40, 25, 50),
		ToggleOn = Color3.fromRGB(130, 50, 170),
		ToggleOff = Color3.fromRGB(85, 40, 105),
		ToggleOnStroke = Color3.fromRGB(150, 70, 190),
		ToggleOffStroke = Color3.fromRGB(110, 60, 130),
		Input = Color3.fromRGB(35, 20, 50),
		InputStroke = Color3.fromRGB(75, 45, 100),
		Dropdown = Color3.fromRGB(45, 30, 65),
		DropdownUnsel = Color3.fromRGB(30, 20, 45)
	}
}

local curTheme = NexusLib.Themes.Dark
local mainUI, mainFrame, topbar, tabList, pages
local dragging = false

function NexusLib:Init(cfg)
	cfg = cfg or {}
	local name = cfg.Name or "Nexus"
	local theme = cfg.Theme or "Dark"
	
	if NexusLib.Themes[theme] then
		curTheme = NexusLib.Themes[theme]
	end
	
	mainUI = Instance.new("ScreenGui")
	mainUI.Name = "Nexus_" .. math.random(1000, 9999)
	mainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	if gethui then
		mainUI.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(mainUI)
		mainUI.Parent = CG
	else
		mainUI.Parent = CG
	end
	
	mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(0, 520, 0, 420)
	mainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
	mainFrame.BackgroundColor3 = curTheme.BG
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = mainUI
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = mainFrame
	
	topbar = Instance.new("Frame")
	topbar.Name = "Top"
	topbar.Size = UDim2.new(1, 0, 0, 35)
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
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.new(0, 12, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = curTheme.Text
	title.TextSize = 16
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topbar
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "Close"
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 2.5)
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
	dragArea.Size = UDim2.new(1, -40, 1, 0)
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
	
	tabList = Instance.new("Frame")
	tabList.Name = "Tabs"
	tabList.Size = UDim2.new(1, -10, 0, 35)
	tabList.Position = UDim2.new(0, 5, 0, 40)
	tabList.BackgroundTransparency = 1
	tabList.Parent = mainFrame
	
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.Parent = tabList
	
	pages = Instance.new("Frame")
	pages.Name = "Pages"
	pages.Size = UDim2.new(1, -10, 1, -85)
	pages.Position = UDim2.new(0, 5, 0, 80)
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
				btn.BackgroundColor3 = curTheme.ElHover
			end)
			
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = curTheme.ElBG
			end)
			
			btn.MouseButton1Click:Connect(function()
				pcall(btnCfg.Callback)
			end)
			
			return btn
		end
		
		function tab:Toggle(togCfg)
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
			
			local togCircle = Instance.new("Frame")
			togCircle.Size = UDim2.new(0, 16, 0, 16)
			togCircle.Position = togVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
			togCircle.BackgroundColor3 = togVal and curTheme.ToggleOn or curTheme.ToggleOff
			togCircle.BorderSizePixel = 0
			togCircle.Parent = togSwitch
			
			local circleCorner = Instance.new("UICorner")
			circleCorner.CornerRadius = UDim.new(1, 0)
			circleCorner.Parent = togCircle
			
			local togBtn = Instance.new("TextButton")
			togBtn.Size = UDim2.new(1, 0, 1, 0)
			togBtn.BackgroundTransparency = 1
			togBtn.Text = ""
			togBtn.Parent = togFrame
			
			togBtn.MouseButton1Click:Connect(function()
				togVal = not togVal
				TS:Create(togCircle, TweenInfo.new(0.2), {
					Position = togVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = togVal and curTheme.ToggleOn or curTheme.ToggleOff
				}):Play()
				pcall(togCfg.Callback, togVal)
			end)
			
			local togObj = {}
			function togObj:Set(val)
				togVal = val
				TS:Create(togCircle, TweenInfo.new(0.2), {
					Position = togVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = togVal and curTheme.ToggleOn or curTheme.ToggleOff
				}):Play()
				pcall(togCfg.Callback, togVal)
			end
			
			return togObj
		end
		
		function tab:Slider(sldCfg)
			local sldVal = sldCfg.Default or sldCfg.Min
			
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
			sldValue.Text = tostring(sldVal)
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
			
			local sldFill = Instance.new("Frame")
			sldFill.Size = UDim2.new((sldVal - sldCfg.Min) / (sldCfg.Max - sldCfg.Min), 0, 1, 0)
			sldFill.BackgroundColor3 = curTheme.Slider
			sldFill.BorderSizePixel = 0
			sldFill.Parent = sldBar
			
			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1, 0)
			fillCorner.Parent = sldFill
			
			local sldDrag = false
			sldBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sldDrag = true
				end
			end)
			
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sldDrag = false
				end
			end)
			
			UIS.InputChanged:Connect(function(input)
				if sldDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local mousePos = UIS:GetMouseLocation().X
					local barPos = sldBar.AbsolutePosition.X
					local barSize = sldBar.AbsoluteSize.X
					local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
					sldVal = math.floor(sldCfg.Min + (sldCfg.Max - sldCfg.Min) * percent)
					sldFill.Size = UDim2.new(percent, 0, 1, 0)
					sldValue.Text = tostring(sldVal)
					pcall(sldCfg.Callback, sldVal)
				end
			end)
			
			local sldObj = {}
			function sldObj:Set(val)
				sldVal = math.clamp(val, sldCfg.Min, sldCfg.Max)
				local percent = (sldVal - sldCfg.Min) / (sldCfg.Max - sldCfg.Min)
				sldFill.Size = UDim2.new(percent, 0, 1, 0)
				sldValue.Text = tostring(sldVal)
				pcall(sldCfg.Callback, sldVal)
			end
			
			return sldObj
		end
		
		function tab:Dropdown(ddCfg)
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
			
			local ddList = Instance.new("Frame")
			ddList.Size = UDim2.new(1, -5, 0, 0)
			ddList.Position = UDim2.new(0, 0, 1, 5)
			ddList.BackgroundColor3 = curTheme.ElBG
			ddList.BorderSizePixel = 0
			ddList.Visible = false
			ddList.Parent = ddFrame
			
			local listCorner = Instance.new("UICorner")
			listCorner.CornerRadius = UDim.new(0, 4)
			listCorner.Parent = ddList
			
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
				
				optBtn.MouseButton1Click:Connect(function()
					ddVal = opt
					ddSelected.Text = opt
					ddOpen = false
					ddList.Visible = false
					TS:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, 40)}):Play()
					pcall(ddCfg.Callback, opt)
				end)
			end
			
			local ddBtn = Instance.new("TextButton")
			ddBtn.Size = UDim2.new(1, 0, 1, 0)
			ddBtn.BackgroundTransparency = 1
			ddBtn.Text = ""
			ddBtn.Parent = ddFrame
			
			ddBtn.MouseButton1Click:Connect(function()
				ddOpen = not ddOpen
				if ddOpen then
					ddList.Visible = true
					local listHeight = #ddCfg.Options * 32
					TS:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, 40 + listHeight + 5)}):Play()
					TS:Create(ddList, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, listHeight)}):Play()
				else
					ddList.Visible = false
					TS:Create(ddFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, 40)}):Play()
				end
			end)
			
			local ddObj = {}
			function ddObj:Set(val)
				ddVal = val
				ddSelected.Text = val
				pcall(ddCfg.Callback, val)
			end
			
			return ddObj
		end
		
		function tab:Input(inCfg)
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
			inBox.TextColor3 = curTheme.Text
			inBox.TextSize = 12
			inBox.Font = Enum.Font.Gotham
			inBox.Parent = inFrame
			
			local boxCorner = Instance.new("UICorner")
			boxCorner.CornerRadius = UDim.new(0, 4)
			boxCorner.Parent = inBox
			
			inBox.FocusLost:Connect(function()
				pcall(inCfg.Callback, inBox.Text)
			end)
			
			local inObj = {}
			function inObj:Set(val)
				inBox.Text = val
				pcall(inCfg.Callback, val)
			end
			
			return inObj
		end
		
		function tab:Label(txt)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -5, 0, 30)
			lbl.BackgroundColor3 = curTheme.ElBG
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
			lblStroke.Color = curTheme.ElStroke
			lblStroke.Thickness = 1
			lblStroke.Transparency = 0.5
			lblStroke.Parent = lbl
			
			local lblObj = {}
			function lblObj:Set(val)
				lbl.Text = val
			end
			
			return lblObj
		end
		
		return tab
	end
	
	return win
end

return NexusLib
