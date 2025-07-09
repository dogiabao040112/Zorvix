local Plr = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local Speed = 50
local isFlying = false
local FlyForce
local HRP

-- Tạo GUI đơn giản
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControl"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderColor3 = Color3.fromRGB(0, 150, 150)
Frame.Position = UDim2.new(0.8, -110, 0.5, -50)
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Active = true
Frame.Draggable = true

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "BẬT FLY"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = Frame
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedBox.Size = UDim2.new(0, 120, 0, 30)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.Text = tostring(Speed)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.PlaceholderText = "Tốc độ"

-- Hàm bật fly (giữ nguyên cơ chế của bạn)
local function StartFly()
    if isFlying then return end
    
    if not Plr.Character then
        Plr.CharacterAdded:Wait()
    end
    HRP = Plr.Character:WaitForChild("HumanoidRootPart")
    
    FlyForce = Instance.new("BodyVelocity")
    FlyForce.Parent = HRP
    FlyForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyForce.Velocity = Vector3.new()
    
    isFlying = true
    ToggleButton.Text = "TẮT FLY"
    
    local GetMoveVector = require(Plr:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if not isFlying or not HRP or not FlyForce then return end
        
        FlyForce.Velocity = Vector3.new()
        local MoveDir = GetMoveVector:GetMoveVector()
        
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
    if FlyForce then FlyForce:Destroy() end
    ToggleButton.Text = "BẬT FLY"
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
