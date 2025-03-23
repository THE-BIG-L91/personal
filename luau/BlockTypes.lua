local types = {}

export type blockRegistry = {
	blocks: {[string]: block},
	blocksByType: {[string]: {[number]: string}},
	activeLava: {[number]: string} -- Lava which borders a man-made block (or player made, if 'enraged')	
}

types.damaged = {
	is_breakable = true,
	is_placable = false,
	maxHealth = 50,
	material = Enum.Material.Basalt,
	color = Color3.fromRGB(66,66,66)
}

return types
