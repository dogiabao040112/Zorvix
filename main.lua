
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyButton = Instance.new("TextButton")
local SpeedSlider = Instance.new("TextLabel")
local SpeedValue = Instance.new("TextBox")
local CloseButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- Cấu hình GUI
ScreenGui.Name = "FlyOrDieV2"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
Title.Size = UDim2.new(0, 300, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "FLY OR DIE V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18.000

FlyButton.Name = "FlyButton"
FlyButton.Parent = MainFrame
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
FlyButton.Position = UDim2.new(0.1, 0, 0.25, 0)
FlyButton.Size = UDim2.new(0, 240, 0, 50)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Text = "BẬT FLY"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 20.000

SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Parent = MainFrame
SpeedSlider.BackgroundTransparency = 1.000
SpeedSlider.Position = UDim2.new(0.1, 0, 0.55, 0)
SpeedSlider.Size = UDim2.new(0, 120, 0, 30)
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.Text = "Tốc độ:"
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.TextSize = 16.000
SpeedSlider.TextXAlignment = Enum.TextXAlignment.Left

SpeedValue.Name = "SpeedValue"
SpeedValue.Parent = MainFrame
SpeedValue.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedValue.Position = UDim2.new(0.6, 0, 0.55, 0)
SpeedValue.Size = UDim2.new(0, 60, 0, 30)
SpeedValue.Font = Enum.Font.Gotham
SpeedValue.PlaceholderText = "50"
SpeedValue.Text = "50"
SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValue.TextSize = 16.000

CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseButton.Position = UDim2.new(0.8, 0, 0.85, 0)
CloseButton.Size = UDim2.new(0, 50, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18.000

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1.000
StatusLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0, 240, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Trạng thái: TẮT"
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.TextSize = 16.000

-- Biến điều khiển
local flying = false
local flySpeed = 50
local flyConnection

-- Hàm fly
local function Fly()
    if flying then return end
    
    flying = true
    StatusLabel.Text = "Trạng thái: BẬT"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    FlyButton.Text = "TẮT FLY"
    
    local BV = Instance.new("BodyVelocity", RootPart)
    BV.Name = "FlyBV"
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(0, math.huge, 0)
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying or not Character or not RootPart then
            if flyConnection then flyConnection:Disconnect() end
            return
        end
        
        local direction = Vector3.new()
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + (RootPart.CFrame.LookVector * flySpeed)
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - (RootPart.CFrame.LookVector * flySpeed)
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - (RootPart.CFrame.RightVector * flySpeed)
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + (RootPart.CFrame.RightVector * flySpeed)
        end
        
        BV.Velocity = direction
        
        -- Kiểm tra nút Space và Ctrl để bay lên/xuống
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, flySpeed, RootPart.Velocity.Z)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, -flySpeed, RootPart.Velocity.Z)
        else
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, 0, RootPart.Velocity.Z)
        end
    end)
end

-- Hàm dừng fly
local function StopFly()
    if not flying then return end
    
    flying = false
    StatusLabel.Text = "Trạng thái: TẮT"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    FlyButton.Text = "BẬT FLY"
    
    if flyConnection then
        flyConnection:Disconnect()
    end
    
    if RootPart:FindFirstChild("FlyBV") then
        RootPart.FlyBV:Destroy()
    end
end

-- Xử lý sự kiện
FlyButton.MouseButton1Click:Connect(function()
    if flying then
        StopFly()
    else
        Fly()
    end
end)

SpeedValue.FocusLost:Connect(function(enterPressed)
    local newSpeed = tonumber(SpeedValue.Text)
    if newSpeed and newSpeed > 0 then
        flySpeed = newSpeed
    else
        SpeedValue.Text = tostring(flySpeed)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    StopFly()
    ScreenGui:Destroy()
end)

-- Tự động dừng khi nhân vật chết
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    
    Humanoid.Died:Connect(function()
        StopFly()
    end)
end)

if Humanoid then
    Humanoid.Died:Connect(function()
        StopFly()
    end)
end
