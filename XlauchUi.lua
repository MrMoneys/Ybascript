-- XLaunch v1.1 - UI Library by Luau (Roblox / Luau)
-- github.com/SeuUsuario/XLaunch

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Theme
local Theme = {
	PrimaryColor = Color3.fromRGB(0, 136, 255),
	BackgroundColor = Color3.fromRGB(24, 24, 24),
	ForegroundColor = Color3.fromRGB(34, 34, 34),
	TextColor = Color3.fromRGB(255, 255, 255),
	CornerRadius = UDim.new(0, 10),
	Font = Enum.Font.GothamSemibold
}

-- Window
local Window = {}
Window.__index = Window

function Window.new(title, size)
	local self = setmetatable({}, Window)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "XLaunchUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local shadow = Instance.new("ImageLabel")
	shadow.Size = size or UDim2.fromOffset(500, 400)
	shadow.Position = UDim2.fromScale(0.5, 0.5)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217" -- Soft shadow
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.ImageTransparency = 0.4
	shadow.ZIndex = 0
	shadow.Parent = screenGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(1, -20, 1, -20)
	main.Position = UDim2.new(0, 10, 0, 10)
	main.BackgroundColor3 = Theme.BackgroundColor
	main.AnchorPoint = Vector2.new(0, 0)
	main.ClipsDescendants = false
	main.ZIndex = 1
	main.Parent = shadow

	local uiCorner = Instance.new("UICorner", main)
	uiCorner.CornerRadius = Theme.CornerRadius

	local stroke = Instance.new("UIStroke", main)
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.85

	-- TopBar
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 45)
	topBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	topBar.BackgroundTransparency = 0.9
	topBar.BorderSizePixel = 0
	topBar.Parent = main

	local topLabel = Instance.new("TextLabel")
	topLabel.Text = title or "XLaunch Window"
	topLabel.Size = UDim2.new(1, -20, 1, 0)
	topLabel.Position = UDim2.new(0, 10, 0, 0)
	topLabel.BackgroundTransparency = 1
	topLabel.TextColor3 = Theme.TextColor
	topLabel.Font = Theme.Font
	topLabel.TextScaled = true
	topLabel.TextXAlignment = Enum.TextXAlignment.Left
	topLabel.Parent = topBar

	-- Content Area
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, -20, 1, -65)
	container.Position = UDim2.new(0, 10, 0, 55)
	container.BackgroundTransparency = 1
	container.ClipsDescendants = true
	container.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 10)
	layout.Parent = container

	-- Resize Handle
	local resizeHandle = Instance.new("ImageButton")
	resizeHandle.Size = UDim2.new(0, 24, 0, 24)
	resizeHandle.AnchorPoint = Vector2.new(1, 1)
	resizeHandle.Position = UDim2.new(1, -10, 1, -10)
	resizeHandle.Image = "rbxassetid://6035047377" -- icon: resize
	resizeHandle.ImageColor3 = Theme.PrimaryColor
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.ZIndex = 2
	resizeHandle.Parent = main

	local dragging = false
	local dragStart, startSize

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startSize = shadow.Size
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local newX = math.clamp(startSize.X.Offset + delta.X, 300, 1000)
			local newY = math.clamp(startSize.Y.Offset + delta.Y, 200, 800)
			shadow.Size = UDim2.fromOffset(newX, newY)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	self.Gui = screenGui
	self.Main = main
	self.Container = container

	return self
end


function Window:Add(component)
	component.Gui.Parent = self.Container
end

-- Button
local Button = {}
Button.__index = Button

function Button.new(text, callback)
	local self = setmetatable({}, Button)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Theme.ForegroundColor
	btn.Text = text or "Button"
	btn.Font = Theme.Font
	btn.TextScaled = true
	btn.TextColor3 = Theme.TextColor
	btn.AutoButtonColor = false

	local uiCorner = Instance.new("UICorner", btn)
	uiCorner.CornerRadius = Theme.CornerRadius

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.PrimaryColor}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ForegroundColor}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	self.Gui = btn
	return self
end

