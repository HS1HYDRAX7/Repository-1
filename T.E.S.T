local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function tween(obj, info, props)
	return TweenService:Create(obj, info, props)
end

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
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 60)
frame.Position = UDim2.new(0.5, -250, 1, 60)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameScale = Instance.new("UIScale")
frameScale.Scale = 0.9
frameScale.Parent = frame

local uiCornerFrame = Instance.new("UICorner")
uiCornerFrame.CornerRadius = UDim.new(0, 12)
uiCornerFrame.Parent = frame

local uiStrokeFrame = Instance.new("UIStroke")
uiStrokeFrame.Thickness = 1
uiStrokeFrame.Color = Color3.fromRGB(40, 40, 40)
uiStrokeFrame.Transparency = 1
uiStrokeFrame.Parent = frame

local dragHandle = Instance.new("Frame")
dragHandle.Size = UDim2.new(1, 0, 0, 6)
dragHandle.BackgroundTransparency = 1
dragHandle.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.85, -50, 0, 35)
textBox.Position = UDim2.new(0.05, 0, 0.5, -17.5)
textBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
textBox.BackgroundTransparency = 0.6
textBox.TextColor3 = Color3.fromRGB(220, 220, 220)
textBox.PlaceholderText = "Search Something"
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 14
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Text = ""
textBox.Parent = frame

local textScale = Instance.new("UIScale")
textScale.Parent = textBox

local uiCornerTextBox = Instance.new("UICorner")
uiCornerTextBox.CornerRadius = UDim.new(0, 8)
uiCornerTextBox.Parent = textBox

local uiStrokeTextBox = Instance.new("UIStroke")
uiStrokeTextBox.Thickness = 1
uiStrokeTextBox.Color = Color3.fromRGB(80, 80, 80)
uiStrokeTextBox.Transparency = 0.6
uiStrokeTextBox.Parent = textBox

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 35, 0, 35)
sendButton.Position = UDim2.new(0.9, -10, 0.5, -17.5)
sendButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sendButton.BackgroundTransparency = 0.7
sendButton.Text = "↑"
sendButton.TextColor3 = Color3.fromRGB(200, 200, 200)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
sendButton.Parent = frame

local buttonScale = Instance.new("UIScale")
buttonScale.Parent = sendButton

local uiCornerButton = Instance.new("UICorner")
uiCornerButton.CornerRadius = UDim.new(0, 17.5)
uiCornerButton.Parent = sendButton

local uiStrokeButton = Instance.new("UIStroke")
uiStrokeButton.Thickness = 1
uiStrokeButton.Color = Color3.fromRGB(120, 120, 120)
uiStrokeButton.Transparency = 0.6
uiStrokeButton.Parent = sendButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Text = ""
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextTransparency = 1
statusLabel.Parent = frame

tween(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, -250, 0.9, -30)
}):Play()

tween(frameScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	Scale = 1
}):Play()

tween(uiStrokeFrame, TweenInfo.new(0.5), {
	Transparency = 0.6
}):Play()

sendButton.MouseEnter:Connect(function()
	tween(buttonScale, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Scale = 1.08}):Play()
	tween(sendButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play()
end)

sendButton.MouseLeave:Connect(function()
	tween(buttonScale, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Scale = 1}):Play()
	tween(sendButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
end)

sendButton.MouseButton1Down:Connect(function()
	tween(buttonScale, TweenInfo.new(0.08, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 0.92}):Play()
end)

sendButton.MouseButton1Up:Connect(function()
	tween(buttonScale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.05}):Play()
end)

textBox.Focused:Connect(function()
	tween(textScale, TweenInfo.new(0.15), {Scale = 1.03}):Play()
	tween(uiStrokeTextBox, TweenInfo.new(0.15), {Transparency = 0.2}):Play()
end)

textBox.FocusLost:Connect(function()
	tween(textScale, TweenInfo.new(0.15), {Scale = 1}):Play()
	tween(uiStrokeTextBox, TweenInfo.new(0.15), {Transparency = 0.6}):Play()
end)

sendButton.MouseButton1Click:Connect(function()
	local input = textBox.Text
	local url, errorMsg = formatUrl(input)
	if errorMsg then
		statusLabel.Text = errorMsg
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		tween(statusLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
		task.wait(3)
		tween(statusLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
		return
	end
	statusLabel.Text = "Opening Please Wait..."
	statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
	tween(statusLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	open_browser(url, true)
	task.wait(3)
	tween(statusLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
end)
