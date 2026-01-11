local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local waypoints = {}

-- CONFIG
local FONT_ID = "rbxassetid://12187368843"
local MOBILE_SCALE = 0.8

-- SCREEN GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "WaypointUI"
screenGui.ResetOnSpawn = false

-- MAIN FRAME
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 280*MOBILE_SCALE, 0, 350*MOBILE_SCALE)
mainFrame.Position = UDim2.new(0.1,0,0.15,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0,16)

-- DRAG FUNCTION
local dragging, dragStart, startPos
local function makeDraggable(frame)
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
										startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(frame,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
				{Position=targetPos}):Play()
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end
makeDraggable(mainFrame)

-- CLOSE BUTTON
local closeBtn = Instance.new("ImageButton", mainFrame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Image = ""
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,8)

-- FLOATING ICON
local floatingIcon = Instance.new("ImageButton", screenGui)
floatingIcon.Size = UDim2.new(0,50,0,50)
floatingIcon.Position = UDim2.new(0,10,0,60)
floatingIcon.Image = "rbxassetid://10723384893"
floatingIcon.Visible = false
floatingIcon.BackgroundTransparency = 1
floatingIcon.AutoButtonColor = false
makeDraggable(floatingIcon)

-- ANIM FUNCTIONS
local function animateScale(obj, scale)
	TweenService:Create(obj, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = scale}):Play()
end
local function tweenProps(obj, props, time, style, direction)
	TweenService:Create(obj, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props):Play()
end

-- TITLE
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1,0,0,30)
titleLabel.Position = UDim2.new(0,0,0,0)
titleLabel.Text = "Waypoint Manager"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.Custom
titleLabel.FontFace = Font.new(FONT_ID)

-- TEXTBOXES
local function createTextBox(y, placeholder)
	local box = Instance.new("TextBox", mainFrame)
	box.Size = UDim2.new(1,-20,0,30)
	box.Position = UDim2.new(0,10,0,y)
	box.PlaceholderText = placeholder
	box.TextScaled = true
	box.Font = Enum.Font.Custom
	box.FontFace = Font.new(FONT_ID)
	box.TextColor3 = Color3.new(1,1,1)
	box.BackgroundColor3 = Color3.fromRGB(50,50,50)
	box.BorderSizePixel = 0
	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0,8)
	box.Focused:Connect(function()
		tweenProps(box,{BackgroundColor3=Color3.fromRGB(70,70,70)},0.15)
	end)
	box.FocusLost:Connect(function()
		tweenProps(box,{BackgroundColor3=Color3.fromRGB(50,50,50)},0.15)
	end)
	return box
end

local nameBox = createTextBox(40,"Waypoint Name")
local colorBox = createTextBox(80,"Color Hex (0,0,0)")

-- CREATE BUTTON
local createBtn = Instance.new("TextButton", mainFrame)
createBtn.Size = UDim2.new(1,-20,0,35)
createBtn.Position = UDim2.new(0,10,0,125)
createBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
createBtn.TextColor3 = Color3.new(1,1,1)
createBtn.Text = "Create"
createBtn.Font = Enum.Font.Custom
createBtn.FontFace = Font.new(FONT_ID)
createBtn.TextScaled = true
createBtn.BorderSizePixel = 0
Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0,8)

-- SCROLL FRAME
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1,-20,1, -170)
scrollFrame.Position = UDim2.new(0,10,0,170)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0,5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- WAYPOINT CREATION
local function create3DMarker(pos,name,color)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Size = Vector3.new(0.1,0.1,0.1)
	part.Position = pos
	part.Name = "WaypointMarker_"..name
	part.Parent = workspace

	local billboard = Instance.new("BillboardGui",part)
	billboard.Size = UDim2.new(0,150,0,50)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel",billboard)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextScaled = true
	label.TextColor3 = color
	label.Font = Enum.Font.Custom
	label.FontFace = Font.new(FONT_ID)
	return part
end

local function createWaypointUI(name,pos,color)
	local markerPart = create3DMarker(pos,name,color)

	local item = Instance.new("Frame", scrollFrame)
	item.Size = UDim2.new(1,0,0,35)
	item.BackgroundColor3 = Color3.fromRGB(50,50,50)
	item.BorderSizePixel = 0
	local corner = Instance.new("UICorner", item)
	corner.CornerRadius = UDim.new(0,8)

	local nameLabel = Instance.new("TextLabel",item)
	nameLabel.Size = UDim2.new(0.5,0,1,0)
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.new(1,1,1)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.Custom
	nameLabel.FontFace = Font.new(FONT_ID)
	nameLabel.TextScaled = true
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local deleteBtn = Instance.new("TextButton",item)
	deleteBtn.Size = UDim2.new(0,30,0,30)
	deleteBtn.Position = UDim2.new(1,-70,0.5,-15)
	deleteBtn.Text = "❌"
	deleteBtn.TextColor3 = Color3.new(1,1,1)
	deleteBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
	deleteBtn.Font = Enum.Font.Custom
	deleteBtn.FontFace = Font.new(FONT_ID)
	deleteBtn.TextScaled = true
	Instance.new("UICorner",deleteBtn).CornerRadius=UDim.new(0,6)

	local tpBtn = Instance.new("TextButton",item)
	tpBtn.Size = UDim2.new(0,40,0,30)
	tpBtn.Position = UDim2.new(1,-35,0.5,-15)
	tpBtn.Text = "TP"
	tpBtn.TextColor3 = Color3.new(1,1,1)
	tpBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
	tpBtn.Font = Enum.Font.Custom
	tpBtn.FontFace = Font.new(FONT_ID)
	tpBtn.TextScaled = true
	Instance.new("UICorner",tpBtn).CornerRadius=UDim.new(0,6)

	deleteBtn.MouseButton1Click:Connect(function()
		item:Destroy()
		if markerPart then markerPart:Destroy() end
		for i,data in ipairs(waypoints) do
			if data.ui==item then table.remove(waypoints,i); break end
		end
	end)

	tpBtn.MouseButton1Click:Connect(function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(markerPart.Position + Vector3.new(0,3,0))
		end
	end)

	item.Parent = scrollFrame
	scrollFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
	table.insert(waypoints,{name=name,pos=pos,ui=item,marker=markerPart})
end

-- CREATE BUTTON LOGIC
createBtn.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local name = nameBox.Text~="" and nameBox.Text or ("Waypoint #"..tostring(#waypoints+1))
	local inputColor = colorBox.Text
	local r,g,b = string.match(inputColor,"(%d+),(%d+),(%d+)")
	local color = Color3.fromRGB(255,255,255)
	if r and g and b then
		color = Color3.fromRGB(tonumber(r),tonumber(g),tonumber(b))
	end

	createWaypointUI(name,root.Position,color)
	nameBox.Text=""
	colorBox.Text=""
end)

-- CLOSE BUTTON LOGIC
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible=false
	floatingIcon.Visible=true
end)

floatingIcon.MouseButton1Click:Connect(function()
	floatingIcon.Visible=false
	mainFrame.Visible=true
end)

-- UPDATE DISTANCE LABELS
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local pos = char.HumanoidRootPart.Position
	for _,data in pairs(waypoints) do
		if data.ui:FindFirstChild("DistLabel") then
			data.ui.DistLabel.Text = string.format("%.1f m",(data.pos-pos).Magnitude)
		end
	end
end)
