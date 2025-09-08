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
screenGui.ResetOnSpawn = false  -- ให้ UI อยู่ต่อแม้ Respawn

-- สร้าง Frame (ขนาดพอดี)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 520)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ZIndex = 999 -- ให้ UI อยู่บนสุด

local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)

-- ชื่อหัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Auto Restart Control"
title.TextColor3 = textColor
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 10, 0, 0)
title.Parent = frame

-- ปุ่มพับ/ขยาย UI
local minimized = false

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 1, 0)
minimizeButton.Position = UDim2.new(1, -40, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 24
minimizeButton.Parent = frame

minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        -- ขยายกลับ
        frame.Size = UDim2.new(0, 350, 0, 520)
        for _, child in pairs(frame:GetChildren()) do
            if child ~= minimizeButton and child ~= title then
                child.Visible = true
            end
        end
        minimizeButton.Text = "-"
        minimized = false
    else
        -- พับ UI เหลือแค่หัวข้อ
        frame.Size = UDim2.new(0, 350, 0, 40)
        for _, child in pairs(frame:GetChildren()) do
            if child ~= minimizeButton and child ~= title then
                child.Visible = false
            end
        end
        minimizeButton.Text = "+"
        minimized = true
    end
end)

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

-- ตัวแปรสถานะ
local bugEventEnabled = false
local autoRetryEnabled = false
local adventureModeEndEnabled = false

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
                    task.wait(2)
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
                    task.wait(1)
                end
                task.wait(0.5)
            end
        end)
    else
        notify("Auto Retry", "Disabled")
    end
end)

-- Toggle Adventure End Trigger
createToggle("Adventure End Trigger", 160, function(state)
    adventureModeEndEnabled = state
    if state then
        notify("Adventure End Trigger", "Enabled")
        task.spawn(function()
            while adventureModeEndEnabled do
                print("Triggering AdventureModeEnd with false")
                adventureModeEndRemote:FireServer(false)
                task.wait(2)
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
statusLabel.Position = UDim2.new(0, 20, 0, 370)
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
        task.wait(1) -- อัปเดตช้าๆ ป้องกัน UI สั่น
    end
end)

-- ให้ UI ขยับได้ (Draggable)
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
