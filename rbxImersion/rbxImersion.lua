local Components = script.Parent.Components

type ScreenBorderModule = typeof(require(Components.screenBorder))

type Modules = {
	screenBorder: ScreenBorderModule
}

local rbxImersion: Modules = {
	screenBorder = require(Components.screenBorder),
}

return rbxImersion