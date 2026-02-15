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
frame.Size = UDim2.new(0, 560, 0, 70)
frame.Position = UDim2.new(0.5, -280, 1, 100)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCornerFrame = Instance.new("UICorner")
uiCornerFrame.CornerRadius = UDim.new(0, 30)
uiCornerFrame.Parent = frame

local uiStrokeFrame = Instance.new("UIStroke")
uiStrokeFrame.Thickness = 2
uiStrokeFrame.Color = Color3.fromRGB(200, 40, 40)
uiStrokeFrame.Transparency = 0.2
uiStrokeFrame.Parent = frame

local glow = Instance.new("UIStroke")
glow.Thickness = 6
glow.Color = Color3.fromRGB(255, 60, 60)
glow.Transparency = 0.85
glow.Parent = frame

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
}
uiGradient.Rotation = 90
uiGradient.Parent = frame

local dragHandle = Instance.new("Frame")
dragHandle.Size = UDim2.new(1, 0, 0, 8)
dragHandle.BackgroundTransparency = 1
dragHandle.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.68, 0, 0, 38)
textBox.Position = UDim2.new(0.04, 0, 0.5, -19)
textBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
textBox.TextColor3 = Color3.fromRGB(235, 235, 235)
textBox.PlaceholderText = "Search or paste URL"
textBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 15
textBox.ClearTextOnFocus = false
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.BorderSizePixel = 0
textBox.Parent = frame

local uiCornerTextBox = Instance.new("UICorner")
uiCornerTextBox.CornerRadius = UDim.new(0, 22)
uiCornerTextBox.Parent = textBox

local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.new(0, 42, 0, 42)
searchButton.Position = UDim2.new(0.75, 0, 0.5, -21)
searchButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
searchButton.Text = "↗"
searchButton.Font = Enum.Font.GothamBold
searchButton.TextSize = 20
searchButton.TextColor3 = Color3.fromRGB(255, 200, 200)
searchButton.Parent = frame

local uiCornerSearch = Instance.new("UICorner")
uiCornerSearch.CornerRadius = UDim.new(1, 0)
uiCornerSearch.Parent = searchButton

local uiStrokeSearch = Instance.new("UIStroke")
uiStrokeSearch.Thickness = 2
uiStrokeSearch.Color = Color3.fromRGB(255, 70, 70)
uiStrokeSearch.Transparency = 0.25
uiStrokeSearch.Parent = searchButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 42, 0, 42)
closeButton.Position = UDim2.new(0.84, 0, 0.5, -21)
closeButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBlack
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(255, 220, 220)
closeButton.Parent = frame

local uiCornerClose = Instance.new("UICorner")
uiCornerClose.CornerRadius = UDim.new(1, 0)
uiCornerClose.Parent = closeButton

local uiStrokeClose = Instance.new("UIStroke")
uiStrokeClose.Thickness = 2
uiStrokeClose.Color = Color3.fromRGB(255, 0, 0)
uiStrokeClose.Transparency = 0.15
uiStrokeClose.Parent = closeButton

TweenService:Create(
	frame,
	TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{Position = UDim2.new(0.5, -280, 0.85, -35)}
):Play()

TweenService:Create(
	glow,
	TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{Transparency = 0.65}
):Play()

searchButton.MouseButton1Click:Connect(function()
	local input = textBox.Text
	local url, errorMsg = formatUrl(input)
	if errorMsg then
		return
	end
	open_browser(url, true)
end)

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		searchButton.MouseButton1Click:Fire()
	end
end)

closeButton.MouseButton1Click:Connect(function()
	TweenService:Create(
		frame,
		TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
		{Position = UDim2.new(0.5, -280, 1, 120)}
	):Play()
	task.wait(0.3)
	screenGui:Destroy()
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
