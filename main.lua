-- Fly or Die V2 (FIXED GUI + FLY) - Bản hoàn chỉnh
local Plr = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cấu hình
local Speed = 50
local isFlying = false
local FlyForce, AlignPos, BodyGyro
local HRP

-- Tạo GUI (Phiên bản fix lỗi)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControlPro"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 200)
MainFrame.Position = UDim2.new(0.75, 0, 0.5, -90)
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "FLY OR DIE V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleBtn.Size = UDim2.new(0, 160, 0, 40)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "BẬT FLY"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedLabel.Size = UDim2.new(0, 80, 0, 20)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "Tốc độ:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Parent = MainFrame
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.Position = UDim2.new(0.6, 0, 0.6, 0)
SpeedBox.Size = UDim2.new(0, 60, 0, 20)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.Text = tostring(Speed)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0, 160, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Trạng thái: TẮT"
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)

-- Hệ thống bay Pro
local function StartFly()
    if isFlying then return end
    
    -- Đảm bảo nhân vật tồn tại
    if not Plr.Character then
        Plr.CharacterAdded:Wait()
    end
    HRP = Plr.Character:WaitForChild("HumanoidRootPart")
    
    -- Tạo bộ điều khiển bay
    FlyForce = Instance.new("BodyVelocity")
    AlignPos = Instance.new("AlignPosition")
    BodyGyro = Instance.new("BodyGyro")
    
    -- Cấu hình
    FlyForce.Parent = HRP
    FlyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyForce.Velocity = Vector3.new()
    
    AlignPos.Parent = HRP
    AlignPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    AlignPos.Responsiveness = 200
    
    BodyGyro.Parent = HRP
    BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BodyGyro.CFrame = HRP.CFrame
    
    -- Tắt hiệu ứng rơi
    local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.PlatformStand = true
    end
    
    isFlying = true
    ToggleBtn.Text = "TẮT FLY"
    StatusLabel.Text = "Trạng thái: BẬT"
    StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    
    -- Điều khiển bay
    local flyConn
    flyConn = RunService.Heartbeat:Connect(function()
        if not isFlying or not HRP or not HRP.Parent then
            flyConn:Disconnect()
            return
        end
        
        local moveDir = Vector3.new()
        local camCF = Camera.CFrame
        
        -- WASD Movement
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
        
        -- Up/Down
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir += Vector3.new(0, -1, 0) end
        
        -- Apply movement
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * Speed
        end
        
        AlignPos.Position = HRP.Position + moveDir
        BodyGyro.CFrame = camCF
    end)
end

local function StopFly()
    if not isFlying then return end
    
    -- Cleanup
    if FlyForce then FlyForce:Destroy() end
    if AlignPos then AlignPos:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    
    -- Restore physics
    if Plr.Character then
        local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.PlatformStand = false
        end
    end
    
    isFlying = false
    ToggleBtn.Text = "BẬT FLY"
    StatusLabel.Text = "Trạng thái: TẮT"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
end

-- GUI Events
ToggleBtn.MouseButton1Click:Connect(function()
    if isFlying then
        StopFly()
    else
        StartFly()
    end
end)

SpeedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 500 then
        Speed = newSpeed
    else
        SpeedBox.Text = tostring(Speed)
    end
end)

-- Auto-cleanup
Plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(StopFly)
end)

if Plr.Character then
    Plr.Character:WaitForChild("Humanoid").Died:Connect(StopFly)
end
