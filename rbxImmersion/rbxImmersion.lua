local Components = script.Parent.Components

type ScreenBorderModule = typeof(require(Components.screenBorder))
type CameraModule = typeof(require(Components.Camera))

type Modules = {
	screenBorder: ScreenBorderModule,
	Camera: CameraModule
}

local rbxImmersion: Modules = {
	screenBorder = require(Components.screenBorder),
	Camera = require(Components.Camera),
}

return rbxImmersion