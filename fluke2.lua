-- 💠 Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 💠 Remote & Wave
local cw = ReplicatedStorage:WaitForChild("Values"):WaitForChild("Waves"):WaitForChild("CurrentWave")
local remoteRestart = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("RestartMatch")
local voteRetryRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry")
local adventureModeEndRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("AdventureModeEnd")

-- 💠 Colors
local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)

-- 💠 ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRestartUI"
screenGui.Parent = playerGui
screenGui.DisplayOrder = 9999
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- 💠 Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 750)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

-- 💠 Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Restart System"
title.TextColor3 = textColor
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 15
title.Parent = frame

-- 💠 Minimize & Close
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
    frame.Size = minimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 750)
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

-- 💠 Notify
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
        })
    end)
end

-- 💠 Toggle Function
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

-- 💠 Wave Checkbox
local restartWaveTarget = 1
local baseY = 60
local waveFrame = Instance.new("Frame", frame)
waveFrame.Size = UDim2.new(1, -40, 0, 150)
waveFrame.Position = UDim2.new(0, 20, 0, baseY)
waveFrame.BackgroundTransparency = 1

local waveTitle = Instance.new("TextLabel", waveFrame)
waveTitle.Size = UDim2.new(1, 0, 0, 30)
waveTitle.Position = UDim2.new(0, 0, 0, 0)
waveTitle.BackgroundTransparency = 1
waveTitle.Text = "เลือก Wave สำหรับ Restart"
waveTitle.TextColor3 = textColor
waveTitle.Font = Enum.Font.SourceSansBold
waveTitle.TextSize = 20
waveTitle.TextXAlignment = Enum.TextXAlignment.Left

local waveY = 40
local waveButtons = {}
for i=1,5 do
    local cb = Instance.new("TextButton", waveFrame)
    cb.Size = UDim2.new(0, 60, 0, 30)
    cb.Position = UDim2.new(0, (i-1)*65, 0, waveY)
    cb.BackgroundColor3 = Color3.fromRGB(60,60,60)
    cb.TextColor3 = textColor
    cb.Text = "Wave "..i
    cb.Font = Enum.Font.SourceSansBold
    cb.TextSize = 16

    cb.MouseButton1Click:Connect(function()
        restartWaveTarget = i
        for j, btn in ipairs(waveButtons) do
            btn.BackgroundColor3 = (j==i) and accentColor or Color3.fromRGB(60,60,60)
        end
        notify("Restart Wave", "ตั้งค่าเป็น Wave "..i)
    end)
    table.insert(waveButtons, cb)
end

-- 💠 Toggles เริ่มต่ำกว่า Wave Checkbox
local toggleStartY = baseY + 160

-- ✅ Auto Retry บนสุด
createToggle("Auto Retry", toggleStartY, function(state)
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

-- ✅ Bug Event ข้างล่าง
createToggle("Bug Event Auto Restart", toggleStartY + 60, function(state)
    bugEventEnabled = state
    notify("Bug Event", state and "Enabled" or "Disabled")
    if state then
        task.spawn(function()
            while bugEventEnabled do
                if cw.Value == restartWaveTarget then
                    remoteRestart:FireServer()
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- ✅ Adventure End ข้างล่าง
createToggle("Adventure End", toggleStartY + 120, function(state)
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

-- 💠 Current Wave Display
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, toggleStartY + 220)
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
