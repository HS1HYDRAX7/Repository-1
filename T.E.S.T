local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")

local explicitKeywords = {
	"porn","sexo","sex","xxx","hentai","nsfw","nude","nudes","18+","rule34","boobs","pussy","cock","dick","anal","fetish"
}

local browserOpened = false

local function containsExplicit(text)
	text = string.lower(text)
	for _, word in ipairs(explicitKeywords) do
		if string.find(text, word, 1, true) then
			return true
		end
	end
	return false
end

local function formatUrl(input)
	input = input:match("^%s*(.-)%s*$")
	if input == "" then
		return nil, "Enter a URL or search term."
	end
	if containsExplicit(input) then
		if browserOpened then
			error("Explicit content blocked.")
		end
		return nil, "Explicit searches are not allowed."
	end
	if input:match("^https?://") then
		return input, nil
	end
	local searchQuery = input:gsub(" ", "+")
	return "https://www.startpage.com/search?q=" .. searchQuery, nil
end

local function open_browser(url, asJson)
	browserOpened = true
	local info = {
		presentationStyle = 2,
		url = tostring(url or ""),
		title = "Secure Browser",
		visible = true
	}
	local msg = asJson and HttpService:JSONEncode(info) or (info.title .. "\n" .. info.url)
	GuiService:BroadcastNotification(msg, 20)
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrowserGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 520, 0, 70)
frame.Position = UDim2.new(0.5, -260, 1, 80)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCornerFrame = Instance.new("UICorner")
uiCornerFrame.CornerRadius = UDim.new(0, 32)
uiCornerFrame.Parent = frame

local uiStrokeFrame = Instance.new("UIStroke")
uiStrokeFrame.Thickness = 1.2
uiStrokeFrame.Color = Color3.fromRGB(60, 60, 60)
uiStrokeFrame.Transparency = 0.3
uiStrokeFrame.Parent = frame

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
}
uiGradient.Parent = frame

local dragHandle = Instance.new("Frame")
dragHandle.Size = UDim2.new(1, 0, 0, 6)
dragHandle.BackgroundTransparency = 1
dragHandle.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.82, -40, 0, 40)
textBox.Position = UDim2.new(0.04, 0, 0.5, -20)
textBox.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
textBox.TextColor3 = Color3.fromRGB(235, 235, 235)
textBox.PlaceholderText = "Search or enter URL"
textBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
textBox.Font = Enum.Font.GothamMedium
textBox.TextSize = 15
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local uiCornerTextBox = Instance.new("UICorner")
uiCornerTextBox.CornerRadius = UDim.new(0, 22)
uiCornerTextBox.Parent = textBox

local uiStrokeTextBox = Instance.new("UIStroke")
uiStrokeTextBox.Thickness = 1
uiStrokeTextBox.Color = Color3.fromRGB(70, 70, 70)
uiStrokeTextBox.Transparency = 0.25
uiStrokeTextBox.Parent = textBox

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 42, 0, 42)
sendButton.Position = UDim2.new(0.88, -6, 0.5, -21)
sendButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
sendButton.Text = "→"
sendButton.TextColor3 = Color3.fromRGB(230, 230, 230)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 18
sendButton.Parent = frame

local uiCornerButton = Instance.new("UICorner")
uiCornerButton.CornerRadius = UDim.new(1, 0)
uiCornerButton.Parent = sendButton

local uiStrokeButton = Instance.new("UIStroke")
uiStrokeButton.Thickness = 1
uiStrokeButton.Color = Color3.fromRGB(120, 120, 120)
uiStrokeButton.Transparency = 0.35
uiStrokeButton.Parent = sendButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 18)
statusLabel.Position = UDim2.new(0.05, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

TweenService:Create(
	frame,
	TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{Position = UDim2.new(0.5, -260, 0.9, -35)}
):Play()

local dragging = false
local dragStart
local startPos

dragHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

sendButton.MouseButton1Click:Connect(function()
	local input = textBox.Text
	local url, errorMsg = formatUrl(input)
	if errorMsg then
		statusLabel.Text = errorMsg
		statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
		task.delay(3, function()
			statusLabel.Text = ""
		end)
		return
	end
	statusLabel.Text = "Opening..."
	statusLabel.TextColor3 = Color3.fromRGB(120, 220, 120)
	open_browser(url, true)
	task.delay(2, function()
		statusLabel.Text = ""
	end)
end)

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendButton.MouseButton1Click:Fire()
	end
end)
