local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "NexusExecutor"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromScale(0.6,0.6)
Main.Position = UDim2.fromScale(0.2,0.2)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner",Main)
MainCorner.CornerRadius = UDim.new(0,22)

local MainStroke = Instance.new("UIStroke",Main)
MainStroke.Color = Color3.fromRGB(40,40,40)
MainStroke.Thickness = 1.5

local Top = Instance.new("Frame")
Top.Size = UDim2.fromScale(1,0.1)
Top.BackgroundTransparency = 1
Top.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "Nexus Executor"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(220,220,220)
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromScale(0.04,0.2)
Title.Size = UDim2.fromScale(0.6,0.6)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Min = Instance.new("TextButton")
Min.Text = "-"
Min.Font = Enum.Font.GothamBold
Min.TextSize = 22
Min.TextColor3 = Color3.fromRGB(220,220,220)
Min.BackgroundColor3 = Color3.fromRGB(30,30,30)
Min.Size = UDim2.fromScale(0.06,0.55)
Min.Position = UDim2.fromScale(0.82,0.22)
Min.Parent = Top
Instance.new("UICorner",Min).CornerRadius = UDim.new(1,0)

local Close = Instance.new("TextButton")
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.TextColor3 = Color3.fromRGB(255,120,120)
Close.BackgroundColor3 = Color3.fromRGB(30,30,30)
Close.Size = UDim2.fromScale(0.06,0.55)
Close.Position = UDim2.fromScale(0.9,0.22)
Close.Parent = Top
Instance.new("UICorner",Close).CornerRadius = UDim.new(1,0)

local CodeBox = Instance.new("TextBox")
CodeBox.MultiLine = true
CodeBox.ClearTextOnFocus = false
CodeBox.TextWrapped = false
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 15
CodeBox.TextColor3 = Color3.fromRGB(210,210,210)
CodeBox.BackgroundColor3 = Color3.fromRGB(22,22,22)
CodeBox.Position = UDim2.fromScale(0.04,0.14)
CodeBox.Size = UDim2.fromScale(0.9,0.55)
CodeBox.Text = "-- Nexus Executor\n-- Paste your script here"
CodeBox.Parent = Main
Instance.new("UICorner",CodeBox).CornerRadius = UDim.new(0,14)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.fromScale(0.02,0.55)
Scroll.Position = UDim2.fromScale(0.94,0.14)
Scroll.CanvasSize = UDim2.fromScale(0,2)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.Parent = Main

local Execute = Instance.new("TextButton")
Execute.Text = "Execute"
Execute.Font = Enum.Font.GothamSemibold
Execute.TextSize = 15
Execute.TextColor3 = Color3.fromRGB(240,240,240)
Execute.BackgroundColor3 = Color3.fromRGB(35,35,35)
Execute.Size = UDim2.fromScale(0.42,0.1)
Execute.Position = UDim2.fromScale(0.04,0.72)
Execute.Parent = Main
Instance.new("UICorner",Execute).CornerRadius = UDim.new(0,16)

local Clear = Instance.new("TextButton")
Clear.Text = "Clear"
Clear.Font = Enum.Font.GothamSemibold
Clear.TextSize = 15
Clear.TextColor3 = Color3.fromRGB(200,200,200)
Clear.BackgroundColor3 = Color3.fromRGB(35,35,35)
Clear.Size = UDim2.fromScale(0.42,0.1)
Clear.Position = UDim2.fromScale(0.52,0.72)
Clear.Parent = Main
Instance.new("UICorner",Clear).CornerRadius = UDim.new(0,16)

local Mini = Instance.new("Frame")
Mini.Size = UDim2.fromScale(0.06,0.1)
Mini.Position = UDim2.fromScale(0.05,0.45)
Mini.BackgroundColor3 = Color3.fromRGB(0,140,255)
Mini.Visible = false
Mini.Active = true
Mini.Draggable = true
Mini.Parent = Gui
Instance.new("UICorner",Mini).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke",Mini).Color = Color3.fromRGB(0,0,0)

local function tween(o,p)
	TweenService:Create(o,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play()
end

Execute.MouseButton1Click:Connect(function()
	pcall(function()
		loadstring(CodeBox.Text)()
	end)
end)

Clear.MouseButton1Click:Connect(function()
	CodeBox.Text = ""
end)

Min.MouseButton1Click:Connect(function()
	tween(Main,{Size=UDim2.fromScale(0,0)})
	task.wait(0.25)
	Main.Visible = false
	Mini.Visible = true
end)

Mini.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		Mini.Visible = false
		Main.Visible = true
		tween(Main,{Size=UDim2.fromScale(0.6,0.6)})
	end
end)

Close.MouseButton1Click:Connect(function()
	tween(Main,{Size=UDim2.fromScale(0,0)})
	task.wait(0.25)
	Gui:Destroy()
end)
