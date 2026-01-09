local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptLoggerGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.4, 0.5)
main.Position = UDim2.fromScale(0.3, 0.25)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

local drag = false
local dragStart, startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		drag = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		drag = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.fromScale(1, 1)
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarImageTransparency = 0.2
list.BackgroundTransparency = 1
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = list

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

local function addScriptEntry(name, source)
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -16, 0, 48)
	entry.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	entry.Parent = list

	local ec = Instance.new("UICorner")
	ec.CornerRadius = UDim.new(0, 12)
	ec.Parent = entry

	local title = Instance.new("TextLabel")
	title.Text = name
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextColor3 = Color3.new(1, 1, 1)
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -120, 0, 24)
	title.Position = UDim2.new(0, 12, 0, 4)
	title.TextXAlignment = Left
	title.Parent = entry

	local timeLabel = Instance.new("TextLabel")
	timeLabel.Text = os.date("%H:%M:%S")
	timeLabel.Font = Enum.Font.Gotham
	timeLabel.TextSize = 12
	timeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	timeLabel.BackgroundTransparency = 1
	timeLabel.Size = UDim2.new(0, 60, 0, 20)
	timeLabel.Position = UDim2.new(1, -90, 0, 6)
	timeLabel.Parent = entry

	local toggle = Instance.new("TextButton")
	toggle.Text = "🔽"
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 14
	toggle.BackgroundTransparency = 1
	toggle.Size = UDim2.new(0, 30, 0, 30)
	toggle.Position = UDim2.new(1, -40, 0, 4)
	toggle.Parent = entry

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -24, 0, 0)
	content.Position = UDim2.new(0, 12, 0, 44)
	content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	content.ClipsDescendants = true
	content.Parent = entry

	local cc = Instance.new("UICorner")
	cc.CornerRadius = UDim.new(0, 10)
	cc.Parent = content

	local box = Instance.new("TextBox")
	box.Text = source
	box.ClearTextOnFocus = false
	box.MultiLine = true
	box.Font = Enum.Font.Code
	box.TextSize = 12
	box.TextColor3 = Color3.new(1, 1, 1)
	box.BackgroundTransparency = 1
	box.Size = UDim2.new(1, -16, 1, -48)
	box.Position = UDim2.new(0, 8, 0, 8)
	box.TextWrapped = true
	box.TextXAlignment = Left
	box.TextYAlignment = Top
	box.Parent = content

	local copy = Instance.new("TextButton")
	copy.Text = "Copy 📝"
	copy.Font = Enum.Font.GothamBold
	copy.TextSize = 12
	copy.TextColor3 = Color3.new(1, 1, 1)
	copy.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	copy.Size = UDim2.new(0, 100, 0, 28)
	copy.Position = UDim2.new(1, -108, 1, -36)
	copy.Parent = content

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 8)
	bc.Parent = copy

	copy.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(source)
		end
	end)

	local open = false

	toggle.MouseButton1Click:Connect(function()
		open = not open
		toggle.Text = open and "🔼" or "🔽"
		local goalSize = open and UDim2.new(1, -24, 0, 160) or UDim2.new(1, -24, 0, 0)
		local goalEntry = open and UDim2.new(1, -16, 0, 220) or UDim2.new(1, -16, 0, 48)

		TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = goalSize
		}):Play()

		TweenService:Create(entry, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = goalEntry
		}):Play()
	end)
end

addScriptEntry("Example Script", "print('Hello World')\nprint('Script Logger GUI')")
