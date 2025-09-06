-- Fish It! Custom UI Library
local FishItUI = {}

-- UI Variables
local ScreenGui = nil
local MainFrame = nil
local Tabs = {}
local CurrentTab = nil

-- Colors
local Colors = {
    Background = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 165, 0),
    Error = Color3.fromRGB(255, 0, 0)
}

-- Create ScreenGui
function FishItUI:CreateScreenGui()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return ScreenGui
end

-- Create Main Window
function FishItUI:MakeWindow(config)
    if not ScreenGui then
        self:CreateScreenGui()
    end
    
    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    -- Drop Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = MainFrame.ZIndex - 1
    shadow.Parent = ScreenGui
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Colors.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = config.Name or "Fish It! Script"
    titleText.TextColor3 = Colors.Text
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Colors.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Colors.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = Colors.Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = MainFrame
    
    -- Content Container
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, -100)
    contentContainer.Position = UDim2.new(0, 10, 0, 80)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ScrollBarThickness = 6
    contentContainer.ScrollBarImageColor3 = Colors.Accent
    contentContainer.Parent = MainFrame
    
    -- Make Window Draggable
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = position
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateInput(input)
        end
    end)
    
    return {
        MakeTab = function(tabConfig)
            return FishItUI:MakeTab(tabConfig, tabContainer, contentContainer)
        end,
        MakeNotification = function(notificationConfig)
            FishItUI:MakeNotification(notificationConfig)
        end
    }
end

