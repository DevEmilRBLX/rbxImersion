local Components = script.Parent.Components

type ScreenBorderModule = typeof(require(Components.screenBorder))

type Modules = {
	screenBorder: ScreenBorderModule
}

local rbxImmersion: Modules = {
	screenBorder = require(Components.screenBorder),
}

return rbxImmersion
