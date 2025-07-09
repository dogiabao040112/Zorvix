local Plr = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cấu hình
local Speed = 50
local isFlying = false
local FlyForce, AlignPos, BodyGyro
local HRP

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControlPro"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.Position = UDim2.new(0.8, -175, 0.5, -100)
MainFrame.Size = UDim2.new(0, 150, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

-- Thêm các thành phần GUI (tương tự như trước)
-- [Đoạn code tạo GUI giữ nguyên như bạn đã viết]

-- Hàm Fly tối ưu
local function StartFly()
    if isFlying then return end
    
    -- Đảm bảo nhân vật tồn tại
    if not Plr.Character then
        Plr.CharacterAdded:Wait()
    end
    HRP = Plr.Character:WaitForChild("HumanoidRootPart")
    
    -- Tạo các thành phần vật lý
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
    
    -- Tắt trọng lực cho nhân vật
    local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.PlatformStand = true
    end
    
    isFlying = true
    UpdateGUI(true)
    
    -- Vòng lặp bay
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not isFlying or not HRP or not HRP.Parent then
            flyConnection:Disconnect()
            return
        end
        
        local moveDirection = Vector3.new()
        local cframe = Camera.CFrame
        
        -- Điều khiển WASD
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection += cframe.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection -= cframe.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection -= cframe.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection += cframe.RightVector end
        
        -- Điều khiển lên/xuống
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection += Vector3.new(0, -1, 0) end
        
        -- Chuẩn hóa và áp dụng tốc độ
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * Speed
        end
        
        -- Cập nhật vị trí
        AlignPos.Position = HRP.Position + moveDirection
        BodyGyro.CFrame = cframe
    end)
end

local function StopFly()
    if not isFlying then return end
    
    -- Dọn dẹp
    if FlyForce then FlyForce:Destroy() end
    if AlignPos then AlignPos:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    
    -- Khôi phục trọng lực
    if Plr.Character then
        local Humanoid = Plr.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.PlatformStand = false
        end
    end
    
    isFlying = false
    UpdateGUI(false)
end

-- Tự động xử lý khi nhân vật chết
Plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(StopFly)
end)
