-- 💠 Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 💠 Auto Detect CurrentWave
local cw
pcall(function()
    if ReplicatedStorage:FindFirstChild("Values") and ReplicatedStorage.Values:FindFirstChild("Waves") then
        cw = ReplicatedStorage.Values.Waves:FindFirstChild("CurrentWave")
    elseif ReplicatedStorage:FindFirstChild("GameStats") then
        cw = ReplicatedStorage.GameStats:FindFirstChild("CurrentWave")
    elseif workspace:FindFirstChild("_wave") then
        cw = workspace:FindFirstChild("_wave")
    end
end)

if not cw then
    warn("[AutoRestartUI] ❌ CurrentWave ไม่เจอ")
end

-- 💠 Auto Detect Remote Restart
local remoteRestart
pcall(function()
    if ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("Server") then
        remoteRestart = ReplicatedStorage.Remote.Server.OnGame:FindFirstChild("RestartMatch")
    elseif ReplicatedStorage:FindFirstChild("Endpoints") then
        remoteRestart = ReplicatedStorage.Endpoints.ClientToServer:FindFirstChild("Restart")
    end
end)

if not remoteRestart then
    warn("[AutoRestartUI] ❌ Remote Restart ไม่เจอ")
end

-- 💠 Remote อื่น ๆ
local voteRetryRemote = ReplicatedStorage:FindFirstChild("Remote")
    and ReplicatedStorage.Remote.Server.OnGame.Voting:FindFirstChild("VoteRetry")

local adventureModeEndRemote = ReplicatedStorage:FindFirstChild("Remote")
    and ReplicatedStorage.Remote:FindFirstChild("AdventureModeEnd")

-- 💠 UI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRestartUI"
screenGui.Parent = playerGui
screenGui.DisplayOrder = 9999
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

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

-- 💠 Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Auto Restart UI"
title.TextColor3 = textColor
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 15
title.Parent = frame

-- 💠 ปุ่มย่อ/ปิด UI
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

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = true
    openButton.Visible = false
end)

-- 💠 Notify ฟังก์ชัน
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
        })
    end)
end

-- 💠 ฟังก์ชันสร้าง Toggle
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

-- ✅ เลือก Wave ที่จะ Restart
local restartWaveTarget = 1
local waveSelectFrame = Instance.new("Frame")
waveSelectFrame.Size = UDim2.new(1, -40, 0, 40)
waveSelectFrame.Position = UDim2.new(0, 20, 0, 60)
waveSelectFrame.BackgroundTransparency = 1
waveSelectFrame.Parent = frame

local waveLabel = Instance.new("TextLabel")
waveLabel.Size = UDim2.new(0.7, 0, 1, 0)
waveLabel.BackgroundTransparency = 1
waveLabel.Text = "เลือก Wave สำหรับ Restart"
waveLabel.TextColor3 = textColor
waveLabel.Font = Enum.Font.SourceSans
waveLabel.TextSize = 20
waveLabel.TextXAlignment = Enum.TextXAlignment.Left
waveLabel.Parent = waveSelectFrame

local wave1Btn = Instance.new("TextButton")
wave1Btn.Size = UDim2.new(0, 60, 0, 30)
wave1Btn.Position = UDim2.new(0.7, 0, 0.15, 0)
wave1Btn.BackgroundColor3 = accentColor
wave1Btn.TextColor3 = textColor
wave1Btn.Text = "Wave 1"
wave1Btn.Font = Enum.Font.SourceSansBold
wave1Btn.TextSize = 18
wave1Btn.Parent = waveSelectFrame

local wave2Btn = Instance.new("TextButton")
wave2Btn.Size = UDim2.new(0, 60, 0, 30)
wave2Btn.Position = UDim2.new(0.9, 0, 0.15, 0)
wave2Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
wave2Btn.TextColor3 = textColor
wave2Btn.Text = "Wave 2"
wave2Btn.Font = Enum.Font.SourceSansBold
wave2Btn.TextSize = 18
wave2Btn.Parent = waveSelectFrame

local function updateWaveSelection(wave)
    restartWaveTarget = wave
    if wave == 1 then
        wave1Btn.BackgroundColor3 = accentColor
        wave2Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    else
        wave1Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        wave2Btn.BackgroundColor3 = accentColor
    end
    notify("Restart Wave", "ตั้งค่าเป็น Wave " .. tostring(wave))
end

wave1Btn.MouseButton1Click:Connect(function() updateWaveSelection(1) end)
wave2Btn.MouseButton1Click:Connect(function() updateWaveSelection(2) end)

-- ✅ Toggles
local bugEventEnabled, autoRetryEnabled, adventureModeEndEnabled = false, false, false

createToggle("Bug Event (Restart)", 110, function(state)
    bugEventEnabled = state
    notify("Bug Event", state and "Enabled" or "Disabled")
    if state then
        task.spawn(function()
            while bugEventEnabled do
                if cw and cw.Value == restartWaveTarget and remoteRestart then
                    remoteRestart:FireServer()
                end
                task.wait(0.5)
            end
        end)
    end
end)

createToggle("Auto Retry", 160, function(state)
    autoRetryEnabled = state
    notify("Auto Retry", state and "Enabled" or "Disabled")
    if state then
        task.spawn(function()
            while autoRetryEnabled do
                if playerGui:FindFirstChild("GameEndedAnimationUI") and voteRetryRemote then
                    voteRetryRemote:FireServer()
                end
                task.wait(0.5)
            end
        end)
    end
end)

createToggle("Adventure End", 210, function(state)
    adventureModeEndEnabled = state
    notify("Adventure End", state and "Enabled" or "Disabled")
    if state then
        task.spawn(function()
            while adventureModeEndEnabled do
                if adventureModeEndRemote then
                    adventureModeEndRemote:FireServer(false)
                end
                task.wait(2)
            end
        end)
    end
end)

-- ✅ แสดง Wave ปัจจุบัน
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 260)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = textColor
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 20
statusLabel.Text = "Current Wave: 0"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

task.spawn(function()
    while true do
        if cw then
            statusLabel.Text = "Current Wave: " .. tostring(cw.Value)
        else
            statusLabel.Text = "Current Wave: N/A"
        end
        task.wait(1)
    end
end)
