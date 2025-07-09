-- Fly or Die V2 - Fixed Movement Version
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

-- Tạo GUI
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

-- [PHẦN TẠO GUI GIỮ NGUYÊN NHƯ TRƯỚC...]

-- Hàm bay đã được sửa
local function enableFlight()
    if flyDebounce or not character or not rootPart then return end
    flyDebounce = true
    
    flying = true
    Status.Text = "STATUS: ON"
    Status.TextColor3 = successColor
    ToggleButton.Text = "TẮT BAY"
    ToggleButton.BackgroundColor3 = warningColor
    humanoid.PlatformStand = true
    
    -- Tạo BodyVelocity và BodyGyro mới
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0.1, 0) -- Thêm velocity nhỏ để tránh lỗi
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.P = 1250
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
    bodyGyro.P = 10000
    bodyGyro.D = 500
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    -- Kết nối bay với xử lý chuyển động chính xác
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
        local lookVector = cf.LookVector
        local rightVector = cf.RightVector
        
        -- Xử lý đầu vào bàn phím
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
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, flySpeed, 0)
        end
        
        -- Áp dụng chuyển động
        bodyVelocity.Velocity = direction
        bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + lookVector)
    end)
    
    flyDebounce = false
end

-- [PHẦN CÒN LẠI CỦA SCRIPT GIỮ NGUYÊN...]

-- Kết nối sự kiện bàn phím mới
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

print(cl)
