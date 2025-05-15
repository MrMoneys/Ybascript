--[[
    MobileUI Library - Uma biblioteca de interface do usuário para dispositivos móveis em Luau
    Features:
    - Componentes otimizados para touch
    - Gestos simples
    - Design responsivo
    - Fácil personalização
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

-- Cria uma nova instância da UI
function MobileUI.new(parent, config)
    local self = setmetatable({}, MobileUI)
    
    self.Parent = parent or error("Parent is required")
    self.Config = setmetatable(config or {}, {__index = DEFAULT_CONFIG})
    self.Components = {}
    
    -- Cria um ScreenGui como container principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MobileUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = self.Parent
    
    return self
end

-- Cria um container de seção
function MobileUI:CreateSection(title)
    local section = {}
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = title or "Section"
    frame.BackgroundColor3 = self.Config.SecondaryColor
    frame.BackgroundTransparency = 0.1
    frame.Size = UDim2.new(0.9, 0, 0, 0) -- Altura será ajustada automaticamente
    frame.Position = UDim2.new(0.5, 0, 0, self.Config.Padding)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Config.CornerRadius
    corner.Parent = frame
    
    -- Título da seção
    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Text = title
        titleLabel.Font = self.Config.Font
        titleLabel.TextSize = self.Config.TextSize + 2
        titleLabel.TextColor3 = self.Config.TextColor
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.new(1, -20, 0, 30)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
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
        frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, layout.AbsoluteContentSize.Y + (title and 30 or 10))
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

-- Adiciona um toggle (interruptor)
function MobileUI:AddToggle(section, options)
    options = options or {}
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. (options.Name or "Toggle")
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Size = UDim2.new(1, -20, 0, 30)
    toggleFrame.LayoutOrder = #section.Frame:GetChildren()
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = options.Name or "Toggle"
    label.Font = self.Config.Font
    label.TextSize = self.Config.TextSize
    label.TextColor3 = self.Config.TextColor
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -50, 0.5, 0)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = options.Value and self.Config.PrimaryColor or Color3.fromRGB(80, 80, 80)
    toggleButton.AutoButtonColor = false
    toggleButton.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = UDim2.new(0, options.Value and 25 or 3, 0.5, 0)
    toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0.5, 0)
    circleCorner.Parent = toggleCircle
    
    toggleCircle.Parent = toggleButton
    toggleButton.Parent = toggleFrame
    toggleFrame.Parent = section.Frame
    
    local function updateValue(value)
        options.Value = value
        toggleButton.BackgroundColor3 = value and self.Config.PrimaryColor or Color3.fromRGB(80, 80, 80)
        toggleCircle.Position = UDim2.new(0, value and 25 or 3, 0.5, 0)
        
        if options.Callback then
            options.Callback(value)
        end
    end
    
    -- Interação touch
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            updateValue(not options.Value)
        end
    end)
    
    -- Métodos do toggle
    local toggle = {}
    
    function toggle:SetValue(value)
        updateValue(value)
    end
    
    function toggle:GetValue()
        return options.Value or false
    end
    
    return toggle
end

-- Adiciona um botão
function MobileUI:AddButton(section, options)
    options = options or {}
    
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. (options.Name or "Button")
    button.Text = options.Name or "Button"
    button.Font = self.Config.Font
    button.TextSize = self.Config.TextSize
    button.TextColor3 = self.Config.TextColor
    button.BackgroundColor3 = self.Config.PrimaryColor
    button.Size = UDim2.new(1, -20, 0, self.Config.ButtonHeight)
    button.AutoButtonColor = false
    button.LayoutOrder = #section.Frame:GetChildren()
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Config.CornerRadius
    corner.Parent = button
    
    -- Efeito de toque
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            button.BackgroundTransparency = 0.5
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            button.BackgroundTransparency = 0
            if options.Callback then
                options.Callback()
            end
        end
    end)
    
    button.Parent = section.Frame
    
    -- Métodos do botão
    local buttonObj = {}
    
    function buttonObj:SetText(text)
        button.Text = text
    end
    
    function buttonObj:SetCallback(callback)
        options.Callback = callback
    end
    
    return buttonObj
end

