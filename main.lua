-- Fly or Die V2 (Nâng cấp)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Màu sắc chủ đạo
local mainColor = Color3.fromRGB(10, 100, 200)
local secondaryColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(255, 100, 50)
local successColor = Color3.fromRGB(50, 255, 50)
local warningColor = Color3.fromRGB(255, 150, 50)

-- Biến hệ thống
local flying = false
local flySpeed = 50
local flyDebounce = false
local bodyVelocity, bodyGyro
local flyConnection

-- Tạo GUI nâng cao
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyOrDieV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = mainColor
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Size = UDim2.new(1, 10, 1, 10)
DropShadow.Position = UDim2.new(0, -5, 0, -5)
DropShadow.BackgroundTransparency = 1
DropShadow.Image = "rbxassetid://1316045217"
DropShadow.ImageColor3 = Color3.new(0, 0, 0)
DropShadow.ImageTransparency = 0.8
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(10, 10, 118, 118)
DropShadow.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "FLY OR DIE V2"
Title.TextColor3 = secondaryColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Status
local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(0.5, -15, 0, 30)
Status.Position = UDim2.new(0, 10, 0, 50)
Status.BackgroundTransparency = 1
Status.Text = "STATUS: OFF"
Status.TextColor3 = warningColor
Status.Font = Enum.Font.GothamBold
Status.TextSize = 16
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = MainFrame

-- Speed Display
local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Name = "SpeedDisplay"
SpeedDisplay.Size = UDim2.new(0.5, -15, 0, 30)
SpeedDisplay.Position = UDim2.new(0.5, 5, 0, 50)
SpeedDisplay.BackgroundTransparency = 1
SpeedDisplay.Text = "SPEED: " .. flySpeed
SpeedDisplay.TextColor3 = secondaryColor
SpeedDisplay.Font = Enum.Font.GothamBold
SpeedDisplay.TextSize = 16
SpeedDisplay.TextXAlignment = Enum.TextXAlignment.Right
SpeedDisplay.Parent = MainFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 90)
ToggleButton.BackgroundColor3 = accentColor
ToggleButton.Text = "BẬT BAY"
ToggleButton.TextColor3 = secondaryColor
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

ToggleButton.Parent = MainFrame

-- Speed Controls
local SpeedControls = Instance.new("Frame")
SpeedControls.Name = "SpeedControls"
SpeedControls.Size = UDim2.new(1, -20, 0, 80)
SpeedControls.Position = UDim2.new(0, 10, 0, 140)
SpeedControls.BackgroundTransparency = 1

-- Speed Up Button
local SpeedUpButton = Instance.new("TextButton")
SpeedUpButton.Name = "SpeedUpButton"
SpeedUpButton.Size = UDim2.new(0.5, -5, 0, 35)
SpeedUpButton.Position = UDim2.new(0, 0, 0, 0)
SpeedUpButton.BackgroundColor3 = mainColor
SpeedUpButton.BackgroundTransparency = 0.3
SpeedUpButton.Text = "TĂNG TỐC (+)"
SpeedUpButton.TextColor3 = secondaryColor
SpeedUpButton.Font = Enum.Font.Gotham
SpeedUpButton.TextSize = 14

local SpeedUpCorner = Instance.new("UICorner")
SpeedUpCorner.CornerRadius = UDim.new(0, 6)
SpeedUpCorner.Parent = SpeedUpButton

-- Speed Down Button
local SpeedDownButton = Instance.new("TextButton")
SpeedDownButton.Name = "SpeedDownButton"
SpeedDownButton.Size = UDim2.new(0.5, -5, 0, 35)
SpeedDownButton.Position = UDim2.new(0.5, 5, 0, 0)
SpeedDownButton.BackgroundColor3 = mainColor
SpeedDownButton.BackgroundTransparency = 0.3
SpeedDownButton.Text = "GIẢM TỐC (-)"
SpeedDownButton.TextColor3 = secondaryColor
SpeedDownButton.Font = Enum.Font.Gotham
SpeedDownButton.TextSize = 14

local SpeedDownCorner = Instance.new("UICorner")
SpeedDownCorner.CornerRadius = UDim.new(0, 6)
SpeedDownCorner.Parent = SpeedDownButton

-- Mobile Controls (for touch devices)
local MobileControls = Instance.new("Frame")
MobileControls.Name = "MobileControls"
MobileControls.Size = UDim2.new(1, -20, 0, 35)
MobileControls.Position = UDim2.new(0, 10, 0, 45)
MobileControls.BackgroundTransparency = 1
MobileControls.Visible = false -- Will be set based on device

local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(0.5, -5, 1, 0)
UpButton.Position = UDim2.new(0, 0, 0, 0)
UpButton.BackgroundColor3 = mainColor
UpButton.BackgroundTransparency = 0.3
UpButton.Text = "LÊN"
UpButton.TextColor3 = secondaryColor
UpButton.Font = Enum.Font.GothamBold
UpButton.TextSize = 14

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 6)
UpCorner.Parent = UpButton

