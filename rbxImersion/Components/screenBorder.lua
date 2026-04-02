--[[
	screenBorder.lua
	Written by https://github.com/DevEmilRBLX
	Documentation: https://github.com/DevEmilRBLX/rbxImersion/wiki/Screen-Border
]]

local Border = {}
Border.__index = Border

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Singleton Storage
local _instance = nil

-- Private
function Border:_createBorder()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "_rbxImersion_Border"
	screenGui.Parent = playerGui
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	screenGui.ScreenInsets = Enum.ScreenInsets.None
	screenGui.ClipToDeviceSafeArea = true
	screenGui.Enabled = false

	local canvas = Instance.new("CanvasGroup")
	canvas.Parent = screenGui
	canvas.BackgroundTransparency = 1
	canvas.GroupColor3 = Color3.fromRGB(255,255,255)
	canvas.Size = UDim2.fromScale(1,1)
	canvas.Interactable = false
	canvas.GroupTransparency = 1

	local controllingGradient = Instance.new("UIGradient")
	controllingGradient.Parent = canvas

	self.Gui = screenGui
	self.Canvas = canvas
	self.Gradient = controllingGradient

	local rotation = 0

	for i = 1, 4 do
		local frame = Instance.new("Frame")
		frame.Parent = canvas
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Size = UDim2.fromScale(1, 1)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
		frame.Name = i

		local gradient = Instance.new("UIGradient")
		gradient.Rotation = rotation
		gradient.Parent = frame

		gradient.Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.975, 1),
			NumberSequenceKeypoint.new(1, 0.5),
		}
		rotation += 90
	end
end

-- Constructor
function new()
	local self = setmetatable({}, Border)
	self:_createBorder()
	return self
end

-- Public Methods

-- Create or get the screen border
function Border.Get()
	if not _instance then
		_instance = new()
	end

	return _instance
end

-- Set the ScreenGui.Enabled to true, however the border will not be visible as long as the transparency is set to 1
function Border:Enable()
	self.Gui.Enabled = true
end

-- Set the ScreenGui.Enabled to false
function Border:Disable()
	self.Gui.Enabled = false
end

-- Fades the transparency to x in y seconds
function Border:Fade(Time: number, Transparency: number)
	local tween = TweenService:Create(
		self.Canvas,
		TweenInfo.new(Time),
		{GroupTransparency = Transparency}
	)
	tween:Play()
end

-- Change the borders color with a ColorSequence to have multiple colors in the border
function Border:ChangeColor(color: ColorSequence)
	self.Gradient.Color = color
end

-- Change the borders color with a Color3 value to have one color in the border
function Border:ChangeColorStatic(color: Color3)
	self.Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color), ColorSequenceKeypoint.new(1, color)})
end

-- Show the border for x seconds and hide it again
function Border:Blink(speed)
	speed = speed or 0.3
	self:Fade(0, 1)
	self:Fade(speed, 0)
	task.wait(speed)
	self:Fade(speed, 1)
end

-- Start rotating the controllingGradient with speed = 1 [°/s]
function Border:StartRotation(speed: number)
	speed = speed or 50

	self:StopRotation()

	self._rotationConnection = RunService.RenderStepped:Connect(function(dt)
		local newRotation = self.Gradient.Rotation + speed * dt

		self.Gradient.Rotation = math.floor(newRotation) % 360
	end)
end

-- Stop rotating the controllingGradient
function Border:StopRotation()
	if self._rotationConnection then
		self._rotationConnection:Disconnect()
		self._rotationConnection = nil
	end
end

-- Set the rotation of the controllingGradient to a specfic value 
function Border:Rotate(angle: number)
	self.Gradient.Rotation = angle
end

return Border
