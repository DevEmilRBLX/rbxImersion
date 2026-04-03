--[[
	Camera.lua
	Written by https://github.com/DevEmilRBLX
	Documentation: https://github.com/DevEmilRBLX/rbxImersion/wiki/Camera
]]

local CameraController = {}
CameraController.__index = CameraController

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace  = game:GetService("Workspace")

-- Public Methods

-- Initializes the controller
function CameraController.Get()
	local self = setmetatable({}, CameraController)

	self.Camera = Workspace.CurrentCamera

	return self
end

-- Breathing effect on the camera by changing the FOV. Intensity describes the FOV the camera is set to, default FOV by Roblox is 70 so I'd recommend choosing a value below it
function CameraController:Breath(intensity: number, duration: number)
	if not intensity or not duration then return end
	
	self.Camera  = Workspace.CurrentCamera -- Incase the active camera changes for some reason
	
	local prevFOV = self.Camera.FieldOfView
	
	local tweenDuration = 1
	
	-- Create Tweens
	local zoomInTweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Quint)
	local zoomInTween = TweenService:Create(self.Camera, zoomInTweenInfo, {FieldOfView = intensity})
	
	local zoomOutTweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local zoomOutTween = TweenService:Create(self.Camera, zoomOutTweenInfo, {FieldOfView = prevFOV})
	
	
	-- Loop for the breathing
	local startTime = os.clock()

	while os.clock() - startTime < duration do
		zoomInTween:Play()
		task.wait(tweenDuration)
		task.wait(0.1)
		zoomOutTween:Play()
		task.wait(tweenDuration)
		task.wait(0.1)
	end
end

-- Camera shake for example for explosions or car crashes
function CameraController:Shake(intensity: number,  interval: number, duration: number)
	self.Camera = Workspace.CurrentCamera
	if not self.Camera then return end

	local startTime = os.clock()

	local currentOffset = Vector3.zero
	local targetOffset = Vector3.zero

	local lastUpdate = 0

	local connection
	connection = RunService.RenderStepped:Connect(function()
		local elapsed = os.clock() - startTime

		if elapsed >= duration then
			connection:Disconnect()
			return
		end

		-- Calculate new positon
		if os.clock() - lastUpdate >= interval then
			lastUpdate = os.clock()

			targetOffset = Vector3.new(
				(math.random() - 0.5) * 2 * intensity,
				(math.random() - 0.5) * 2 * intensity,
				(math.random() - 0.5) * 2 * intensity
			)
		end

		currentOffset = currentOffset:Lerp(targetOffset, 0.2)

		local baseCFrame = Workspace.CurrentCamera.CFrame

		camera.CFrame = baseCFrame * CFrame.new(currentOffset)
	end)
end

-- Zoom the FOV
function CameraController:Zoom(FOV: number, timeToTween: number, duration: number)
	local prevFOV = self.Camera.FieldOfView
	
	self.Camera = Workspace.CurrentCamera
	
	-- Tweens
	local zoomInTweenInfo = TweenInfo.new(timeToTween, Enum.EasingStyle.Quint)
	local zoomInTween = TweenService:Create(self.Camera, zoomInTweenInfo, {FieldOfView = FOV})
	
	local zoomOutTweenInfo = TweenInfo.new(timeToTween, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local zoomOutTween = TweenService:Create(self.Camera, zoomOutTweenInfo, {FieldOfView = prevFOV})
	
	zoomInTween:Play()
	if not duration then return else task.wait(duration); zoomOutTween:Play() end
end

return CameraController
