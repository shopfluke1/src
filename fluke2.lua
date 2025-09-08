local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local cw = ReplicatedStorage.Values.Waves.CurrentWave
local remoteRestart = ReplicatedStorage.Remote.Server.OnGame.RestartMatch
local voteRetryRemote = ReplicatedStorage.Remote.Server.OnGame.Voting.VoteRetry

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRestartUI"
screenGui.Parent = playerGui

-- สร้าง Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 400)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- ฟอนต์และสี
local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)

-- ชื่อหัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Auto Restart Control"
title.TextColor3 = textColor
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = frame

-- ฟังก์ชันสร้าง Toggle Button
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

-- ฟังก์ชันสร้าง Input Box สำหรับ Delay
local function createInput(text, posY, callback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -40, 0, 40)
    inputFrame.Position = UDim2.new(0, 20, 0, posY)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = inputFrame

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0.3, 0, 0.7, 0)
    textbox.Position = UDim2.new(0.65, 0, 0.15, 0)
    textbox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    textbox.TextColor3 = textColor
    textbox.Font = Enum.Font.SourceSans
    textbox.TextSize = 18
    textbox.Text = "2"
    textbox.ClearTextOnFocus = false
    textbox.Parent = inputFrame

    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local num = tonumber(textbox.Text)
            if num and num > 0 then
                callback(num)
            else
                textbox.Text = "Invalid!"
                wait(1)
                textbox.Text = tostring(num or "")
            end
        end
    end)
end

-- ฟังก์ชันสร้างปุ่ม
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

-- ตัวแปรสถานะและ delay
local bugEventEnabled = false
local autoRetryEnabled = false

local restartDelay = 2
local retryDelay = 1

-- Toggle Bug Event
createToggle("Bug Event (Restart Wave 2)", 60, function(state)
    bugEventEnabled = state
    if state then
        notify("Bug Event", "Auto restart enabled")
        task.spawn(function()
            while bugEventEnabled do
                if cw.Value == 2 then
                    print("Wave 2/2 detected! Restarting match...")
                    remoteRestart:FireServer()
                    task.wait(restartDelay)
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
                    task.wait(retryDelay)
                end
                task.wait(0.5)
            end
        end)
    else
        notify("Auto Retry", "Disabled")
    end
end)

-- Input Delay Restart
createInput("Restart Delay (seconds):", 160, function(num)
    restartDelay = num
    print("Restart delay set to", restartDelay)
end)

-- Input Delay Retry
createInput("Retry Delay (seconds):", 210, function(num)
    retryDelay = num
    print("Retry delay set to", retryDelay)
end)

-- ปุ่ม Restart Now
createButton("Restart Now", 260, function()
    print("Restart Now button pressed")
    remoteRestart:FireServer()
end)

-- ปุ่ม Vote Retry Now
createButton("Vote Retry Now", 310, function()
    print("Vote Retry Now button pressed")
    voteRetryRemote:FireServer()
end)

-- ฟังก์ชันแจ้งเตือน Pop-up
function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
        })
    end)
end

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
