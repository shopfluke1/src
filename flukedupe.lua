local HttpService = game:GetService("HttpService")
local initialized = false
local sessionid = ""
Name = "shopfluke1"
Ownerid = "tCIhaEdkcI"
APPVersion = "1.0"

local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

local req = game:HttpGet('https://keyauth.win/api/1.3/?name=' .. Name .. '&ownerid=' .. Ownerid .. '&type=init&ver=' .. APPVersion)

if req == "KeyAuth_Invalid" then 
   print("Error", "Application not found.", 5)
   return false
end

local data = HttpService:JSONDecode(req)

if data.success == true then
   initialized = true
   sessionid = data.sessionid
elseif (data.message == "invalidver") then
   print("Error", "Wrong application version..", 5)
   return false
else
   print("Error", data.message, 5)
   return false
end

if license == nil or license == "" then
    print("Info", "Please Enter License Key", 5)
    return false
end

print("Warning", "Key Licensing...", 3)
local req = game:HttpGet('https://keyauth.win/api/1.3/?name=' .. Name .. '&ownerid=' .. Ownerid .. '&type=license&key=' .. license ..'&ver=' .. APPVersion .. '&hwid=' .. hwid .. '&sessionid=' .. sessionid)
local data = HttpService:JSONDecode(req)
task.wait(2)
if data.success == false then 
    print("Error", data.message, 5)
    return false
end
print("Success", "Successfully Authorized", 5)
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
local main = serv:Channel("ฟังก์ชันหลัก")

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
local dropdown = main:Dropdown("🎯 เลือกเป้าหมาย", GetPlayers(), function(value)
    selectedTarget = value
end)

main:Button("🔄 Refresh Players", function()
    dropdown:Refresh(GetPlayers())
    DiscordLib:Notification("อัปเดตแล้ว!", "รีเฟรชรายชื่อผู้เล่นเรียบร้อย", "🧾")
end)

----------------------------------------------------------
-- 🍈 ฟังก์ชัน Dupe Durian (เดิม)
----------------------------------------------------------
local function DupeDurian()
    if not selectedTarget then
        DiscordLib:Notification("❌ Error", "กรุณาเลือกผู้เล่นก่อน", "ตกลง")
        return
    end

    local NAMEFRUITS = "Durian"
    local NANMEPLR = selectedTarget

    -- ตั้งค่า QuickSell
    RS:WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("SetEggQuickSell", {
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

    -- รอ GUI โหลด
    repeat task.wait(0.1) until LocalPlayer.PlayerGui and LocalPlayer.PlayerGui:FindFirstChild("Data") and LocalPlayer.PlayerGui.Data:FindFirstChild("Asset")

    -- วนส่งจนหมด
    repeat
        task.wait()
        local targetPlayer = Players:FindFirstChild(NANMEPLR)
        if targetPlayer then
            pcall(function()
                RS:WaitForChild("Remote"):WaitForChild("GiftRE"):FireServer(targetPlayer)
            end)
        end
        if not LocalPlayer.PlayerGui or not LocalPlayer.PlayerGui.Data or not LocalPlayer.PlayerGui.Data.Asset then
            break
        end
    until not LocalPlayer.PlayerGui.Data.Asset:GetAttribute(NAMEFRUITS)
          or LocalPlayer.PlayerGui.Data.Asset:GetAttribute(NAMEFRUITS) <= 0

    DiscordLib:Notification("🍈 Dupe Durian", "Dupe Durian เสร็จเรียบร้อยแล้ว! จะทำการเตะออก", "ตกลง")

    -- เตะออก
    pcall(function()
        TPService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end)
end

main:Button("🍈 Dupe Durian (ส่งแล้วเตะ)", function()
    DiscordLib:Notification("DupeDurian", "เริ่ม Dupe Durian...", "ตกลง")
    DupeDurian()
end)

----------------------------------------------------------
-- 🥚 ฟังก์ชันส่งไข่ทั้งหมด + Kick (เดิม)
----------------------------------------------------------
local function GiftAllEggsKick()
    if not selectedTarget then
        DiscordLib:Notification("❌ Error", "กรุณาเลือกผู้เล่นก่อน", "ตกลง")
        return
    end

    local NANMEPLR = selectedTarget
    local P = Players
    local LP = LocalPlayer

    -- ตั้งค่า QuickSell
    RS.Remote.FishingRE:FireServer("SetEggQuickSell", {
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

    task.wait(3)

    -- Teleport ไปหาผู้เล่นเป้าหมาย
    local targetPlayer = P:FindFirstChild(NANMEPLR)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        task.wait(1)
    end

    -- ส่งไข่ทั้งหมด
    local AE = LP.PlayerGui.Data.Egg:GetChildren()
    for i, v in pairs(AE) do
        RS.Remote.CharacterRE:FireServer("Focus", v.Name)
        task.wait(0.1)
        RS.Remote.GiftRE:FireServer(targetPlayer)
        task.wait(0.3)
        print(i.."/"..#AE.." ส่งไข่: "..v.Name)
    end

    DiscordLib:Notification("🥚 ส่งไข่", "ส่งไข่ทั้งหมดเรียบร้อยแล้ว! กำลังเตะออก...", "ตกลง")

    task.wait(3)
    -- เตะออก
    TPService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end

main:Button("🥚 ส่งไข่ทั้งหมด (Kick)", function()
    DiscordLib:Notification("ส่งไข่", "เริ่มส่งไข่ไปยัง "..(selectedTarget or "ผู้เล่นเป้าหมาย").."...", "ตกลง")
    GiftAllEggsKick()
end)

----------------------------------------------------------
-- ⚙️ ฟังก์ชัน Dupe (QuickSell)
----------------------------------------------------------
local function DupeQuickSell()
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
    DiscordLib:Notification("⚙️ Dupe", "ตั้งค่า QuickSell เรียบร้อยแล้ว", "✅")
end

main:Button("⚙️ Dupe", DupeQuickSell)

----------------------------------------------------------
-- 🔁 ฟังก์ชัน Rejoin
----------------------------------------------------------
local function Rejoin()
    DiscordLib:Notification("🔄 Rejoin", "กำลังกลับเข้ามาในเซิร์ฟเวอร์...", "⏳")
    task.wait(1)
    TPService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

main:Button("🔁 Rejoin", Rejoin)
