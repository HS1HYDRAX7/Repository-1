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
Main.Size = UDim2.fromScale(0.7,0.7)
Main.Position = UDim2.fromScale(0.15,0.15)
Main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,20)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 2
Stroke.Parent = Main

local Top = Instance.new("Frame")
Top.Size = UDim2.fromScale(1,0.1)
Top.BackgroundTransparency = 1
Top.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "Nexus Executor"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(230,230,230)
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromScale(0.03,0.2)
Title.Size = UDim2.fromScale(0.6,0.6)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Min = Instance.new("TextButton")
Min.Text = "-"
Min.Font = Enum.Font.GothamBold
Min.TextSize = 22
Min.TextColor3 = Color3.fromRGB(255,255,255)
Min.BackgroundColor3 = Color3.fromRGB(0,140,255)
Min.Size = UDim2.fromScale(0.06,0.6)
Min.Position = UDim2.fromScale(0.82,0.2)
Min.Parent = Top
Instance.new("UICorner",Min)

local Close = Instance.new("TextButton")
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.BackgroundColor3 = Color3.fromRGB(200,60,60)
Close.Size = UDim2.fromScale(0.06,0.6)
Close.Position = UDim2.fromScale(0.9,0.2)
Close.Parent = Top
Instance.new("UICorner",Close)

local CodeBox = Instance.new("TextBox")
CodeBox.MultiLine = true
CodeBox.ClearTextOnFocus = false
CodeBox.TextWrapped = true
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 15
CodeBox.TextColor3 = Color3.fromRGB(220,220,220)
CodeBox.BackgroundColor3 = Color3.fromRGB(20,20,25)
CodeBox.Position = UDim2.fromScale(0.03,0.13)
CodeBox.Size = UDim2.fromScale(0.94,0.58)
CodeBox.Text = "-- Inflex Executor\n-- Type your code here"
CodeBox.Parent = Main
Instance.new("UICorner",CodeBox)

local Execute = Instance.new("TextButton")
Execute.Text = "EXECUTE"
Execute.Font = Enum.Font.GothamBold
Execute.TextSize = 16
Execute.TextColor3 = Color3.fromRGB(255,255,255)
Execute.BackgroundColor3 = Color3.fromRGB(0,120,255)
Execute.Size = UDim2.fromScale(0.46,0.1)
Execute.Position = UDim2.fromScale(0.03,0.74)
Execute.Parent = Main
Instance.new("UICorner",Execute)

local Clear = Instance.new("TextButton")
Clear.Text = "CLEAR"
Clear.Font = Enum.Font.GothamBold
Clear.TextSize = 16
Clear.TextColor3 = Color3.fromRGB(220,220,220)
Clear.BackgroundColor3 = Color3.fromRGB(50,50,60)
Clear.Size = UDim2.fromScale(0.46,0.1)
Clear.Position = UDim2.fromScale(0.51,0.74)
Clear.Parent = Main
Instance.new("UICorner",Clear)

local SliderBack = Instance.new("Frame")
SliderBack.Size = UDim2.fromScale(0.94,0.035)
SliderBack.Position = UDim2.fromScale(0.03,0.87)
SliderBack.BackgroundColor3 = Color3.fromRGB(40,40,50)
SliderBack.Parent = Main
Instance.new("UICorner",SliderBack)

local Slider = Instance.new("Frame")
Slider.Size = UDim2.fromScale(0.4,1)
Slider.BackgroundColor3 = Color3.fromRGB(0,170,255)
Slider.Parent = SliderBack
Instance.new("UICorner",Slider)

local Mini = Instance.new("Frame")
Mini.Size = UDim2.fromScale(0.08,0.08)
Mini.Position = UDim2.fromScale(0.05,0.45)
Mini.BackgroundColor3 = Color3.fromRGB(0,170,255)
Mini.Visible = false
Mini.Parent = Gui
Instance.new("UICorner",Mini).CornerRadius = UDim.new(1,0)
local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(0,0,0)
MiniStroke.Thickness = 1
MiniStroke.Parent = Mini

local function tween(o,p)
	TweenService:Create(o,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play()
end

for _,b in pairs({Execute,Clear,Min,Close}) do
	b.MouseEnter:Connect(function()
		tween(b,{BackgroundTransparency=0.15})
	end)
	b.MouseLeave:Connect(function()
		tween(b,{BackgroundTransparency=0})
	end)
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
		tween(Main,{Size=UDim2.fromScale(0.7,0.7)})
	end
end)

Close.MouseButton1Click:Connect(function()
	tween(Main,{Size=UDim2.fromScale(0,0)})
	task.wait(0.25)
	Gui:Destroy()
end)
