--// Banana Cat Hub - Bản nâng cấp cho Blox Fruits
--// Made by Zorvix (theo yêu cầu của bạn 😼)

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
    AutoFruit = false,
    AutoStoreFruit = false,
    SelectedWeapon = "None",
    AutoMagnet = false,
    AutoPrehistoric = false,
    AutoBoneEgg = false,
    AutoSeaEvent = false,
    AutoQuest = false,
    AutoStats = false,
    AutoHaki = false,
    AutoRaid = false,
    AutoTrial = false,
    AutoBoss = false,
    AutoIsland = false,
    AutoSword = false,
    AutoGun = false,
    AutoFightingStyle = false,
    AutoBoat = false,
    AutoTitle = false,
    AutoCosmetic = false,
    AutoFastAttack = false,
    AutoAggro = false,
    AutoV3 = false,
    AutoV4 = false,
    Skills = {
        Z = true,
        X = true,
        C = true,
        V = true,
        F = true
    }
}

-- UTILITIES
function EquipTool(name)
    for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == name then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
end

function LoopFunc(key, func, delay)
    coroutine.wrap(function()
        while getgenv().Settings[key] do
            pcall(func)
            wait(delay or 1)
        end
    end)()
end

-- AUTO FARM LEVEL + AGGRO + FAST ATTACK
function AutoFarmLevel()
    LoopFunc("AutoFarm", function()
        if getgenv().Settings.SelectedWeapon ~= "None" then
            EquipTool(getgenv().Settings.SelectedWeapon)
        end
        local Enemy = workspace.Enemies:FindFirstChildOfClass("Model")
        if Enemy then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0,10,5)
            if getgenv().Settings.AutoAggro then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") then
                        v.Humanoid:TakeDamage(0.1)
                    end
                end
            end
            if getgenv().Settings.AutoFastAttack then
                for _,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Tool") then
                        v:Activate()
                    end
                end
            end
        end
    end)
end

-- AUTO SEA EVENT (DÙNG KỸ NĂNG)
function AutoSeaEvents()
    LoopFunc("AutoSeaEvent", function()
        for _, key in pairs({"Z", "X", "C", "V", "F"}) do
            if getgenv().Settings.Skills[key] then
                keypress(Enum.KeyCode[key])
                wait(0.1)
                keyrelease(Enum.KeyCode[key])
            end
        end
    end, 1)
end

-- AUTO FRUIT
function AutoFruitLoop()
    LoopFunc("AutoFruit", function()
        for _,v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                break
            end
        end
    end, 1)
end

-- AUTO STORE FRUIT
function AutoStoreFruit()
    LoopFunc("AutoStoreFruit", function()
        local fruit = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
        if fruit and string.find(fruit.Name, "Fruit") then
            local args = { [1] = "StoreFruit", [2] = fruit }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_" ):InvokeServer(unpack(args))
        end
    end, 2)
end

-- TABS
local combat = Window:MakeTab({Name = "⚔️ Combat", Icon = "rbxassetid://6034985299"})
local fruits = Window:MakeTab({Name = "🍎 Fruits", Icon = "rbxassetid://6031075938"})
local quests = Window:MakeTab({Name = "📜 Quests", Icon = "rbxassetid://6031215980"})
local island = Window:MakeTab({Name = "🌋 Prehistoric", Icon = "rbxassetid://6031068424"})
local raids = Window:MakeTab({Name = "🔥 Raids", Icon = "rbxassetid://6031258887"})
local other = Window:MakeTab({Name = "⚙️ Other", Icon = "rbxassetid://6034509993"})

-- COMBAT
combat:AddDropdown({Name = "🔪 Vũ Khí", Default = "None", Options = (function()
    local tools = {"None"}
    for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do table.insert(tools, v.Name) end
    return tools
end)(), Callback = function(v) getgenv().Settings.SelectedWeapon = v end})
combat:AddToggle({Name = "Auto Farm Level", Default = false, Callback = function(v) getgenv().Settings.AutoFarm = v if v then AutoFarmLevel() end end})
combat:AddToggle({Name = "Fast Attack", Default = false, Callback = function(v) getgenv().Settings.AutoFastAttack = v end})
combat:AddToggle({Name = "Gom Quái", Default = false, Callback = function(v) getgenv().Settings.AutoAggro = v end})

