-- Fly or Die V2 (FIXED CONTROLS)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Đợi nhân vật spawn
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Cấu hình bay
local flySpeed = 50
local isFlying = false
local flyConnection

-- Hàm tạo hiệu ứng bay chuyên nghiệp
local function StartFly()
    if isFlying then return end
    
    isFlying = true
    Humanoid.PlatformStand = true
    
    -- Tạo các bộ phận vật lý
    local AlignPos = Instance.new("AlignPosition")
    local AlignGyro = Instance.new("AlignOrientation")
    local BodyGyro = Instance.new("BodyGyro")
    
    -- Cấu hình AlignPosition
    AlignPos.Parent = RootPart
    AlignPos.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    AlignPos.Responsiveness = 200
    
    -- Cấu hình AlignOrientation
    AlignGyro.Parent = RootPart
    AlignGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    AlignGyro.Responsiveness = 200
    
    -- Cấu hình BodyGyro
    BodyGyro.Parent = RootPart
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    
    -- Kết nối sự kiện bay
    flyConnection = RunService.Heartbeat:Connect(function()
        if not isFlying or not Character:FindFirstChild("HumanoidRootPart") then return end
        
        -- Xử lý hướng bay
        local moveDirection = Vector3.new()
        local cframe = RootPart.CFrame
        
        -- Điều khiển WASD
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cframe.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cframe.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cframe.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cframe.RightVector
        end
        
        -- Điều khiển lên/xuống (Space/Ctrl)
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        -- Chuẩn hóa hướng và áp dụng tốc độ
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        end
        
        -- Cập nhật vị trí
        AlignPos.Position = RootPart.Position + moveDirection
        BodyGyro.CFrame = cframe
    end)
end

-- Hàm dừng bay
local function StopFly()
    if not isFlying then return end
    
    isFlying = false
    Humanoid.PlatformStand = false
    
    if flyConnection then
        flyConnection:Disconnect()
    end
    
    -- Dọn dẹp các Instance
    for _, obj in ipairs(RootPart:GetChildren()) do
        if obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") or obj:IsA("BodyGyro") then
            obj:Destroy()
        end
    end
end

-- GUI điều khiển đơn giản
local function CreateFlyGUI()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local ToggleButton = Instance.new("TextButton")
    local SpeedLabel = Instance.new("TextLabel")
    local SpeedBox = Instance.new("TextBox")
    
    -- Cấu hình GUI
    ScreenGui.Parent = game:GetService("CoreGui")
    
    Frame.Size = UDim2.new(0, 200, 0, 120)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -60)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.Parent = ScreenGui
    
    ToggleButton.Size = UDim2.new(0, 180, 0, 40)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    ToggleButton.Text = "BẬT FLY"
    ToggleButton.Parent = Frame
    
    SpeedLabel.Size = UDim2.new(0, 80, 0, 30)
    SpeedLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
    SpeedLabel.Text = "Tốc độ:"
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedLabel.Parent = Frame
    
    SpeedBox.Size = UDim2.new(0, 80, 0, 30)
    SpeedBox.Position = UDim2.new(0.55, 0, 0.5, 0)
    SpeedBox.Text = tostring(flySpeed)
    SpeedBox.Parent = Frame
    
    -- Xử lý sự kiện
    ToggleButton.MouseButton1Click:Connect(function()
        if isFlying then
            StopFly()
            ToggleButton.Text = "BẬT FLY"
        else
            StartFly()
            ToggleButton.Text = "TẮT FLY"
        end
    end)
    
    SpeedBox.FocusLost:Connect(function()
        local newSpeed = tonumber(SpeedBox.Text)
        if newSpeed and newSpeed > 0 then
            flySpeed = newSpeed
        else
            SpeedBox.Text = tostring(flySpeed)
        end
    end)
end

-- Tự động reset khi nhân vật chết
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    
    Humanoid.Died:Connect(StopFly)
end)

-- Khởi tạo GUI
CreateFlyGUI()
