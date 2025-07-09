-- Fly or Die V2 - Fixed GUI Version
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

-- Tạo GUI (Phiên bản đã fix hiển thị)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyOrDieV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10  -- Đảm bảo hiển thị trên các GUI khác

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.1, 0)  -- Đặt ở phía trên màn hình
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = mainColor
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0

-- Thêm các thành phần GUI như trước...
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

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
SpeedUpButton.Parent = SpeedControls

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
SpeedDownButton.Parent = SpeedControls

-- Thêm các controls vào MainFrame
SpeedControls.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Đảm bảo GUI được parent đúng cách
local function ensureGui()
    if not player:FindFirstChild("PlayerGui") then
        player:WaitForChild("PlayerGui")
    end
    ScreenGui.Parent = player.PlayerGui
end

ensureGui()

-- Các hàm bay và sự kiện như trước...
local function enableFlight()
    if flyDebounce then return end
    flyDebounce = true
    
    flying = true
    Status.Text = "STATUS: ON"
    Status.TextColor3 = successColor
    ToggleButton.Text = "TẮT BAY"
    ToggleButton.BackgroundColor3 = warningColor
    humanoid.PlatformStand = true
    
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
    
    flyConnection = RunService.Heartbeat:Connect(function(dt)
        if not flying or not character:FindFirstChild("HumanoidRootPart") then
            flyConnection:Disconnect()
            return
        end
        
        local camera = workspace.CurrentCamera
        local direction = Vector3.new()
        
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

-- Kết nối sự kiện nút
ToggleButton.MouseButton1Click:Connect(toggleFlight)
SpeedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 5, 100)
    SpeedDisplay.Text = "SPEED: " .. flySpeed
end)
SpeedDownButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 5, 10)
    SpeedDisplay.Text = "SPEED: " .. flySpeed
end)

-- Kết nối sự kiện bàn phím
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

-- Tự động tắt khi nhân vật chết
humanoid.Died:Connect(disableFlight)

-- Xử lý respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    humanoid.Died:Connect(disableFlight)
    
    if flying then
        disableFlight()
        enableFlight()
    end
end)

-- Hiệu ứng GUI
RunService.Heartbeat:Connect(function(dt)
    local pulse = math.sin(tick()) * 0.01
    MainFrame.Size = UDim2.new(0, 350 + pulse * 350, 0, 250 + pulse * 250)
end)

print("l me may")