local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0.5, -5, 1, 0)
DownButton.Position = UDim2.new(0.5, 5, 0, 0)
DownButton.BackgroundColor3 = mainColor
DownButton.BackgroundTransparency = 0.3
DownButton.Text = "XUỐNG"
DownButton.TextColor3 = secondaryColor
DownButton.Font = Enum.Font.GothamBold
DownButton.TextSize = 14

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 6)
DownCorner.Parent = DownButton

-- Add elements to parents
SpeedUpButton.Parent = SpeedControls
SpeedDownButton.Parent = SpeedControls
UpButton.Parent = MobileControls
DownButton.Parent = MobileControls
MobileControls.Parent = MainFrame
SpeedControls.Parent = MainFrame
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Detect if on mobile
if UserInputService.TouchEnabled then
    MobileControls.Visible = true
    SpeedControls.Position = UDim2.new(0, 10, 0, 190)
end

-- Animation functions
local function animateButton(button)
    local originalSize = button.Size
    local originalPos = button.Position
    
    local tweenIn = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = originalSize - UDim2.new(0, 10, 0, 5), Position = originalPos + UDim2.new(0, 5, 0, 2.5)}
    )
    
    local tweenOut = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
        {Size = originalSize, Position = originalPos}
    )
    
    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        tweenOut:Play()
    end)
end

-- Flight system
local function enableFlight()
    if flyDebounce then return end
    flyDebounce = true
    
    flying = true
    Status.Text = "STATUS: ON"
    Status.TextColor3 = successColor
    ToggleButton.Text = "TẮT BAY"
    ToggleButton.BackgroundColor3 = warningColor
    humanoid.PlatformStand = true
    
    -- Create physics objects
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.P = 1000
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.D = 500
    bodyGyro.Parent = rootPart
    
    -- Flight connection
    flyConnection = RunService.Heartbeat:Connect(function(dt)
        if not flying or not character:FindFirstChild("HumanoidRootPart") then
            flyConnection:Disconnect()
            return
        end
        
        local camera = workspace.CurrentCamera
        local direction = Vector3.new()
        
        -- Keyboard controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + (camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - (camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - (camera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + (camera.CFrame.RightVector * flySpeed)
        end
        
        -- Mobile controls
        if UpButton:IsActive() then
            direction = direction + (Vector3.new(0, 1, 0) * flySpeed
        end
        if DownButton:IsActive() then
            direction = direction - (Vector3.new(0, 1, 0) * flySpeed
        end
        
        -- Apply movement
        bodyVelocity.Velocity = direction
        bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
    end)
    
    flyDebounce = false
end

local function disableFlight()
    if flyDebounce then return end
    flyDebounce = true
    
    flying = false
    Status.Text = "STATUS: OFF"
    Status.TextColor3 = warningColor
    ToggleButton.Text = "BẬT BAY"
    ToggleButton.BackgroundColor3 = accentColor
    humanoid.PlatformStand = false
    
    if flyConnection then
        flyConnection:Disconnect()
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
    end
    
    flyDebounce = false
end

local function toggleFlight()
    if flying then
        disableFlight()
    else
        enableFlight()
    end
end

-- Button events
ToggleButton.MouseButton1Click:Connect(function()
    animateButton(ToggleButton)
    toggleFlight()
end)

SpeedUpButton.MouseButton1Click:Connect(function()
    animateButton(SpeedUpButton)
    flySpeed = math.min(flySpeed + 5, 100)
    SpeedDisplay.Text = "SPEED: " .. flySpeed
end)

SpeedDownButton.MouseButton1Click:Connect(function()
    animateButton(SpeedDownButton)
    flySpeed = math.max(flySpeed - 5, 10)
    SpeedDisplay.Text = "SPEED: " .. flySpeed
end)

-- Keyboard events
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        toggleFlight()
    elseif input.KeyCode == Enum.KeyCode.Equals then
        flySpeed = math.min(flySpeed + 5, 100)
        SpeedDisplay.Text = "SPEED: " .. flySpeed
    elseif input.KeyCode == Enum.KeyCode.Minus then
        flySpeed = math.max(flySpeed - 5, 10)
        SpeedDisplay.Text = "SPEED: " .. flySpeed
    end
end)

-- Auto-disable flight when character dies
character:WaitForChild("Humanoid").Died:Connect(function()
    disableFlight()
end)

-- Reconnect flight when character respawns
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    humanoid.Died:Connect(function()
        disableFlight()
    end)
    
    if flying then
        disableFlight()
        enableFlight()
    end
end)

-- GUI effects
local pulseSpeed = 1.5
local pulseAmount = 0.03
local initialSize = MainFrame.Size

RunService.Heartbeat:Connect(function(dt)
    local pulse = math.sin(tick() * pulseSpeed) * pulseAmount
    MainFrame.Size = initialSize + UDim2.new(0, pulse * initialSize.X.Offset, 0, pulse * initialSize.Y.Offset)
    
    -- Smooth color pulse effect
    local colorPulse = math.sin(tick() * 0.8) * 0.03
    MainFrame.BackgroundColor3 = mainColor:lerp(secondaryColor, math.abs(colorPulse))
end)

print("Nhìn cl")
