local Plr = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cấu hình
local Speed = 50
local isFlying = false
local FlyForce
local HRP
local flyConnection

-- Tạo GUI cao cấp
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyOrDieV2"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 150)
MainFrame.Position = UDim2.new(0.8, -175, 0.5, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 90)
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "FLY OR DIE V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 80)
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
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedBox.Position = UDim2.new(0.55, 0, 0.6, 0)
SpeedBox.Size = UDim2.new(0, 60, 0, 20)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.Text = tostring(Speed)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.ClearTextOnFocus = false

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0, 160, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Trạng thái: TẮT"
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 14

-- Hàm bật fly (giữ nguyên cơ chế của bạn)
local function StartFly()
    if isFlying then return end
    
    if not Plr.Character then
        Plr.CharacterAdded:Wait()
    end
    HRP = Plr.Character:WaitForChild("HumanoidRootPart")
    
    -- Tạo lực bay và tắt hiệu ứng rơi
    FlyForce = Instance.new("BodyVelocity")
    FlyForce.Parent = HRP
    FlyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyForce.Velocity = Vector3.new()
    
    -- Tắt trọng lực cho nhân vật
    local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.PlatformStand = true
    end
    
    isFlying = true
    ToggleBtn.Text = "TẮT FLY"
    StatusLabel.Text = "Trạng thái: BẬT"
    StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    
    -- Kết nối sự kiện bay (giữ nguyên cơ chế của bạn)
    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not HRP or not FlyForce then return end
        
        FlyForce.Velocity = Vector3.new()
        local MoveDir = GetMoveVector:GetMoveVector()
        
        -- Thêm điều khiển bay lên/xuống
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            FlyForce.Velocity = FlyForce.Velocity + Vector3.new(0, Speed, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            FlyForce.Velocity = FlyForce.Velocity + Vector3.new(0, -Speed, 0)
        end
        
        if MoveDir.X > 0 then
            FlyForce.Velocity = FlyForce.Velocity + Camera.CFrame.RightVector * MoveDir.X * Speed
        end
        if MoveDir.X < 0 then
            FlyForce.Velocity = FlyForce.Velocity + Camera.CFrame.RightVector * MoveDir.X * Speed
        end
        if MoveDir.Z > 0 then
            FlyForce.Velocity = FlyForce.Velocity - Camera.CFrame.LookVector * MoveDir.Z * Speed
        end
        if MoveDir.Z < 0 then
            FlyForce.Velocity = FlyForce.Velocity - Camera.CFrame.LookVector * MoveDir.Z * Speed
        end
    end)
end

-- Hàm tắt fly
local function StopFly()
    if not isFlying then return end
    
    isFlying = false
    if flyConnection then flyConnection:Disconnect() end
    if FlyForce then FlyForce:Destroy() end
    
    -- Khôi phục trọng lực
    if Plr.Character then
        local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.PlatformStand = false
        end
    end
    
    ToggleBtn.Text = "BẬT FLY"
    StatusLabel.Text = "Trạng thái: TẮT"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
end

-- Xử lý sự kiện GUI
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

-- Tự động dừng khi nhân vật chết
Plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(StopFly)
end)

if Plr.Character then
    local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.Died:Connect(StopFly)
    end
end
