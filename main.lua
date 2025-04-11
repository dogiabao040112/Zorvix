--// Banana Cat Hub - Bản nâng cấp cho Blox Fruits
--// Made by ChatGPT (theo yêu cầu của bạn 😼)

-- Tải UI Library MaruHub Style
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "Banana Cat Hub 🍌🐱",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BananaCatHub"
})

-- GLOBALS
getgenv().Settings = {
    AutoFarm = false,
    FastAttack = false,
    AutoAggro = false,
    SelectedWeapon = "None"
}

-- EQUIP TOOL FUNCTION
function EquipTool(name)
    for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == name then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
end

-- LOOP FUNCTION
function LoopFunc(key, func, delay)
    coroutine.wrap(function()
        while getgenv().Settings[key] do
            pcall(func)
            wait(delay or 0.1)
        end
    end)()
end

-- AUTO FARM FUNCTION
function AutoFarmLevel()
    LoopFunc("AutoFarm", function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        local enemy = workspace.Enemies:FindFirstChildOfClass("Model")

        if getgenv().Settings.SelectedWeapon ~= "None" then
            EquipTool(getgenv().Settings.SelectedWeapon)
        end

        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)

            -- Gom quái
            if getgenv().Settings.AutoAggro then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") then
                        v.Humanoid:TakeDamage(0.1)
                    end
                end
            end

            -- Fast attack
            if getgenv().Settings.FastAttack then
                for _,tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Activate()
                    end
                end
            end
        end
    end)
end

-- TAB UI
local combatTab = Window:MakeTab({
    Name = "⚔️ Combat",
    Icon = "rbxassetid://6034985299",
    PremiumOnly = false
})

-- COMBAT OPTIONS
combatTab:AddDropdown({
    Name = "Chọn Vũ Khí",
    Default = "None",
    Options = (function()
        local tools = {"None"}
        for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            table.insert(tools, v.Name)
        end
        return tools
    end)(),
    Callback = function(v)
        getgenv().Settings.SelectedWeapon = v
    end
})

combatTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(v)
        getgenv().Settings.AutoFarm = v
        if v then AutoFarmLevel() end
    end
})

combatTab:AddToggle({
    Name = "Fast Attack",
    Default = false,
    Callback = function(v)
        getgenv().Settings.FastAttack = v
    end
})

combatTab:AddToggle({
    Name = "Gom Quái",
    Default = false,
    Callback = function(v)
        getgenv().Settings.AutoAggro = v
    end
})
