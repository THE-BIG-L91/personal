local RunService = game:GetService("RunService")

local ProjectileService: self = {}
local ProjectileClass = require(script.ProjectileClass)
local LauncherConfigs = require(game.ServerScriptService.Scripts.Configs.Launchers)
local AmmoConfigs = require(game.ServerScriptService.Scripts.Configs.Projectiles)

ProjectileService.__index = ProjectileService

-----------------------------------------------------------------------------------------------------------------------------
-- Private
-----------------------------------------------------------------------------------------------------------------------------

local activeProjectiles = {}
local activeProjectilesSize = 0
local activeBind: RBXScriptConnection

local function createReferencePart(size) -- Temporary, until ammoConfigs specifies what the bullet should look like
	local newpart = Instance.new("Part") -- Should be done using the cache module I made ages ago, but this can be added in time.. this is just a prototype
	newpart.Parent = workspace.Colls
	newpart.Size = Vector3.new(size,size,size)
	newpart.Shape = Enum.PartType.Ball
	newpart.Anchored = true
	newpart.Color = Color3.fromRGB(255, 204, 0)
	newpart.Material = Enum.Material.Neon

	return newpart
end

-----------------------------------------------------------------------------------------------------------------------------
-- Type exports
-----------------------------------------------------------------------------------------------------------------------------

export type bullet = {
	pos: Vector3, -- Displacement from origin
	vel: Vector3, -- Velocity
	acc: Vector3, -- Acceleration
	resultantForce: Vector3, -- Net force every frame
	mass: number, -- Mass in kg
	size: number, -- Projectile radius
	A: number, -- Cross sectional area
	cD: number,  -- Drag coefficient
	active: boolean, -- Is the projectile active?
	rsBind: (number)->(), -- Function which is called every .Stepped
	collCallback: (number, number)->(), -- Function fired upon the bullet making a collision
	Destroy: (bullet)->(),
}

export type Launcher = {
	Callback: (bullet: bullet, hit_position: Vector3, velocity: Vector3, collisions: {})->()

}

-----------------------------------------------------------------------------------------------------------------------------
-- Public
-----------------------------------------------------------------------------------------------------------------------------

function ProjectileService:init(gunType, ammoType)	
	if gunType then
		self.launcher = LauncherConfigs[gunType]
	else
		self.launcher = LauncherConfigs.default
	end
	
	self.Callback = self.launcher.Callback
	self.bullet = AmmoConfigs[ammoType]
end

function ProjectileService:fire(origin: Vector3, direction: Vector3)
	local referencePart = createReferencePart(self.bullet.Size)

	local new_params = RaycastParams.new()
	new_params.FilterType = Enum.RaycastFilterType.Exclude
	new_params.FilterDescendantsInstances = {workspace.Colls}	
	
	local projectile = ProjectileClass.new(self.bullet.mass, origin, self.launcher.Callback, self.bullet.Size, new_params, referencePart)
	projectile.vel = self.launcher.startVelocity*direction
	
	if self.bullet.airResistance == true then
		projectile:enableAirResistance(self.bullet.cD, self.bullet.A)
	end
	
	projectile:beginSim()
	local conn
	conn = RunService.Stepped:Connect(function(_,dt)
		if not projectile.rsCallback then
			conn:Disconnect() -- Whenever projectile:Destroy() is called, this will disconnect.
			return	
		end
		
		projectile.rsCallback(_,dt)
	end)
end

function ProjectileService.createLauncher(gunType, ammoType)
	local self = setmetatable(ProjectileService,{})

	self:init(gunType, ammoType)

	return self
end

return ProjectileService
