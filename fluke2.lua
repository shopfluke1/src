-- ปุ่มพับ UI
local minimized = false
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -90, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.TextColor3 = textColor
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 24
minimizeButton.ZIndex = 99
minimizeButton.Parent = frame

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(frame:GetChildren()) do
        if child ~= minimizeButton and child ~= title and child.Name ~= "closeButton" then
            child.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 470)
    minimizeButton.Text = minimized and "+" or "-"
end)

-- ปุ่มปิด UI
local closeButton = Instance.new("TextButton")
closeButton.Name = "closeButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = textColor
closeButton.Text = "✖"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 24
closeButton.ZIndex = 99
closeButton.Parent = frame

-- ปุ่มเปิด UI กลับมา
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 80, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.BackgroundColor3 = accentColor
openButton.TextColor3 = textColor
openButton.Text = "Open UI"
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 20
openButton.Visible = false
openButton.ZIndex = 100
openButton.Parent = playerGui

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = true
    openButton.Visible = false
end)
