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

	local main = Instance.new("Frame")
	main.Size = size or UDim2.fromScale(0.8, 0.8)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.BackgroundColor
	main.ClipsDescendants = true
	main.Parent = screenGui

	local uiCorner = Instance.new("UICorner", main)
	uiCorner.CornerRadius = Theme.CornerRadius

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "XLaunch"
	titleLabel.TextColor3 = Theme.TextColor
	titleLabel.Font = Theme.Font
	titleLabel.TextScaled = true
	titleLabel.Parent = main

	local container = Instance.new("Frame")
	container.Name = "Content"
	container.Size = UDim2.new(1, -20, 1, -60)
	container.Position = UDim2.new(0, 10, 0, 50)
	container.BackgroundTransparency = 1
	container.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 10)
	layout.Parent = container

	-- Resize Handle
	local resizeHandle = Instance.new("Frame")
	resizeHandle.Size = UDim2.new(0, 16, 0, 16)
	resizeHandle.AnchorPoint = Vector2.new(1, 1)
	resizeHandle.Position = UDim2.new(1, -4, 1, -4)
	resizeHandle.BackgroundColor3 = Theme.PrimaryColor
	resizeHandle.Parent = main

	local corner = Instance.new("UICorner", resizeHandle)
	corner.CornerRadius = UDim.new(1, 0)

	local dragging = false
	local dragInput, dragStart, startSize

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startSize = main.Size
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Size = UDim2.new(
				startSize.X.Scale,
				math.clamp(startSize.X.Offset + delta.X, 200, 1000),
				startSize.Y.Scale,
				math.clamp(startSize.Y.Offset + delta.Y, 200, 800)
			)
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

-- Main API
local XLaunch = {
	Window = Window,
	Button = Button,
	Toggle = Toggle,
	Slider = Slider,
	Theme = Theme
}

return XLaunch