-- FRUITS
fruits:AddToggle({Name = "Auto Nhặt Trái", Default = false, Callback = function(v) getgenv().Settings.AutoFruit = v if v then AutoFruitLoop() end end})
fruits:AddToggle({Name = "Auto Lưu Trái", Default = false, Callback = function(v) getgenv().Settings.AutoStoreFruit = v if v then AutoStoreFruit() end end})

-- QUEST
quests:AddToggle({Name = "Auto Nhiệm Vụ", Default = false, Callback = function(v) getgenv().Settings.AutoQuest = v end})

-- ISLAND
island:AddToggle({Name = "Auto Chế Volcanic Magnet", Default = false, Callback = function(v) getgenv().Settings.AutoMagnet = v end})
island:AddToggle({Name = "Auto Đánh Đảo + Lượm Egg", Default = false, Callback = function(v) getgenv().Settings.AutoPrehistoric = v end})
island:AddToggle({Name = "Auto Nhặt Xương & Trứng", Default = false, Callback = function(v) getgenv().Settings.AutoBoneEgg = v end})

-- RAIDS
raids:AddToggle({Name = "Auto Raid", Default = false, Callback = function(v) getgenv().Settings.AutoRaid = v end})
raids:AddToggle({Name = "Auto Trial", Default = false, Callback = function(v) getgenv().Settings.AutoTrial = v end})
raids:AddToggle({Name = "Auto Boss", Default = false, Callback = function(v) getgenv().Settings.AutoBoss = v end})

-- OTHER
other:AddToggle({Name = "Auto Sự Kiện Biển (dùng chiêu)", Default = false, Callback = function(v) getgenv().Settings.AutoSeaEvent = v if v then AutoSeaEvents() end end})
other:AddToggle({Name = "Auto Haki", Default = false, Callback = function(v) getgenv().Settings.AutoHaki = v end})
other:AddToggle({Name = "Auto Stats", Default = false, Callback = function(v) getgenv().Settings.AutoStats = v end})
other:AddToggle({Name = "Auto Kiếm", Default = false, Callback = function(v) getgenv().Settings.AutoSword = v end})
other:AddToggle({Name = "Auto Súng", Default = false, Callback = function(v) getgenv().Settings.AutoGun = v end})
other:AddToggle({Name = "Auto Fighting Style", Default = false, Callback = function(v) getgenv().Settings.AutoFightingStyle = v end})
other:AddToggle({Name = "Auto Thuyền", Default = false, Callback = function(v) getgenv().Settings.AutoBoat = v end})
other:AddToggle({Name = "Auto Đảo", Default = false, Callback = function(v) getgenv().Settings.AutoIsland = v end})
other:AddToggle({Name = "Auto Danh Hiệu", Default = false, Callback = function(v) getgenv().Settings.AutoTitle = v end})
other:AddToggle({Name = "Auto Đồ Trang Trí", Default = false, Callback = function(v) getgenv().Settings.AutoCosmetic = v end})
other:AddToggle({Name = "Tự bật V3", Default = false, Callback = function(v) getgenv().Settings.AutoV3 = v end})
other:AddToggle({Name = "Tự bật V4", Default = false, Callback = function(v) getgenv().Settings.AutoV4 = v end})

-- Kỹ năng SEA EVENT
for _, skill in pairs({"Z", "X", "C", "V", "F"}) do
    other:AddToggle({
        Name = "Dùng chiêu " .. skill .. " trong Sea Event",
        Default = true,
        Callback = function(v)
            getgenv().Settings.Skills[skill] = v
        end
    })
end

-- END UI SCRIPT - Các chức năng nâng cao sẽ tiếp tục được bổ sung!
