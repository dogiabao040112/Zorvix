-- Fly or Die V2 - Universal Version (PC + Mobile)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Color scheme
local mainColor = Color3.fromRGB(10, 100, 200)
local secondaryColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(255, 100, 50)
local successColor = Color3.fromRGB(50, 255, 50)
local warningColor = Color3.fromRGB(255, 150, 50)

-- System variables
local flying = false
local flySpeed = 50
local flyDebounce = false
local bodyVelocity, bodyGyro
local flyConnection

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyOrDieV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = mainColor
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- [Previous GUI elements remain the same...]

-- Mobile controls
local MobileControls = Instance.new("Frame")
MobileControls.Name = "MobileControls"
MobileControls.Size = UDim2.new(1, -20, 0, 100)
MobileControls.Position = UDim2.new(0, 10, 0, 140)
MobileControls.BackgroundTransparency = 1
MobileControls.Visible = UserInputService.TouchEnabled

local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(0.3, 0, 0, 40)
UpButton.Position = UDim2.new(0.35, 0, 0, 0)
UpButton.BackgroundColor3 = mainColor
UpButton.BackgroundTransparency = 0.3
UpButton.Text = "↑"
UpButton.TextColor3 = successColor
UpButton.Font = Enum.Font.GothamBold
UpButton.TextSize = 24
UpButton.TextScaled = true

local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0.3, 0, 0, 40)
DownButton.Position = UDim2.new(0.35, 0, 0, 50)
DownButton.BackgroundColor3 = mainColor
DownButton.BackgroundTransparency = 0.3
DownButton.Text = "↓"
DownButton.TextColor3 = warningColor
DownButton.Font = Enum.Font.GothamBold
DownButton.TextSize = 24
DownButton.TextScaled = true

UpButton.Parent = MobileControls
DownButton.Parent = MobileControls
MobileControls.Parent = MainFrame

-- Ensure GUI is parented correctly
local function ensureGui()
    repeat task.wait() until player:FindFirstChild("PlayerGui")
    ScreenGui.Parent = player.PlayerGui
end

ensureGui()

-- Improved flight system
local function enableFlight()
    if flyDebounce or not character or not rootPart then return end
    flyDebounce = true
    
    flying = true
    Status.Text = "STATUS: ON"
    Status.TextColor3 = successColor
    ToggleButton.Text = "TẮT BAY"
    ToggleButton.BackgroundColor3 = warningColor
    humanoid.PlatformStand = true
    
    -- Clean up previous physics objects
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    -- Create new physics objects
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0.1, 0) -- Small initial velocity
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.P = 1250
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
    bodyGyro.P = 10000
    bodyGyro.D = 500
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    -- Flight control connection
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.Heartbeat:Connect(function(dt)
        if not flying or not character or not rootPart or not bodyVelocity or not bodyGyro then
            if flyConnection then flyConnection:Disconnect() end
            return
        end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        local direction = Vector3.new()
        local cf = camera.CFrame
        local lookVector = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit -- Flattened look vector
        local rightVector = cf.RightVector
        
        -- Keyboard controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + (lookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - (lookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - (rightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + (rightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or (UpButton and UpButton:IsActive()) then
            direction = direction + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or (DownButton and DownButton:IsActive()) then
            direction = direction - Vector3.new(0, flySpeed, 0)
        end
        
        -- Apply movement
        bodyVelocity.Velocity = direction
        bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + lookVector)
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
    
    if flyConnection then flyConnection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    flyDebounce = false
end

local function toggleFlight()
    if flying then
        disableFlight()
    else
        enableFlight()
    end
end

-- Connect UI events
ToggleButton.MouseButton1Click:Connect(toggleFlight)
SpeedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 5, 100)
    SpeedDisplay.Text = "SPEED: " .. flySpeed
end)
SpeedDownButton.MouseButton1Click:Connect(function()
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

-- Character handling
humanoid.Died:Connect(disableFlight)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    humanoid.Died:Connect(disableFlight)
    
    if flying then
        disableFlight()
        task.wait(0.5)
        enableFlight()
    end
end)

-- GUI effects
RunService.Heartbeat:Connect(function(dt)
    local pulse = math.sin(tick()) * 0.005
    MainFrame.Size = UDim2.new(0, 350 * (1 + pulse), 0, 250 * (1 + pulse))
end)

print(Nhin vao cai nay la gay)