-- Create Tab
function FishItUI:MakeTab(config, tabContainer, contentContainer)
    local tab = {}
    local tabButton = nil
    local tabContent = nil
    
    -- Tab Button
    tabButton = Instance.new("TextButton")
    tabButton.Name = config.Name .. "Tab"
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.Position = UDim2.new(0, #Tabs * 100, 0, 0)
    tabButton.BackgroundColor3 = Colors.Background
    tabButton.BorderSizePixel = 0
    tabButton.Text = config.Name
    tabButton.TextColor3 = Colors.TextSecondary
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tabButton
    
    -- Tab Content
    tabContent = Instance.new("Frame")
    tabContent.Name = config.Name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = contentContainer
    
    -- Tab Functions
    function tab:AddSection(config)
        local section = {}
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = config.Name .. "Section"
        sectionFrame.Size = UDim2.new(1, -20, 0, 40)
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Parent = tabContent
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "SectionTitle"
        sectionTitle.Size = UDim2.new(1, 0, 0, 20)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = config.Name
        sectionTitle.TextColor3 = Colors.Text
        sectionTitle.TextScaled = true
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = sectionFrame
        
        local line = Instance.new("Frame")
        line.Name = "Line"
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0, 25)
        line.BackgroundColor3 = Colors.Accent
        line.BorderSizePixel = 0
        line.Parent = sectionFrame
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "Content"
        contentFrame.Size = UDim2.new(1, 0, 1, -30)
        contentFrame.Position = UDim2.new(0, 0, 0, 30)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = sectionFrame
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = contentFrame
        
        function section:AddButton(config)
            local button = Instance.new("TextButton")
            button.Name = config.Name .. "Button"
            button.Size = UDim2.new(1, 0, 0, 35)
            button.BackgroundColor3 = Colors.Secondary
            button.BorderSizePixel = 0
            button.Text = config.Name
            button.TextColor3 = Colors.Text
            button.TextScaled = true
            button.Font = Enum.Font.Gotham
            button.Parent = contentFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = button
            
            button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            -- Hover effects
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = Colors.Accent
            end)
            
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = Colors.Secondary
            end)
        end
        
        function section:AddToggle(config)
            local toggle = Instance.new("Frame")
            toggle.Name = config.Name .. "Toggle"
            toggle.Size = UDim2.new(1, 0, 0, 35)
            toggle.BackgroundTransparency = 1
            toggle.Parent = contentFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(1, -50, 1, 0)
            toggleButton.Position = UDim2.new(0, 0, 0, 0)
            toggleButton.BackgroundColor3 = Colors.Secondary
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = config.Name
            toggleButton.TextColor3 = Colors.Text
            toggleButton.TextScaled = true
            toggleButton.Font = Enum.Font.Gotham
            toggleButton.TextXAlignment = Enum.TextXAlignment.Left
            toggleButton.Parent = toggle
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 4)
            toggleCorner.Parent = toggleButton
            
            local toggleSwitch = Instance.new("Frame")
            toggleSwitch.Name = "ToggleSwitch"
            toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
            toggleSwitch.Position = UDim2.new(1, -45, 0.5, -10)
            toggleSwitch.BackgroundColor3 = config.Default and Colors.Success or Colors.Error
            toggleSwitch.BorderSizePixel = 0
            toggleSwitch.Parent = toggle
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(0, 10)
            switchCorner.Parent = toggleSwitch
            
            local switchDot = Instance.new("Frame")
            switchDot.Name = "SwitchDot"
            switchDot.Size = UDim2.new(0, 16, 0, 16)
            switchDot.Position = UDim2.new(0, 2, 0, 2)
            switchDot.BackgroundColor3 = Colors.Text
            switchDot.BorderSizePixel = 0
            switchDot.Parent = toggleSwitch
            
            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(0, 8)
            dotCorner.Parent = switchDot
            
            local state = config.Default or false
            
            local function updateToggle()
                if state then
                    toggleSwitch.BackgroundColor3 = Colors.Success
                    switchDot.Position = UDim2.new(1, -18, 0, 2)
                else
                    toggleSwitch.BackgroundColor3 = Colors.Error
                    switchDot.Position = UDim2.new(0, 2, 0, 2)
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
                if config.Callback then
                    config.Callback(state)
                end
            end)
            
            updateToggle()
        end
        
        function section:AddSlider(config)
            local slider = Instance.new("Frame")
            slider.Name = config.Name .. "Slider"
            slider.Size = UDim2.new(1, 0, 0, 50)
            slider.BackgroundTransparency = 1
            slider.Parent = contentFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "SliderLabel"
            sliderLabel.Size = UDim2.new(1, 0, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = config.Name .. ": " .. config.Default
            sliderLabel.TextColor3 = Colors.Text
            sliderLabel.TextScaled = true
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = slider
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Name = "SliderTrack"
            sliderTrack.Size = UDim2.new(1, 0, 0, 6)
            sliderTrack.Position = UDim2.new(0, 0, 0, 25)
            sliderTrack.BackgroundColor3 = Colors.Secondary
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = slider
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(0, 3)
            trackCorner.Parent = sliderTrack
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = config.Color or Colors.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 3)
            fillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Name = "SliderButton"
            sliderButton.Size = UDim2.new(0, 20, 0, 20)
            sliderButton.Position = UDim2.new(0, -10, 0, -7)
            sliderButton.BackgroundColor3 = Colors.Text
            sliderButton.BorderSizePixel = 0
            sliderButton.Text = ""
            sliderButton.Parent = sliderTrack
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 10)
            buttonCorner.Parent = sliderButton
            
            local value = config.Default or config.Min
            local min = config.Min or 0
            local max = config.Max or 100
            local increment = config.Increment or 1
            
            local function updateSlider()
                local percentage = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderButton.Position = UDim2.new(percentage, -10, 0, -7)
                sliderLabel.Text = config.Name .. ": " .. math.floor(value)
            end
            
            local dragging = false
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local relativeX = mouse.X - sliderTrack.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * percentage / increment) * increment
                    value = math.clamp(value, min, max)
                    updateSlider()
                    if config.Callback then
                        config.Callback(value)
                    end
                end
            end)
            
            updateSlider()
        end
        
        function section:AddParagraph(title, content)
            local paragraph = Instance.new("Frame")
            paragraph.Name = title .. "Paragraph"
            paragraph.Size = UDim2.new(1, 0, 0, 60)
            paragraph.BackgroundTransparency = 1
            paragraph.Parent = contentFrame
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Name = "Title"
            titleLabel.Size = UDim2.new(1, 0, 0, 20)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = Colors.Text
            titleLabel.TextScaled = true
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = paragraph
            
            local contentLabel = Instance.new("TextLabel")
            contentLabel.Name = "Content"
            contentLabel.Size = UDim2.new(1, 0, 1, -25)
            contentLabel.Position = UDim2.new(0, 0, 0, 25)
            contentLabel.BackgroundTransparency = 1
            contentLabel.Text = content
            contentLabel.TextColor3 = Colors.TextSecondary
            contentLabel.TextScaled = true
            contentLabel.Font = Enum.Font.Gotham
            contentLabel.TextXAlignment = Enum.TextXAlignment.Left
            contentLabel.TextYAlignment = Enum.TextYAlignment.Top
            contentLabel.Parent = paragraph
        end
        
        return section
    end
    
    -- Tab Click Handler
    tabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, existingTab in pairs(Tabs) do
            if existingTab.Content then
                existingTab.Content.Visible = false
            end
        end
        
        -- Show current tab
        tabContent.Visible = true
        CurrentTab = tab
        
        -- Update tab colors
        for _, existingTab in pairs(Tabs) do
            if existingTab.Button then
                existingTab.Button.BackgroundColor3 = Colors.Background
                existingTab.Button.TextColor3 = Colors.TextSecondary
            end
        end
        
        tabButton.BackgroundColor3 = Colors.Accent
        tabButton.TextColor3 = Colors.Text
    end)
    
    table.insert(Tabs, {Button = tabButton, Content = tabContent})
    
    -- Show first tab by default
    if #Tabs == 1 then
        tabContent.Visible = true
        CurrentTab = tab
        tabButton.BackgroundColor3 = Colors.Accent
        tabButton.TextColor3 = Colors.Text
    end
    
    return tab
end

-- Create Notification
function FishItUI:MakeNotification(config)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 0, 10)
    notification.BackgroundColor3 = Colors.Background
    notification.BorderSizePixel = 0
    notification.Parent = ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifShadow = Instance.new("ImageLabel")
    notifShadow.Name = "Shadow"
    notifShadow.Size = UDim2.new(1, 10, 1, 10)
    notifShadow.Position = UDim2.new(0, -5, 0, -5)
    notifShadow.BackgroundTransparency = 1
    notifShadow.Image = "rbxassetid://1316045217"
    notifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    notifShadow.ImageTransparency = 0.5
    notifShadow.ScaleType = Enum.ScaleType.Slice
    notifShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    notifShadow.ZIndex = notification.ZIndex - 1
    notifShadow.Parent = ScreenGui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -50, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name or "Notification"
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, -20, 1, -35)
    contentLabel.Position = UDim2.new(0, 10, 0, 30)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = config.Content or ""
    contentLabel.TextColor3 = Colors.TextSecondary
    contentLabel.TextScaled = true
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.Parent = notification
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Colors.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Colors.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = notification
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        notification:Destroy()
    end)
    
    -- Auto remove after time
    local time = config.Time or 5
    game:GetService("Debris"):AddItem(notification, time)
    
    -- Slide in animation
    local tween = game:GetService("TweenService"):Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 0, 10)
    })
    tween:Play()
end

return FishItUI
