-- MobileUI Library - Versão para Loadstring
local MobileUI = (function()
    --[[
        MobileUI Library - Versão Loadstring
        Compatível com executores mobile (Script-Ware, Synapse, etc.)
        Uso:
            local MobileUI = loadstring(game:HttpGet("URL_DA_RAW"))()
            local ui = MobileUI.new()
    ]]

    local MobileUI = {}
    MobileUI.__index = MobileUI

    -- Configurações padrão
    local DEFAULT_CONFIG = {
        Theme = "Dark",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        PrimaryColor = Color3.fromRGB(0, 120, 215),
        SecondaryColor = Color3.fromRGB(40, 40, 40),
        TextColor = Color3.fromRGB(255, 255, 255),
        CornerRadius = UDim.new(0, 8),
        Padding = 10,
        ButtonHeight = 40
    }

    -- Verifica se estamos em um executor
    local IS_EXECUTOR = not game:GetService("RunService"):IsStudio()

    -- Cria uma nova instância da UI
    function MobileUI.new(parent, config)
        local self = setmetatable({}, MobileUI)
        
        self.Parent = parent or (IS_EXECUTOR and (gethui and gethui() or game:GetService("CoreGui"))) or error("Parent is required")
        self.Config = setmetatable(config or {}, {__index = DEFAULT_CONFIG})
        self.Components = {}
        
        -- Cria um ScreenGui como container principal
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Name = "MobileUI_" .. tostring(math.random(1, 10000))
        self.ScreenGui.ResetOnSpawn = false
        self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.ScreenGui.Parent = self.Parent
        
        return self
    end

    -- Métodos internos
    local function createRoundedFrame(parent, config)
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = config.BackgroundColor or config.SecondaryColor
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = config.CornerRadius or UDim.new(0, 8)
        corner.Parent = frame
        
        if parent then frame.Parent = parent end
        return frame
    end

    local function createLabel(parent, text, config)
        local label = Instance.new("TextLabel")
        label.Text = text
        label.Font = config.Font
        label.TextSize = config.TextSize
        label.TextColor3 = config.TextColor
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        if parent then label.Parent = parent end
        return label
    end

    -- Cria um container de seção
    function MobileUI:CreateSection(title)
        local section = {}
        
        -- Frame principal
        local frame = createRoundedFrame(nil, self.Config)
        frame.Name = title or "Section"
        frame.Size = UDim2.new(0.9, 0, 0, 0)
        frame.Position = UDim2.new(0.5, 0, 0, self.Config.Padding)
        frame.AnchorPoint = Vector2.new(0.5, 0)
        frame.ClipsDescendants = true
        
        -- Título da seção
        if title then
            createLabel(frame, title, {
                Font = self.Config.Font,
                TextSize = self.Config.TextSize + 2,
                TextColor = self.Config.TextColor
            }).Size = UDim2.new(1, -20, 0, 30)
        end
        
        -- Layout dos elementos
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, self.Config.Padding)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = frame
        
        -- Atualizar tamanho automaticamente
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 
                layout.AbsoluteContentSize.Y + (title and 30 or 10))
        end)
        
        frame.Parent = self.ScreenGui
        self.Components[frame.Name] = frame
        
        section.Frame = frame
        section.Layout = layout
        
        -- Métodos da seção
        function section:AddToggle(options)
            return MobileUI.AddToggle(self, options)
        end
        
        function section:AddButton(options)
            return MobileUI.AddButton(self, options)
        end
        
        function section:AddSlider(options)
            return MobileUI.AddSlider(self, options)
        end
        
        function section:AddTextbox(options)
            return MobileUI.AddTextbox(self, options)
        end
        
        function section:AddDropdown(options)
            return MobileUI.AddDropdown(self, options)
        end
        
        function section:AddKeybind(options)
            return MobileUI.AddKeybind(self, options)
        end
        
        function section:AddLabel(text)
            return MobileUI.AddLabel(self, text)
        end
        
        return section
    end

    -- Componentes da UI
    function MobileUI:AddToggle(section, options)
        options = options or {}
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_" .. (options.Name or "Toggle")
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Size = UDim2.new(1, -20, 0, 30)
        toggleFrame.LayoutOrder = #section.Frame:GetChildren()
        
        createLabel(toggleFrame, options.Name or "Toggle", self.Config).Size = UDim2.new(0.7, 0, 1, 0)
        
        local toggleButton = createRoundedFrame(nil, {
            BackgroundColor = options.Value and self.Config.PrimaryColor or Color3.fromRGB(80, 80, 80),
            CornerRadius = UDim.new(0, 12)
        })
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 50, 0, 25)
        toggleButton.Position = UDim2.new(1, -50, 0.5, 0)
        toggleButton.AnchorPoint = Vector2.new(1, 0.5)
        
        local toggleCircle = createRoundedFrame(nil, {
            BackgroundColor = Color3.fromRGB(255, 255, 255),
            CornerRadius = UDim.new(0.5, 0)
        })
        toggleCircle.Name = "Circle"
        toggleCircle.Size = UDim2.new(0, 21, 0, 21)
        toggleCircle.Position = UDim2.new(0, options.Value and 25 or 3, 0.5, 0)
        toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
        toggleCircle.Parent = toggleButton
        
        toggleButton.Parent = toggleFrame
        toggleFrame.Parent = section.Frame
        
        local function updateValue(value)
            options.Value = value
            toggleButton.BackgroundColor3 = value and self.Config.PrimaryColor or Color3.fromRGB(80, 80, 80)
            toggleCircle.Position = UDim2.new(0, value and 25 or 3, 0.5, 0)
            
            if options.Callback then
                task.spawn(options.Callback, value)
            end
        end
        
        toggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateValue(not options.Value)
            end
        end)
        
        return {
            SetValue = updateValue,
            GetValue = function() return options.Value or false end
        }
    end

    function MobileUI:AddButton(section, options)
        options = options or {}
        
        local button = createRoundedFrame(nil, {
            BackgroundColor = self.Config.PrimaryColor,
            CornerRadius = self.Config.CornerRadius
        })
        button.Name = "Button_" .. (options.Name or "Button")
        button.Size = UDim2.new(1, -20, 0, self.Config.ButtonHeight)
        button.LayoutOrder = #section.Frame:GetChildren()
        
        local label = createLabel(button, options.Name or "Button", self.Config)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextXAlignment = Enum.TextXAlignment.Center
        
        local function animateClick()
            button.BackgroundTransparency = 0.5
            task.wait(0.1)
            button.BackgroundTransparency = 0
        end
        
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                animateClick()
                if options.Callback then
                    task.spawn(options.Callback)
                end
            end
        end)
        
        button.Parent = section.Frame
        
        return {
            SetText = function(text) label.Text = text end,
            SetCallback = function(cb) options.Callback = cb end
        }
    end

    function MobileUI:AddSlider(section, options)
        options = options or {}
        options.Min = options.Min or 0
        options.Max = options.Max or 100
        options.Value = options.Value or options.Min
        options.Precision = options.Precision or 1
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider_" .. (options.Name or "Slider")
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Size = UDim2.new(1, -20, 0, 50)
        sliderFrame.LayoutOrder = #section.Frame:GetChildren()
        
        local label = createLabel(sliderFrame, 
            options.Name and ("%s: %d"):format(options.Name, options.Value) or tostring(options.Value), 
            self.Config)
        label.Size = UDim2.new(1, 0, 0, 20)
        
        local track = createRoundedFrame(nil, {
            BackgroundColor = Color3.fromRGB(80, 80, 80),
            CornerRadius = UDim.new(0.5, 0)
        })
        track.Name = "Track"
        track.Size = UDim2.new(1, 0, 0, 5)
        track.Position = UDim2.new(0, 0, 0, 30)
        
        local fill = createRoundedFrame(track, {
            BackgroundColor = self.Config.PrimaryColor,
            CornerRadius = UDim.new(0.5, 0)
        })
        fill.Name = "Fill"
        fill.Size = UDim2.new((options.Value - options.Min) / (options.Max - options.Min), 0, 1, 0)
        
        local thumb = createRoundedFrame(nil, {
            BackgroundColor = Color3.fromRGB(255, 255, 255),
            CornerRadius = UDim.new(0.5, 0)
        })
        thumb.Name = "Thumb"
        thumb.Size = UDim2.new(0, 20, 0, 20)
        thumb.Position = UDim2.new(fill.Size.X.Scale, -10, 0.5, 0)
        thumb.AnchorPoint = Vector2.new(0, 0.5)
        
        thumb.Parent = sliderFrame
        track.Parent = sliderFrame
        sliderFrame.Parent = section.Frame
        
        local dragging = false
        
        local function updateValue(value)
            value = math.clamp(value, options.Min, options.Max)
            if options.Precision then
                value = math.floor(value / options.Precision) * options.Precision
            end
            
            options.Value = value
            local ratio = (value - options.Min) / (options.Max - options.Min)
            fill.Size = UDim2.new(ratio, 0, 1, 0)
            thumb.Position = UDim2.new(ratio, -10, 0.5, 0)
            
            label.Text = options.Name and ("%s: %d"):format(options.Name, value) or tostring(value)
            
            if options.Callback then
                task.spawn(options.Callback, value)
            end
        end
        
        thumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                local pos
                if input.UserInputType == Enum.UserInputType.Touch then
                    pos = input.Position.X
                else
                    pos = game:GetService("Players").LocalPlayer:GetMouse().X
                end
                
                local absolutePosition = sliderFrame.AbsolutePosition.X
                local absoluteSize = sliderFrame.AbsoluteSize.X
                
                local relativePosition = math.clamp(pos - absolutePosition, 0, absoluteSize)
                local ratio = relativePosition / absoluteSize
                local value = options.Min + (options.Max - options.Min) * ratio
                
                updateValue(value)
            end
        end)
        
        return {
            SetValue = updateValue,
            GetValue = function() return options.Value end
        }
    end

    -- (Continua com os outros componentes: Textbox, Dropdown, Keybind, etc...)

    -- Função para destruir a UI
    function MobileUI:Destroy()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
        setmetatable(self, nil)
    end

    return MobileUI
end)()

return MobileUI