-- Adiciona um slider
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
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = options.Name and ("%s: %d"):format(options.Name, options.Value) or tostring(options.Value)
    label.Font = self.Config.Font
    label.TextSize = self.Config.TextSize
    label.TextColor3 = self.Config.TextColor
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 5)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0.5, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((options.Value - options.Min) / (options.Max - options.Min), 0, 1, 0)
    fill.BackgroundColor3 = self.Config.PrimaryColor
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.5, 0)
    fillCorner.Parent = fill
    
    fill.Parent = track
    
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new(fill.Size.X.Scale, -10, 0.5, 0)
    thumb.AnchorPoint = Vector2.new(0, 0.5)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Text = ""
    thumb.AutoButtonColor = false
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0.5, 0)
    thumbCorner.Parent = thumb
    
    thumb.Parent = sliderFrame
    track.Parent = sliderFrame
    sliderFrame.Parent = section.Frame
    
    -- Lógica de interação
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
            options.Callback(value)
        end
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    thumb.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local position = input.Position.X
            local absolutePosition = sliderFrame.AbsolutePosition.X
            local absoluteSize = sliderFrame.AbsoluteSize.X
            
            local relativePosition = math.clamp(position - absolutePosition, 0, absoluteSize)
            local ratio = relativePosition / absoluteSize
            local value = options.Min + (options.Max - options.Min) * ratio
            
            updateValue(value)
        end
    end)
    
    -- Métodos do slider
    local slider = {}
    
    function slider:SetValue(value)
        updateValue(value)
    end
    
    function slider:GetValue()
        return options.Value
    end
    
    return slider
end

-- Adiciona uma caixa de texto
function MobileUI:AddTextbox(section, options)
    options = options or {}
    options.Placeholder = options.Placeholder or "Type here..."
    
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = "Textbox_" .. (options.Name or "Textbox")
    textboxFrame.BackgroundTransparency = 1
    textboxFrame.Size = UDim2.new(1, -20, 0, 60)
    textboxFrame.LayoutOrder = #section.Frame:GetChildren()
    
    if options.Name then
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Text = options.Name
        label.Font = self.Config.Font
        label.TextSize = self.Config.TextSize
        label.TextColor3 = self.Config.TextColor
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 20)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = textboxFrame
    end
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "Textbox"
    textbox.Size = UDim2.new(1, 0, 0, 35)
    textbox.Position = UDim2.new(0, 0, 0, options.Name and 25 or 0)
    textbox.Font = self.Config.Font
    textbox.TextSize = self.Config.TextSize
    textbox.TextColor3 = self.Config.TextColor
    textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textbox.PlaceholderText = options.Placeholder
    textbox.ClearTextOnFocus = false
    textbox.Text = options.Text or ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Config.CornerRadius
    corner.Parent = textbox
    
    textbox.Parent = textboxFrame
    textboxFrame.Parent = section.Frame
    
    -- Foco ao tocar
    textbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, nil)
        end
    end)
    
    -- Callback ao terminar de editar
    textbox.FocusLost:Connect(function(enterPressed)
        if options.Callback and (enterPressed or not options.OnlyEnter) then
            options.Callback(textbox.Text)
        end
    end)
    
    -- Métodos da textbox
    local textboxObj = {}
    
    function textboxObj:SetText(text)
        textbox.Text = text
    end
    
    function textboxObj:GetText()
        return textbox.Text
    end
    
    return textboxObj
end

