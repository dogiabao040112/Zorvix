local Plr = game.Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Speed = 50

if not Plr.Character then
	Plr.CharacterAdded:Wait()
end

local HRP: BasePart = Plr.Character:WaitForChild("HumanoidRootPart")
local FlyForce = Instance.new("BodyVelocity")
FlyForce.Parent = HRP

local GetMoveVector = require(Plr:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))

game["Run Service"].RenderStepped:Connect(function()
	FlyForce.Velocity = Vector3.new()
	local MoveDir: Vector3 = GetMoveVector:GetMoveVector()
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
