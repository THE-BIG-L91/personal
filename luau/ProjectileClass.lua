local STUD_CONSTANT = 0.28 -- 1 stud = 0.28 meters
local METER_CONSTANT = 3.571428571428571 -- 1/0.28
local INCREMENT = 72
local WIND_ON = 0
local AIR_DENSITY = 1.225 -- at sea level
local MAX_PROJ_DURATION = 10
local G = workspace.Gravity*STUD_CONSTANT -- Conversion from studs per second to meters per second

local projectile = {}
projectile.__index = projectile

function projectile:physStep(dt)
	local inc_dt = dt/INCREMENT
	local colls
	self.dur += dt

	for i=1,INCREMENT do
		local MASS = self.mass
		
		self.resultantForce += Vector3.new(0, -(G*self.mass),0) -- Incase mass may vary.. e.g. in a rocket
		
		for _,force in pairs(self.constForces) do
			self.resultantForce += force	
		end
		
		if self.airRstFlag then
			local VEL_SQUARED = ((self.vel).Magnitude)^2
			local UNIT_VEL
			
			if (self.vel).Magnitude <= 0.01 then
				UNIT_VEL = Vector3.new(0,0,0)
			else
				UNIT_VEL = (self.vel).Unit
			end
			
			local D = 0.5*AIR_DENSITY*VEL_SQUARED*self.A*self.cD
			self.resultantForce += -(UNIT_VEL)*D
		end

		self.acc = (self.resultantForce/MASS) -- m s^-2

		self.vel += (self.acc)*inc_dt + workspace.GlobalWind*WIND_ON*STUD_CONSTANT*inc_dt -- ms^-1
		self.resultantForce = Vector3.new(0,0,0)
		
		colls = workspace:Raycast(self.pos, self.vel*inc_dt*METER_CONSTANT, self.collisionParams)
		self.pos += self.vel*inc_dt*METER_CONSTANT -- m -> studs
		if colls then
			return colls
		end			
	end
	
	
	return nil
end

function projectile:enableAirResistance(cD: number?, A: number?)
	assert((cD ~= nil) and (self.cD == nil), "A drag coefficent must be provided if air resistance is enabled!")

	if not self.cD then
		self.cD = cD
	end
	
	if not A then
		self.A = (((self.size/2)*STUD_CONSTANT)^2)*math.pi -- Size is given in studs
	else
		self.A = A
	end
	
	self.airRstFlag = true
end

function projectile:applyConstForce(name, force)
	self.constForces[name] = force
end

function projectile:applyImpulse(impulse) -- This will be fixed in time :)
	self.vel += (impulse/self.mass)
end


function projectile:removeConstForce(name)
	if self.constForces[name] == nil then
		return
	end

	self.constForces[name] = nil
end

function projectile:init(mass, position, coll_callback, size, coll_params: RaycastParams?, worldReference: Instance | Model)
	self.pos = position
	self.vel = Vector3.new(0,0,0)
	self.acc = Vector3.new(0,0,0)
	self.mass = mass
	self.resultantForce = Vector3.new(0,0,0)
	self.constForces = {}	
	self.active = false
	self.rsCallback = nil
	self.size = size
	self.collCallback = coll_callback
	self.worldReference = worldReference
	self.dur = 0
	
	if coll_params then
		self.collisionParams = coll_params
	end

	--self:applyConstForce("g",Vector3.new(0,-G*self.mass,0))	
end

function projectile:ricochet(normal: Vector3)
	-- tba
end

function projectile:beginSim()
	if self.active == true then
		return
	end

	self.active = true
	
	self.rsCallback = function(_, dt)
		local colls = self:physStep(dt)
		self.worldReference.Position = self.pos
		
		if not colls then
			return
		end
		
		if self.dur > MAX_PROJ_DURATION then
			self:Destroy()
			warn("Projectile active for too long!")
			return
		end
		
		self.collCallback(self, self.pos, self.vel, colls)
	end
end

function projectile:endSim()
	if self.active == false then
		return
	end

	self.active = false

	if self.rsBind == nil then
		return
	end

	self.rsBind = nil
end

function projectile:Destroy()
	if self.active then
		self:endSim()
	end
	
	if self.rsCallback ~= nil then
		self.rsCallback = nil
	end
	
	for _,v in pairs(self) do
		v = nil
	end
end

-- Callback must be structured like:
--[[
function callback(self, hit: {})
	blah
	self:endSim()
end
]]
-- begin sim with self:beginSim()
-- you can read from pos, maybe set pos too
-- you can set collisionparams with self.collisionParams

function projectile.new(mass, position, coll_callback, size, coll_params: RaycastParams?, worldReference: Instance | Model)
	assert(mass ~= nil, "Projectile: Mass must be provided!")
	assert(position ~= nil, "Projectile: Position must be provided!")
	assert(coll_callback ~= nil, "Projectile: You must supply a function for when a collision takes place!")
	assert(size ~= nil, "Projectile: Projectile must have a size!")
	assert(typeof(worldReference) == "Model" or typeof(worldReference) == "Instance", "Projectile: World reference must be of type 'Instance' or 'Model'")
	
	local newProj = setmetatable({}, projectile)

	newProj:init(mass, position, coll_callback, size, coll_params, worldReference)

	return newProj
end

return projectile
