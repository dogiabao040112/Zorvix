-- Fly or Die V2 (GUI FIXED) - Bản đặc biệt không lỗi
local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cấu hình
local FlySpeed = 50
local isFlying = false
local FlyConnection

-- Tạo GUI đảm bảo hiển thị
local function CreateGUI()
    local CoreGui = game:GetService("CoreGui")
    
    -- Kiểm tra nếu GUI đã tồn tại thì xóa đi
    if CoreGui:FindFirstChild("FlyOrDieV2") then
        CoreGui.FlyOrDieV2:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlyOrDieV2"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  -- Chống đè GUI

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
    MainFrame.Position = UDim2.new(0.8, -175, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 200, 0, 180)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Tiêu đề
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "FLY OR DIE V2"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14

    -- Nút bật/tắt
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

    -- Ô tốc độ
    local SpeedBox = Instance.new("TextBox")
    SpeedBox.Name = "SpeedBox"
    SpeedBox.Parent = MainFrame
    SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SpeedBox.Position = UDim2.new(0.3, 0, 0.6, 0)
    SpeedBox.Size = UDim2.new(0, 80, 0, 30)
    SpeedBox.Font = Enum.Font.Gotham
    SpeedBox.Text = tostring(FlySpeed)
    SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBox.PlaceholderText = "Tốc độ"

    -- Trạng thái
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
    StatusLabel.Size = UDim2.new(0, 160, 0, 30)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "Trạng thái: TẮT"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    StatusLabel.TextSize = 14

    return {
        ScreenGui = ScreenGui,
        ToggleBtn = ToggleBtn,
        SpeedBox = SpeedBox,
        StatusLabel = StatusLabel
    }
end

-- Hệ thống bay Pro
local function StartFly()
    if isFlying then return end
    
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    
    Humanoid.PlatformStand = true  -- Tắt hiệu ứng rơi
    
    isFlying = true
    GUI.StatusLabel.Text = "Trạng thái: BẬT"
    GUI.StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    GUI.ToggleBtn.Text = "TẮT FLY"

    FlyConnection = RunService.Heartbeat:Connect(function()
        if not isFlying or not RootPart or not RootPart.Parent then return end
        
        local moveDirection = Vector3.new()
        local camCF = Camera.CFrame
        
        -- Điều khiển WASD
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection += camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection += camCF.RightVector end
        
        -- Điều khiển lên/xuống
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection += Vector3.new(0, -1, 0) end
        
        -- Áp dụng tốc độ
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * FlySpeed
        end
        
        -- Di chuyển
        RootPart.Velocity = moveDirection
    end)
end

local function StopFly()
    if not isFlying then return end
    
    isFlying = false
    if FlyConnection then FlyConnection:Disconnect() end
    
    local Character = Player.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.PlatformStand = false
        end
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if RootPart then
            RootPart.Velocity = Vector3.new()
        end
    end
    
    GUI.StatusLabel.Text = "Trạng thái: TẮT"
    GUI.StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    GUI.ToggleBtn.Text = "BẬT FLY"
end

-- Khởi tạo GUI
local GUI = CreateGUI()

-- Xử lý sự kiện
GUI.ToggleBtn.MouseButton1Click:Connect(function()
    if isFlying then
        StopFly()
    else
        StartFly()
    end
end)

GUI.SpeedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(GUI.SpeedBox.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 500 then
        FlySpeed = newSpeed
    else
        GUI.SpeedBox.Text = tostring(FlySpeed)
    end
end)

-- Tự động dừng khi nhân vật chết
Player.CharacterAdded:Connect(function(Character)
    Character:WaitForChild("Humanoid").Died:Connect(StopFly)
end)
