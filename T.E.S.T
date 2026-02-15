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
	return "https://www.startpage.com/search?q=" .. input:gsub(" ", "+"), nil
end

local function open_browser(url)
	local info = {
		presentationStyle = 2,
		url = tostring(url or ""),
		title = "Startpage Browser",
		visible = true
	}
	GuiService:BroadcastNotification(HttpService:JSONEncode(info), 20)
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

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 30)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(200, 40, 40)
frameStroke.Transparency = 0.2
frameStroke.Parent = frame

local glow = Instance.new("UIStroke")
glow.Thickness = 6
glow.Color = Color3.fromRGB(255, 60, 60)
glow.Transparency = 0.85
glow.Parent = frame

TweenService:Create(
	glow,
	TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{Transparency = 0.65}
):Play()

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
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 22)
textCorner.Parent = textBox

local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.new(0, 42, 0, 42)
searchButton.Position = UDim2.new(0.75, 0, 0.5, -21)
searchButton.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
searchButton.Text = "↗"
searchButton.Font = Enum.Font.GothamBold
searchButton.TextSize = 20
searchButton.TextColor3 = Color3.fromRGB(255, 180, 180)
searchButton.Parent = frame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(1, 0)
searchCorner.Parent = searchButton

local searchStroke = Instance.new("UIStroke")
searchStroke.Thickness = 2
searchStroke.Color = Color3.fromRGB(255, 60, 60)
searchStroke.Transparency = 0.25
searchStroke.Parent = searchButton

local tabsButton = Instance.new("ImageButton")
tabsButton.Size = UDim2.new(0, 42, 0, 42)
tabsButton.Position = UDim2.new(0.84, 0, 0.5, -21)
tabsButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabsButton.Image = "rbxassetid://140267785051233"
tabsButton.Parent = frame

local tabsCorner = Instance.new("UICorner")
tabsCorner.CornerRadius = UDim.new(1, 0)
tabsCorner.Parent = tabsButton

local tabsStroke = Instance.new("UIStroke")
tabsStroke.Thickness = 2
tabsStroke.Color = Color3.fromRGB(255, 60, 60)
tabsStroke.Transparency = 0.35
tabsStroke.Parent = tabsButton

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

local tabsGui = Instance.new("Frame")
tabsGui.Size = UDim2.new(0, 480, 0, 300)
tabsGui.Position = UDim2.new(0.5, -240, 0.5, -150)
tabsGui.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
tabsGui.Visible = false
tabsGui.Parent = screenGui

local tabsCornerMain = Instance.new("UICorner")
tabsCornerMain.CornerRadius = UDim.new(0, 28)
tabsCornerMain.Parent = tabsGui

local tabsStrokeMain = Instance.new("UIStroke")
tabsStrokeMain.Thickness = 2
tabsStrokeMain.Color = Color3.fromRGB(200, 40, 40)
tabsStrokeMain.Parent = tabsGui

local closeTabsGui = Instance.new("TextButton")
closeTabsGui.Size = UDim2.new(0, 36, 0, 36)
closeTabsGui.Position = UDim2.new(1, -44, 0, 8)
closeTabsGui.Text = "X"
closeTabsGui.Font = Enum.Font.GothamBold
closeTabsGui.TextSize = 18
closeTabsGui.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
closeTabsGui.TextColor3 = Color3.fromRGB(255, 200, 200)
closeTabsGui.Parent = tabsGui
Instance.new("UICorner", closeTabsGui).CornerRadius = UDim.new(1, 0)

local addTabButton = Instance.new("TextButton")
addTabButton.Size = UDim2.new(0.9, 0, 0, 42)
addTabButton.Position = UDim2.new(0.05, 0, 0.25, 0)
addTabButton.Text = "Adicionar Guia"
addTabButton.Font = Enum.Font.Gotham
addTabButton.TextSize = 14
addTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
addTabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
addTabButton.Parent = tabsGui
Instance.new("UICorner", addTabButton)

local openTabButton = Instance.new("TextButton")
openTabButton.Size = UDim2.new(0.9, 0, 0, 42)
openTabButton.Position = UDim2.new(0.05, 0, 0.45, 0)
openTabButton.Text = "Abrir Guia"
openTabButton.Font = Enum.Font.Gotham
openTabButton.TextSize = 14
openTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
openTabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
openTabButton.Parent = tabsGui
Instance.new("UICorner", openTabButton)

local closeTabButton = Instance.new("TextButton")
closeTabButton.Size = UDim2.new(0.9, 0, 0, 42)
closeTabButton.Position = UDim2.new(0.05, 0, 0.65, 0)
closeTabButton.Text = "Fechar Guia"
closeTabButton.Font = Enum.Font.Gotham
closeTabButton.TextSize = 14
closeTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
closeTabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
closeTabButton.Parent = tabsGui
Instance.new("UICorner", closeTabButton)

local tabs = {}
local selectedTab

tabsButton.MouseButton1Click:Connect(function()
	tabsGui.Visible = true
end)

closeTabsGui.MouseButton1Click:Connect(function()
	tabsGui.Visible = false
end)

addTabButton.MouseButton1Click:Connect(function()
	if textBox.Text ~= "" then
		table.insert(tabs, textBox.Text)
		selectedTab = #tabs
	end
end)

openTabButton.MouseButton1Click:Connect(function()
	if selectedTab and tabs[selectedTab] then
		local url = formatUrl(tabs[selectedTab])
		if url then
			open_browser(url)
		end
	end
end)

closeTabButton.MouseButton1Click:Connect(function()
	if selectedTab then
		table.remove(tabs, selectedTab)
		selectedTab = #tabs
	end
end)

searchButton.MouseButton1Click:Connect(function()
	local url, err = formatUrl(textBox.Text)
	if err then
		statusLabel.Text = err
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		task.delay(2, function() statusLabel.Text = "" end)
		return
	end
	statusLabel.Text = "Opening..."
	statusLabel.TextColor3 = Color3.fromRGB(120, 220, 120)
	open_browser(url)
	task.delay(2, function() statusLabel.Text = "" end)
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
		searchButton.MouseButton1Click:Fire()
	end
end)
