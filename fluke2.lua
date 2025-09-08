-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRestartUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- สร้าง Frame หลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 520)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Parent = screenGui

local textColor = Color3.fromRGB(255, 255, 255)
local accentColor = Color3.fromRGB(0, 170, 255)

-- ชื่อหัวข้อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 0, 40) -- เหลือที่ให้ปุ่มข้างขวา
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Restart Control"
title.TextColor3 = textColor
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 15
title.Parent = frame

-- ปุ่มพับ/ขยาย UI
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

-- ปุ่มกากบาท ปิด UI (ซ่อน)
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

-- ปุ่มเปิด UI (ซ่อนเริ่มต้น)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 60, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.BackgroundColor3 = accentColor
openButton.TextColor3 = textColor
openButton.Text = "Open UI"
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 22
openButton.Visible = false
openButton.ZIndex = 50
openButton.Parent = playerGui

-- พฤติกรรมปุ่มพับ/ขยาย
minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        frame.Size = UDim2.new(0, 350, 0, 520)
        for _, child in pairs(frame:GetChildren()) do
            if child ~= minimizeButton and child ~= closeButton and child ~= title then
                child.Visible = true
            end
        end
        minimizeButton.Text = "-"
        minimized = false
    else
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

-- ปุ่มปิด UI (ซ่อนทั้ง screenGui)
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    openButton.Visible = true
end)

-- ปุ่มเปิด UI กลับมา
openButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = true
    openButton.Visible = false
end)
