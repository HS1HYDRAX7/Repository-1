local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function formatUrl(input)
	input = input:match("^%s*(.-)%s*$")
	if input == "" then
		return nil, "Enter a URL or search term."
	end
	if input:match("^https?://") then
		return input, nil
	end
	local searchQuery = input:gsub(" ", "+")
	return "https://www.startpage.com/search?q=" .. searchQuery, nil
end

local function open_browser(url, asJson)
	local info = {
		presentationStyle = 2,
		url = tostring(url or ""),
		title = "Startpage Browser",
		visible = true
	}
	local msg = asJson and HttpService:JSONEncode(info) or (info.title .. "\n" .. info.url)
	GuiService:BroadcastNotification(msg, 20)
end

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrowserGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 520, 0, 70)
frame.Position = UDim2.new(0.5, -260, 1, 100)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCornerFrame = Instance.new("UICorner")
uiCornerFrame.CornerRadius = UDim.new(0, 30)
uiCornerFrame.Parent = frame

local uiStrokeFrame = Instance.new("UIStroke")
uiStrokeFrame.Thickness = 2
uiStrokeFrame.Color = Color3.fromRGB(180, 30, 30)
uiStrokeFrame.Transparency = 0.2
uiStrokeFrame.Parent = frame

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
}
uiGradient.Rotation = 90
uiGradient.Parent = frame

local glow = Instance.new("UIStroke")
glow.Thickness = 6
glow.Color = Color3.fromRGB(255, 60, 60)
glow.Transparency = 0.85
glow.Parent = frame

local dragHandle = Instance.new("Frame")
dragHandle.Size = UDim2.new(1, 0, 0, 8)
dragHandle.BackgroundTransparency = 1
dragHandle.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.78, 0, 0, 38)
textBox.Position = UDim2.new(0.04, 0, 0.5, -19)
textBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
textBox.TextColor3 = Color3.fromRGB(235, 235, 235)
textBox.PlaceholderText = "Search or paste URL"
textBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 15
textBox.ClearTextOnFocus = false
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Parent = frame

local uiCornerTextBox = Instance.new("UICorner")
uiCornerTextBox.CornerRadius = UDim.new(0, 22)
uiCornerTextBox.Parent = textBox

local uiStrokeTextBox = Instance.new("UIStroke")
uiStrokeTextBox.Thickness = 1.5
uiStrokeTextBox.Color = Color3.fromRGB(200, 40, 40)
uiStrokeTextBox.Transparency = 0.4
uiStrokeTextBox.Parent = textBox

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 42, 0, 42)
sendButton.Position = UDim2.new(0.85, 0, 0.5, -21)
sendButton.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
sendButton.Text = "↗"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 20
sendButton.TextColor3 = Color3.fromRGB(255, 180, 180)
sendButton.Parent = frame

local uiCornerButton = Instance.new("UICorner")
uiCornerButton.CornerRadius = UDim.new(1, 0)
uiCornerButton.Parent = sendButton

local uiStrokeButton = Instance.new("UIStroke")
uiStrokeButton.Thickness = 2
uiStrokeButton.Color = Color3.fromRGB(255, 60, 60)
uiStrokeButton.Transparency = 0.25
uiStrokeButton.Parent = sendButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 18)
statusLabel.Position = UDim2.new(0.04, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

TweenService:Create(
	frame,
	TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{Position = UDim2.new(0.5, -260, 0.85, -35)}
):Play()

TweenService:Create(
	glow,
	TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{Transparency = 0.65}
):Play()

sendButton.MouseEnter:Connect(function()
	TweenService:Create(sendButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 0, 0)}):Play()
end)

sendButton.MouseLeave:Connect(function()
	TweenService:Create(sendButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 0, 0)}):Play()
end)

sendButton.MouseButton1Click:Connect(function()
	local input = textBox.Text
	local url, errorMsg = formatUrl(input)
	if errorMsg then
		statusLabel.Text = errorMsg
		statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
		return
	end
	statusLabel.Text = "Opening..."
	statusLabel.TextColor3 = Color3.fromRGB(120, 220, 120)
	TweenService:Create(frame, TweenInfo.new(0.15), {Size = UDim2.new(0, 520, 0, 74)}):Play()
	open_browser(url, true)
	task.delay(2, function()
		statusLabel.Text = ""
		TweenService:Create(frame, TweenInfo.new(0.15), {Size = UDim2.new(0, 520, 0, 70)}):Play()
	end)
end)

local dragging = false
local dragStart
local startPos

dragHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendButton.MouseButton1Click:Fire()
	end
end)
