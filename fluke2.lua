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
screenGui.ResetOnSpawn = false

-- สร้าง Frame หลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 520)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ZIndex = 999

local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)

-- ชื่อหัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 40)
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
minimizeButton.Position = UDim2.new(1, -80, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.TextColor3 = textColor
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 24
minimizeButton.Parent = frame

-- ปุ่มกากบาท ปิด UI (ซ่อน)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 1, 0)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = textColor
closeButton.Text = "✖"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 24
closeButton.Parent = frame

minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        -- ขยายกลับ
        frame.Size = UDim2.new(0, 350, 0, 520)
        for _, child in pairs(frame:GetChildren()) do
            if child ~= minimizeButton and child ~= closeButton and child ~= title then
                child.Visible = true
            end
        end
        minimizeButton.Text = "-"
        minimized = false
    else
        -- พับ UI เหลือแค่หัวข้อและปุ่ม
        frame.Size = UDim2.new(0, 350, 0, 40)
        for _, child in pairs(frame:GetChildren()) do
            if child ~= minimizeButton and child ~= closeButton and child ~= title then
                child.Visible = false
            end
        end
        minimizeButton.Text = "+"
        minimized = true
    end
end)

closeButton.MouseButton1Click:Connect(function()
    -- ซ่อน UI ทั้งหมด (ยังอยู่ใน PlayerGui)
    screenGui.Enabled = false
    -- หรือจะใช้: frame.Visible = false ก็ได้ แต่แบบนี้ง่ายกว่าถ้าต้องการเปิดกลับ
end)

-- คุณอาจเพิ่มปุ่มเปิด UI กลับได้ (optional)
-- ตัวอย่างเพิ่มปุ่มเปิด UI ที่มุมจอซ้ายบน (ถ้าต้องการ)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 50, 0, 30)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Text = "Open"
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 20
openButton.Visible = false -- เริ่มปิดไว้
openButton.Parent = playerGui

closeButton.MouseButton1Click:Connect(function()
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = true
    openButton.Visible = false
end)

-- โค้ดที่เหลือของ UI (toggle, button, status) ใส่ต่อจากนี้ได้เลย
-- ...

