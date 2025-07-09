local Plr = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cài đặt ban đầu
local Speed = 50
local isFlying = false
local FlyForce
local HRP

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")
local SpeedBox = Instance.new("TextBox")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "FlyControl"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 150)
MainFrame.Position = UDim2.new(0.8, 0, 0.5, -75)
MainFrame.Size = UDim2.new(0, 150, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
Title.Size = UDim2.new(0, 150, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "FLY CONTROL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 80, 80)
ToggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "BẬT FLY"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14.000

SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundTransparency = 1.000
SpeedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedLabel.Size = UDim2.new(0, 50, 0, 20)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "Tốc độ:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 12.000
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

SpeedBox.Name = "SpeedBox"
SpeedBox.Parent = MainFrame
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.Position = UDim2.new(0.5, 0, 0.6, 0)
SpeedBox.Size = UDim2.new(0, 50, 0, 20)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.Text = tostring(Speed)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextSize = 12.000

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1.000
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0, 120, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Trạng thái: TẮT"
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.TextSize = 12.000

-- Hàm bật fly
local function StartFly()
    if isFlying then return end
    
    -- Đảm bảo nhân vật tồn tại
    if not Plr.Character then
        Plr.CharacterAdded:Wait()
    end
    HRP = Plr.Character:WaitForChild("HumanoidRootPart")
    
    -- Tạo lực bay
    FlyForce = Instance.new("BodyVelocity")
    FlyForce.Parent = HRP
    FlyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyForce.Velocity = Vector3.new()
    
    -- Tắt trọng lực
    HRP:FindFirstChildOfClass("BodyForce"):Destroy()
    
    isFlying = true
    ToggleButton.Text = "TẮT FLY"
    StatusLabel.Text = "Trạng thái: BẬT"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    -- Kết nối sự kiện bay
    local GetMoveVector = require(Plr:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    
    RunService.RenderStepped:Connect(function()
        if not isFlying or not HRP or not FlyForce then return end
        
        FlyForce.Velocity = Vector3.new()
        local MoveDir = GetMoveVector:GetMoveVector()
        
        -- Xử lý di chuyển theo camera
        if MoveDir.X ~= 0 then
            FlyForce.Velocity = FlyForce.Velocity + Camera.CFrame.RightVector * MoveDir.X * Speed
        end
        if MoveDir.Z ~= 0 then
            FlyForce.Velocity = FlyForce.Velocity - Camera.CFrame.LookVector * MoveDir.Z * Speed
        end
        
        -- Xử lý bay lên/xuống
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            FlyForce.Velocity = FlyForce.Velocity + Vector3.new(0, Speed, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            FlyForce.Velocity = FlyForce.Velocity + Vector3.new(0, -Speed, 0)
        end
    end)
end

-- Hàm tắt fly
local function StopFly()
    if not isFlying then return end
    
    isFlying = false
    if FlyForce then FlyForce:Destroy() end
    
    -- Khôi phục trọng lực
    if HRP then
        local BodyForce = Instance.new("BodyForce")
        BodyForce.Parent = HRP
        BodyForce.Force = Vector3.new(0, HRP:GetMass() * workspace.Gravity, 0)
    end
    
    ToggleButton.Text = "BẬT FLY"
    StatusLabel.Text = "Trạng thái: TẮT"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
end

-- Xử lý sự kiện GUI
ToggleButton.MouseButton1Click:Connect(function()
    if isFlying then
        StopFly()
    else
        StartFly()
    end
end)

SpeedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed and newSpeed > 0 then
        Speed = newSpeed
    else
        SpeedBox.Text = tostring(Speed)
    end
end)

-- Tự động dừng khi nhân vật chết
Plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(StopFly)
end)