-- Adiciona um dropdown
function MobileUI:AddDropdown(section, options)
    options = options or {}
    options.Options = options.Options or {}
    options.Default = options.Default or 1
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown_" .. (options.Name or "Dropdown")
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
    dropdownFrame.LayoutOrder = #section.Frame:GetChildren()
    dropdownFrame.ClipsDescendants = true
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = options.Name or "Dropdown"
    label.Font = self.Config.Font
    label.TextSize = self.Config.TextSize
    label.TextColor3 = self.Config.TextColor
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame
    
    local button = Instance.new("TextButton")
    button.Name = "DropdownButton"
    button.Size = UDim2.new(0.3, 0, 0, 30)
    button.Position = UDim2.new(0.7, 0, 0, 0)
    button.Font = self.Config.Font
    button.TextSize = self.Config.TextSize
    button.Text = options.Options[options.Default] or "Select"
    button.TextColor3 = self.Config.TextColor
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Config.CornerRadius
    corner.Parent = button
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = self.Config.CornerRadius
    optionsCorner.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame
    
    -- Criar opções
    for i, option in ipairs(options.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Size = UDim2.new(1, -10, 0, 25)
        optionButton.Position = UDim2.new(0, 5, 0, 0)
        optionButton.Text = option
        optionButton.Font = self.Config.Font
        optionButton.TextSize = self.Config.TextSize - 1
        optionButton.TextColor3 = self.Config.TextColor
        optionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        optionButton.AutoButtonColor = false
        optionButton.LayoutOrder = i
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 5)
        optionCorner.Parent = optionButton
        
        optionButton.MouseButton1Click:Connect(function()
            button.Text = option
            optionsFrame.Visible = false
            dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            
            if options.Callback then
                options.Callback(option, i)
            end
        end)
        
        optionButton.Parent = optionsFrame
    end
    
    optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsFrame.Size = UDim2.new(1, 0, 0, optionsLayout.AbsoluteContentSize.Y + 5)
    end)
    
    optionsFrame.Parent = dropdownFrame
    button.Parent = dropdownFrame
    dropdownFrame.Parent = section.Frame
    
    -- Toggle das opções
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            optionsFrame.Visible = not optionsFrame.Visible
            dropdownFrame.Size = optionsFrame.Visible and UDim2.new(1, -20, 0, 30 + optionsFrame.AbsoluteSize.Y + 5) or UDim2.new(1, -20, 0, 30)
        end
    end)
    
    -- Fechar ao tocar fora
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.Touch and optionsFrame.Visible then
            local touchPos = input.Position
            local absolutePos = dropdownFrame.AbsolutePosition
            local absoluteSize = dropdownFrame.AbsoluteSize
            
            if not (touchPos.X >= absolutePos.X and touchPos.X <= absolutePos.X + absoluteSize.X and
                   touchPos.Y >= absolutePos.Y and touchPos.Y <= absolutePos.Y + absoluteSize.Y) then
                optionsFrame.Visible = false
                dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            end
        end
    end)
    
    -- Métodos do dropdown
    local dropdown = {}
    
    function dropdown:SetOptions(newOptions)
        options.Options = newOptions
        -- Limpar opções existentes
        for _, child in ipairs(optionsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Adicionar novas opções
        for i, option in ipairs(newOptions) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = option
            optionButton.Size = UDim2.new(1, -10, 0, 25)
            optionButton.Position = UDim2.new(0, 5, 0, 0)
            optionButton.Text = option
            optionButton.Font = self.Config.Font
            optionButton.TextSize = self.Config.TextSize - 1
            optionButton.TextColor3 = self.Config.TextColor
            optionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            optionButton.AutoButtonColor = false
            optionButton.LayoutOrder = i
            
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 5)
            optionCorner.Parent = optionButton
            
            optionButton.MouseButton1Click:Connect(function()
                button.Text = option
                optionsFrame.Visible = false
                dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
                
                if options.Callback then
                    options.Callback(option, i)
                end
            end)
            
            optionButton.Parent = optionsFrame
        end
    end
    
    function dropdown:SetSelected(index)
        if options.Options[index] then
            button.Text = options.Options[index]
            
            if options.Callback then
                options.Callback(options.Options[index], index)
            end
        end
    end
    
    return dropdown
end

-- Adiciona um keybind (atalho de tecla)
function MobileUI:AddKeybind(section, options)
    options = options or {}
    options.Key = options.Key or Enum.KeyCode.LeftShift
    
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = "Keybind_" .. (options.Name or "Keybind")
    keybindFrame.BackgroundTransparency = 1
    keybindFrame.Size = UDim2.new(1, -20, 0, 30)
    keybindFrame.LayoutOrder = #section.Frame:GetChildren()
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = options.Name or "Keybind"
    label.Font = self.Config.Font
    label.TextSize = self.Config.TextSize
    label.TextColor3 = self.Config.TextColor
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = keybindFrame
    
    local button = Instance.new("TextButton")
    button.Name = "KeybindButton"
    button.Size = UDim2.new(0.3, 0, 0, 30)
    button.Position = UDim2.new(0.7, 0, 0, 0)
    button.Font = self.Config.Font
    button.TextSize = self.Config.TextSize
    button.Text = options.Key.Name
    button.TextColor3 = self.Config.TextColor
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Config.CornerRadius
    corner.Parent = button
    
    button.Parent = keybindFrame
    keybindFrame.Parent = section.Frame
    
    -- Modo de edição
    local editing = false
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and not editing then
            editing = true
            button.Text = "..."
            button.BackgroundColor3 = self.Config.PrimaryColor
            
            local connection
            connection = game:GetService("UserInputService").InputBegan:Connect(function(newInput)
                if newInput.UserInputType == Enum.UserInputType.Keyboard then
                    options.Key = newInput.KeyCode
                    button.Text = options.Key.Name
                    editing = false
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    connection:Disconnect()
                    
                    if options.Callback then
                        options.Callback(options.Key)
                    end
                end
            end)
        end
    end)
    
    -- Métodos do keybind
    local keybind = {}
    
    function keybind:SetKey(key)
        options.Key = key
        button.Text = key.Name
    end
    
    function keybind:GetKey()
        return options.Key
    end
    
    return keybind
end

-- Adiciona um label simples
function MobileUI:AddLabel(section, text)
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. text
    label.Text = text
    label.Font = self.Config.Font
    label.TextSize = self.Config.TextSize
    label.TextColor3 = self.Config.TextColor
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -20, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = #section.Frame:GetChildren()
    
    label.Parent = section.Frame
    
    -- Métodos do label
    local labelObj = {}
    
    function labelObj:SetText(newText)
        label.Text = newText
    end
    
    return labelObj
end

-- Destruir a UI
function MobileUI:Destroy()
    self.ScreenGui:Destroy()
    setmetatable(self, nil)
end

return MobileUI
