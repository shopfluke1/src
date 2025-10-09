-- 📦 ตัวแปรหลัก
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TPService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

-- 🪄 โหลด UI Library
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/pndxvo/scr/main/ui.lua"))()
local win = DiscordLib:Window("🐷 Build a Zoo | FlukeDupe")

-- 🧭 สร้าง Server และ Channel
local serv = win:Server("Main", "")
local tgls = serv:Channel("ฟังก์ชันหลัก")

-- 🧩 ตัวแปรผู้เล่นเป้าหมาย
local selectedTarget = nil

-- 📜 อัปเดตรายชื่อผู้เล่น
local function GetPlayers()
    local plrs = {}
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(plrs, v.Name)
        end
    end
    return plrs
end

-- 🧭 เมนูเลือกผู้เล่น
local dropdown = tgls:Dropdown("🎯 เลือกเป้าหมาย", GetPlayers(), function(value)
    selectedTarget = value
end)

tgls:Button("🔄 Refresh Players", function()
    dropdown:Refresh(GetPlayers())
    DiscordLib:Notification("อัปเดตแล้ว!", "รีเฟรชรายชื่อผู้เล่นเรียบร้อย", "🧾")
end)

------------------------------------------------------------
-- 🧩 ฟังก์ชัน Dupe() ใช้แทน FireServer("SetEggQuickSell")
------------------------------------------------------------
function Dupe()
    local FishingRE = RS:WaitForChild("Remote"):WaitForChild("FishingRE")
    FishingRE:FireServer("SetEggQuickSell", {
        ["1"] = "\255",
        Diamond = false,
        ["3"] = true,
        ["2"] = false,
        ["5"] = false,
        ["4"] = false,
        ["6"] = false,
        Golden = false,
        Electirc = false,
        Fire = false,
        Dino = false,
        Snow = false
    })
end

------------------------------------------------------------
-- 🧩 ฟังก์ชันที่ 1: ส่งผลไม้ Durian (Dupe ผลไม้)
------------------------------------------------------------
function DupeFruit()
    if not selectedTarget then
        DiscordLib:Notification("⛔ ไม่มีเป้าหมาย", "กรุณาเลือกผู้เล่นก่อน", "❌")
        return
    end

    Dupe() -- เรียกใช้แทน FireServer("SetEggQuickSell")

    local fruit = "Durian"
    local petFolder = LocalPlayer.PlayerGui:WaitForChild("Data"):WaitForChild("Pets")
    local remote = RS:WaitForChild("Remote"):WaitForChild("CharacterRE")

    for _, pet in pairs(petFolder:GetChildren()) do
        if pet:GetAttribute("T") == fruit then
            local uid = pet.Name
            remote:FireServer("Focus", { target = selectedTarget })
            task.wait(0.2)
            remote:FireServer("Gift", { target = selectedTarget, pet = uid })
        end
    end

    task.wait(1)
    TPService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

------------------------------------------------------------
-- 🧩 ฟังก์ชันที่ 2: ส่งไข่ทั้งหมด (Kick)
------------------------------------------------------------
function GiftAllEggsKick()
    if not selectedTarget then
        DiscordLib:Notification("⛔ ไม่มีเป้าหมาย", "กรุณาเลือกผู้เล่นก่อน", "❌")
        return
    end

    Dupe() -- เรียกใช้แทน FireServer("SetEggQuickSell")

    local remote = RS:WaitForChild("Remote"):WaitForChild("CharacterRE")
    local eggFolder = LocalPlayer.PlayerGui.Data:WaitForChild("Egg")

    for _, egg in pairs(eggFolder:GetChildren()) do
        local eggName = egg.Name
        remote:FireServer("Focus", { target = selectedTarget })
        task.wait(0.25)
        remote:FireServer("Gift", { target = selectedTarget, pet = eggName })
    end

    task.wait(1)
    TPService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

------------------------------------------------------------
-- 🧩 ฟังก์ชันที่ 3: Dupe Egg (QuickSell)
------------------------------------------------------------
function DupeEgg()
    Dupe() -- เรียกใช้แทน FireServer("SetEggQuickSell")
    DiscordLib:Notification("🐣 สำเร็จ", "ตั้งค่า Dupe สำหรับระบบ Dupe แล้ว", "✅")
end

------------------------------------------------------------
-- 🧩 ฟังก์ชัน Rejoin
------------------------------------------------------------
function Rejoin()
    DiscordLib:Notification("🔄 กำลัง Rejoin", "ระบบกำลังพาคุณกลับเข้ามาในเซิร์ฟเวอร์...", "⏳")
    task.wait(0.1)
    TPService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

------------------------------------------------------------
-- 🧠 ปุ่มใน UI
------------------------------------------------------------
tgls:Button("🍈 ส่งผลไม้ Durian (Dupe)", DupeFruit)
tgls:Button("🥚 ส่งไข่ทั้งหมด (Kick)", GiftAllEggsKick)
tgls:Button("⚙️ Dupe", DupeEgg)
tgls:Button("🔁 Rejoin", Rejoin)
