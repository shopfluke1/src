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

-- 💠 Colors
local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)
local activeColor = Color3.fromRGB(0, 255, 0)
local inactiveColor = Color3.fromRGB(60, 60, 60)

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
frame.Size = UDim2.new(0, 350, 0, 350)
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
    frame.Size = minimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 350)
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

-- 💠 Auto Retry Toggle
local autoRetryEnabled = false
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

    button.MouseButton1Click:Connect(function()
        autoRetryEnabled = not autoRetryEnabled
        button.Text = autoRetryEnabled and "On" or "Off"
        button.BackgroundColor3 = autoRetryEnabled and accentColor or Color3.fromRGB(80,80,80)
        callback(autoRetryEnabled)
    end)
end

createToggle("Auto Retry", 60, function(state)
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

-- 💠 Wave Checkbox
local selectedWaves = {}
local waveButtons = {}

local waveFrame = Instance.new("Frame", frame)
waveFrame.Size = UDim2.new(1, -40, 0, 80)
waveFrame.Position = UDim2.new(0, 20, 0, 120)
waveFrame.BackgroundTransparency = 1

local waveTitle = Instance.new("TextLabel", waveFrame)
waveTitle.Size = UDim2.new(1, 0, 0, 30)
waveTitle.Position = UDim2.new(0, 0, 0, 0)
waveTitle.BackgroundTransparency = 1
waveTitle.Text = "เลือก Wave สำหรับ Restart"
waveTitle.TextColor3 = textColor
waveTitle.Font = Enum.Font.SourceSansBold
waveTitle.TextSize = 18
waveTitle.TextXAlignment = Enum.TextXAlignment.Left

local waveY = 40
for i = 1, 5 do
    selectedWaves[i] = false
    local cb = Instance.new("TextButton", waveFrame)
    cb.Size = UDim2.new(0, 60, 0, 30)
    cb.Position = UDim2.new(0, (i-1)*65, 0, waveY)
    cb.BackgroundColor3 = inactiveColor
    cb.TextColor3 = textColor
    cb.Text = "Wave "..i
    cb.Font = Enum.Font.SourceSansBold
    cb.TextSize = 16

    cb.MouseButton1Click:Connect(function()
        selectedWaves[i] = not selectedWaves[i]
        cb.BackgroundColor3 = selectedWaves[i] and accentColor or inactiveColor
        notify("Wave "..i, selectedWaves[i] and "เปิดแล้ว" or "ปิดแล้ว")
    end)

    waveButtons[i] = cb
end

-- 💠 Current Wave Display
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 250)
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

-- 💠 Auto Restart Task with Highlight
task.spawn(function()
    while true do
        for wave, isEnabled in ipairs(selectedWaves) do
            local cb = waveButtons[wave]
            if isEnabled and cw.Value == wave and autoRetryEnabled then
                remoteRestart:FireServer()
                cb.BackgroundColor3 = activeColor
            elseif selectedWaves[wave] then
                cb.BackgroundColor3 = accentColor
            else
                cb.BackgroundColor3 = inactiveColor
            end
        end
        task.wait(0.1)
    end
end)
