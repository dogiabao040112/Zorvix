--// Fly or Die GUI skibidiiiiiiiiiiiiiiiiiiiiiiiiiiiii

local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyToggle = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")
local SpeedSlider = Instance.new("TextBox")

-- GUI setup
ScreenGui.Name = "FlyOrDieGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.Size = UDim2.new(0, 250, 0, 150)
Main.Active = true
Main.Draggable = true

Title.Name = "Title"
Title.Parent = Main
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Fly or Die"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

FlyToggle.Name = "FlyToggle"
FlyToggle.Parent = Main
FlyToggle.Position = UDim2.new(0.1, 0, 0.35, 0)
FlyToggle.Size = UDim2.new(0.8, 0, 0.25, 0)
FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyToggle.Text = "Toggle Fly (OFF)"
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.TextSize = 16

SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = Main
SpeedLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
SpeedLabel.Size = UDim2.new(0.4, 0, 0.2, 0)
SpeedLabel.Text = "Speed:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 14
SpeedLabel.BackgroundTransparency = 1

SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Parent = Main
SpeedSlider.Position = UDim2.new(0.5, 0, 0.7, 0)
SpeedSlider.Size = UDim2.new(0.35, 0, 0.2, 0)
SpeedSlider.Text = "2"
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.ClearTextOnFocus = false

-- Fly logic
local UIS = game:GetService("UserInputService")
local fly = false
local speed = 2
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
bv.Velocity = Vector3.zero
bv.Parent = hrp
bv.Enabled = false

local direction = Vector3.zero

-- Input
UIS.InputBegan:Connect(function(input)
	if not fly then return end
	if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1) end
	if input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1) end
	if input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0) end
	if input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0) end
	if input.KeyCode == Enum.KeyCode.Space then direction = Vector3.new(0, 1, 0) end
	if input.KeyCode == Enum.KeyCode.LeftControl then direction = Vector3.new(0, -1, 0) end
end)

UIS.InputEnded:Connect(function(input)
	if not fly then return end
	direction = Vector3.zero
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if fly then
		local cf = workspace.CurrentCamera.CFrame
		local moveVec = (cf:VectorToWorldSpace(direction)).Unit * tonumber(SpeedSlider.Text)
		if moveVec ~= moveVec then moveVec = Vector3.zero end
		bv.Velocity = moveVec
	end
end)

FlyToggle.MouseButton1Click:Connect(function()
	fly = not fly
	bv.Enabled = fly
	FlyToggle.Text = fly and "Toggle Fly (ON)" or "Toggle Fly (OFF)"
end)

SpeedSlider.FocusLost:Connect(function()
	local num = tonumber(SpeedSlider.Text)
	if num then
		speed = num
	else
		SpeedSlider.Text = tostring(speed)
	end
end)
