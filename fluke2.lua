-- 💠 บริการหลัก
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 💠 ตัวแปร Remote และ Wave
local cw = ReplicatedStorage:WaitForChild("Values"):WaitForChild("Waves"):WaitForChild("CurrentWave")
local remoteRestart = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("RestartMatch")
local voteRetryRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry")
local adventureModeEndRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("AdventureModeEnd")

-- 💠 สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRestartUI"
screenGui.Parent = playerGui
screenGui.DisplayOrder = 9999
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- 💠 สร้าง Frame UI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 600)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)

-- 💠 ชื่อ UI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ผู้สร้าง แบงค์ควย49"
title.TextColor3 = textColor
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 15
title.Parent = frame

-- 💠 ปุ่มพับ UI
local minimized = false
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -90, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.TextColor3 = textColor
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 24
minimizeButton.ZIndex = 20
minimizeButton.Parent = frame

-- 💠 ปุ่มปิด UI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = textColor
closeButton.Text = "✖"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 24
closeButton.ZIndex = 20
closeButton.Parent = frame

-- 💠 ปุ่มเปิด UI
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 100, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.BackgroundColor3 = accentColor
openButton.TextColor3 = textColor
openButton.Text = "Open UI"
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 22
openButton.Visible = false
openButton.ZIndex = 50
openButton.Parent = playerGui

-- 💠 ปุ่มพับ UI
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 600)
    for _, child in pairs(frame:GetChildren()) do
        if child ~= minimizeButton and child ~= closeButton and child ~= title then
            child.Visible = not minimized
        end
    end
    minimizeButton.Text = minimized and "+" or "-"
end)

-- 💠 ปิด UI
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    openButton.Visible = true
end)

-- 💠 เปิด UI
openButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = true
    openButton.Visible = false
end)

-- 💠 แจ้งเตือนแบบ Pop-Up
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
        })
    end)
end

-- 💠 สร้าง Toggle Button
local function createToggle(text, posY, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -40, 0, 40)
    toggleFrame.Position = UDim2.new(0, 20, 0, posY)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 30)
    button.Position = UDim2.new(0.75, 0, 0.15, 0)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = textColor
    button.Text = "Off"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = toggleFrame

    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.Text = enabled and "On" or "Off"
        button.BackgroundColor3 = enabled and accentColor or Color3.fromRGB(80, 80, 80)
        callback(enabled)
    end)
end

-- ✅ ตัวแปรสถานะ
local bugEventEnabled, autoRetryEnabled, adventureModeEndEnabled = false, false, false

-- ✅ Toggle: Bug Event
createToggle("Bug Borus  กดปุ่ม off เพื่อโดนเย็ดตูด", 60, function(state)
    bugEventEnabled = state
    notify("Bug Event", state and "Enabled" or "Disabled")
    if state then
        task.spawn(function()
            while bugEventEnabled do
                if cw.Value == 2 then
                    remoteRestart:FireServer()
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- ✅ Toggle: Auto Retry
createToggle("Auto Retry กดปุ่ม off เพื่อเย็ดหี", 110, function(state)
    autoRetryEnabled = state
    notify("Auto Retry", state and "Enabled" or "Disabled")
    if state then
        task.spawn(function()
            while autoRetryEnabled do
                if playerGui:FindFirstChild("GameEndedAnimationUI") then
                    voteRetryRemote:FireServer()
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- ✅ Toggle: Adventure End
createToggle("ด่านใหม่ล่าสุดเย็ดหี", 160, function(state)
    adventureModeEndEnabled = state
    notify("Adventure End", state and "Enabled" or "Disabled")
    if state then
        task.spawn(function()
            while adventureModeEndEnabled do
                adventureModeEndRemote:FireServer(false)
                task.wait(2)
            end
        end)
    end
end)

-- ✅ แสดงสถานะ Wave
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 210)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = textColor
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 20
statusLabel.Text = "Current Wave: 0"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

task.spawn(function()
    while true do
        statusLabel.Text = "Current Wave: " .. tostring(cw.Value)
        task.wait(1)
    end
end)

-- 💠 ฟังก์ชันสร้าง Stat Label พร้อม Icon
local function createStatLabelWithIcon(statName, offsetY, iconImage)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 40)
    container.Position = UDim2.new(0, 20, 0, offsetY)
    container.BackgroundTransparency = 1
    container.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 0, 0, 5)
    icon.BackgroundTransparency = 1
    icon.Image = iconImage
    icon.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = textColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = statName .. ": Loading..."
    label.Parent = container

    task.spawn(function()
        local leaderstats = player:WaitForChild("leaderstats", 10)
        if leaderstats then
            local stat = leaderstats:FindFirstChild(statName)
            if stat then
                while true do
                    label.Text = stat.Name .. ": " .. tostring(stat.Value)
                    stat:GetPropertyChangedSignal("Value"):Wait()
                end
            else
                label.Text = statName .. ": Not found"
            end
        else
            label.Text = "leaderstats missing"
        end
    end)
end

-- 💠 ใส่ไอคอน (เปลี่ยนเป็น Asset ID หรือ URL ของคุณ)
local icons = {
    Coins = "rbxassetid://6031094662",  -- ตัวอย่างไอคอน Coins
    Gems = "rbxassetid://6031094683",   -- ตัวอย่างไอคอน Gems
    XP = "rbxassetid://6031094698",     -- ตัวอย่างไอคอน XP
    Level = "rbxassetid://6031094714",  -- ตัวอย่างไอคอน Level
    Power = "rbxassetid://6031094726",  -- ตัวอย่างไอคอน Power
}

-- 💠 สร้าง Stat Labels พร้อม Icon
createStatLabelWithIcon("Coins", 250, icons.Coins)
createStatLabelWithIcon("Gems", 290, icons.Gems)
createStatLabelWithIcon("XP", 330, icons.XP)
createStatLabelWithIcon("Level", 370, icons.Level)
createStatLabelWithIcon("Power", 410, icons.Power)