-- Toggle
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(text, default, callback)
	local self = setmetatable({}, Toggle)
	local state = default or false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundTransparency = 1

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = text or "Toggle"
	label.TextColor3 = Theme.TextColor
	label.TextScaled = true
	label.Parent = frame

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
	toggleBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
	toggleBtn.Text = state and "ON" or "OFF"
	toggleBtn.Font = Theme.Font
	toggleBtn.TextColor3 = Theme.TextColor
	toggleBtn.TextScaled = true
	toggleBtn.BackgroundColor3 = state and Theme.PrimaryColor or Theme.ForegroundColor
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = frame

	local corner = Instance.new("UICorner", toggleBtn)
	corner.CornerRadius = Theme.CornerRadius

	toggleBtn.MouseButton1Click:Connect(function()
		state = not state
		toggleBtn.Text = state and "ON" or "OFF"
		TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = state and Theme.PrimaryColor or Theme.ForegroundColor
		}):Play()
		if callback then callback(state) end
	end)

	self.Gui = frame
	return self
end

-- Slider
local Slider = {}
Slider.__index = Slider

function Slider.new(labelText, min, max, default, callback)
	local self = setmetatable({}, Slider)
	min, max = min or 0, max or 100
	local value = default or min

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 50)
	frame.BackgroundTransparency = 1

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0.4, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = string.format("%s: %d", labelText, value)
	label.TextColor3 = Theme.TextColor
	label.TextScaled = true
	label.Parent = frame

	local sliderBack = Instance.new("Frame")
	sliderBack.Size = UDim2.new(1, -20, 0.3, 0)
	sliderBack.Position = UDim2.new(0, 10, 0.5, 0)
	sliderBack.BackgroundColor3 = Theme.ForegroundColor
	sliderBack.Parent = frame

	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Theme.PrimaryColor
	sliderFill.Parent = sliderBack

	local dragging = false

	local function update(input)
		local relX = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
		value = math.floor(min + (max - min) * relX)
		sliderFill.Size = UDim2.new(relX, 0, 1, 0)
		label.Text = string.format("%s: %d", labelText, value)
		if callback then callback(value) end
	end

	sliderBack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			update(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	local corner1 = Instance.new("UICorner", sliderBack)
	corner1.CornerRadius = Theme.CornerRadius

	local corner2 = Instance.new("UICorner", sliderFill)
	corner2.CornerRadius = Theme.CornerRadius

	self.Gui = frame
	return self
end



local Tab = {}
Tab.__index = Tab

function Tab.new(parentFrame)
	local self = setmetatable({}, Tab)

	local tabButtons = Instance.new("Frame")
	tabButtons.Name = "TabButtons"
	tabButtons.Size = UDim2.new(1, 0, 0, 40)
	tabButtons.BackgroundTransparency = 1
	tabButtons.Parent = parentFrame

	local uiList = Instance.new("UIListLayout", tabButtons)
	uiList.FillDirection = Enum.FillDirection.Horizontal
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Padding = UDim.new(0, 5)

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "TabContent"
	contentFrame.Size = UDim2.new(1, 0, 1, -40)
	contentFrame.Position = UDim2.new(0, 0, 0, 40)
	contentFrame.BackgroundTransparency = 1
	contentFrame.ClipsDescendants = true
	contentFrame.Parent = parentFrame

	self.TabButtons = tabButtons
	self.TabContent = contentFrame
	self.Pages = {}

	return self
end

function Tab:AddPage(name)
	local pageFrame = Instance.new("Frame")
	pageFrame.Size = UDim2.new(1, 0, 1, 0)
	pageFrame.BackgroundTransparency = 1
	pageFrame.Visible = false
	pageFrame.Parent = self.TabContent

	local layout = Instance.new("UIListLayout", pageFrame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)

	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.BackgroundColor3 = Theme.ForegroundColor
	btn.TextColor3 = Theme.TextColor
	btn.TextScaled = true
	btn.Font = Theme.Font
	btn.Parent = self.TabButtons

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = Theme.CornerRadius

	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(self.Pages) do p.Visible = false end
		pageFrame.Visible = true
	end)

	if #self.Pages == 0 then
		pageFrame.Visible = true
	end

	table.insert(self.Pages, pageFrame)

	return pageFrame
end


-- Main API
local XLaunch = {
	Window = Window,
	Button = Button,
	Toggle = Toggle,
	Slider = Slider,
	Theme = Theme
}

return XLaunch
