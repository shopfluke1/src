-- บริการหลัก
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ตัวแปร Remote และ Wave
local cw = ReplicatedStorage:WaitForChild("Values"):WaitForChild("Waves"):WaitForChild("CurrentWave")
local remoteRestart = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("RestartMatch")
local voteRetryRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry")
local adventureModeEndRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("AdventureModeEnd")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRestartUI"
screenGui.Parent = playerGui
screenGui.DisplayOrder = 9999
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- สร้าง Frame (ขนาดพอดี)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 470)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)

-- ชื่อหัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "NAHEEYESHEE"
title.TextColor3 = textColor
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = frame

-- ฟังก์ชันสร้าง Toggle
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

-- ฟังก์ชันสร้างปุ่มกด
local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = accentColor
    btn.TextColor3 = textColor
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 22
    btn.Text = text
    btn.Parent = frame

    btn.MouseButton1Click:Connect(callback)
end

-- ฟังก์ชันแจ้งเตือน (Notification)
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
        })
    end)
end

-- สถานะ toggle
local bugEventEnabled = false
local autoRetryEnabled = false
local adventureModeEndEnabled = false

-- Toggle Bug Event
createToggle("Bug Borus (Restart Wave 2)", 60, function(state)
    bugEventEnabled = state
    if state then
        notify("Bug Event", "Auto restart enabled")
        task.spawn(function()
            while bugEventEnabled do
                if cw.Value == 2 then
                    print("Wave 2/2 detected! Restarting match...")
                    remoteRestart:FireServer()
                end
                task.wait(0.5)
            end
        end)
    else
        notify("Bug Event", "Auto restart disabled")
    end
end)

-- Toggle Auto Retry
createToggle("Auto Retry (Vote Retry)", 110, function(state)
    autoRetryEnabled = state
    if state then
        notify("Auto Retry", "Enabled")
        task.spawn(function()
            while autoRetryEnabled do
                if playerGui:FindFirstChild("GameEndedAnimationUI") then
                    print("Game ended detected! Sending VoteRetry...")
                    voteRetryRemote:FireServer()
                end
                task.wait(0.1)
            end
        end)
    else
        notify("Auto Retry", "Disabled")
    end
end)

-- Toggle Adventure End Trigger
createToggle("Adventure End 10 WAVE", 160, function(state)
    adventureModeEndEnabled = state
    if state then
        notify("Adventure End Trigger", "Enabled")
        task.spawn(function()
            while adventureModeEndEnabled do
                print("Triggering AdventureModeEnd with false")
                adventureModeEndRemote:FireServer(false)
                task.wait(2) -- ป้องกัน spam เร็วเกินไป
            end
        end)
    else
        notify("Adventure End Trigger", "Disabled")
    end
end)

-- ปุ่ม Restart Now
createButton("Restart Now", 210, function()
    print("Restart Now button pressed")
    remoteRestart:FireServer()
    notify("Manual Action", "Restart triggered")
end)

-- ปุ่ม Vote Retry Now
createButton("Vote Retry Now", 260, function()
    print("Vote Retry Now button pressed")
    voteRetryRemote:FireServer()
    notify("Manual Action", "Vote Retry triggered")
end)

-- ปุ่ม Adventure End Trigger Now
createButton("Adventure End Trigger Now", 310, function()
    print("Adventure End Trigger Now button pressed")
    adventureModeEndRemote:FireServer(false)
    notify("Manual Action", "Adventure End triggered")
end)

-- อัพเดตสถานะแมตช์แบบ Real-Time
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 360)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = textColor
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 20
statusLabel.Text = "Current Wave: 0"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

task.spawn(function()
    while true do
        statusLabel.Text = "Current Wave: "..tostring(cw.Value)
        task.wait(1)
    end
end)

