-- XLaunch v1.0 - UI Library by Luau (Roblox / Luau)
-- Link do repositório: github.com/SeuUsuario/XLaunch

local TweenService = game:GetService("TweenService")
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

function Window.new(title)
	local self = setmetatable({}, Window)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "XLaunchUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Size = UDim2.fromScale(0.85, 0.85)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.BackgroundColor3 = Theme.BackgroundColor
	main.ClipsDescendants = true
	main.Parent = screenGui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = Theme.CornerRadius
	uiCorner.Parent = main

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

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = Theme.CornerRadius
	uiCorner.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.PrimaryColor}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ForegroundColor}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	self.Gui = btn

	return self
end

-- Main API
local XLaunch = {
	Window = Window,
	Button = Button,
	Theme = Theme
}

return XLaunch
