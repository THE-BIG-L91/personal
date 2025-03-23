local blockTypes = require(script.BlockTypes)
local blockService = {}

blockService.__index = blockService

-----------------------------------------------------------------------------------------------------------------------------
-- Private
-----------------------------------------------------------------------------------------------------------------------------

local LAVA_TICK_DAMAGE = 2


-----------------------------------------------------------------------------------------------------------------------------
-- Type exports
-----------------------------------------------------------------------------------------------------------------------------



export type block = {
	id: string,
	pos: Vector3int16,
	material: number,
	maxHealth: number,
	health: number,
	owner: string,
}

type lava = block & {
	active: boolean,
	neighbouringBlocks: {},
	neighbouringAir: {}
}

export type blockRegistry = {
	blocks: {[string]: block},
	blocksByType: {[string]: {[number]: string}},
	activeLava: {[number]: string} -- Lava which borders a man-made block (or player made, if 'enraged')	
}


-- Indexed by coordinate
-- For the sake of simplicity, it'll be stored in a dictionary
local function posToStr(pos: Vector3int16) -- This won't cause issues if maps are all positioned in the same area; Lua reuses strings..
	return tostring(100*pos.x)..tostring(10*pos.y)..tostring(pos.z)
end

local function boundCheck(pos)
	-- check if position is not in play area
	-- all worlds are 255x255x255
end

-----------------------------------------------------------------------------------------------------------------------------
-- Public
-----------------------------------------------------------------------------------------------------------------------------

function blockService:changeMaterial(block: block, material: number)
	block.reference.material = blockTypes[material].material
	block.reference.color = blockTypes[material].color
end

function blockService:destroyBlock(blockId: number)
	self.blocks[blockId] = nil
end

function blockService:damageBlock(block: string, amount: number)
	if LAVA_TICK_DAMAGE > self.blocks[block].health then
		self:destroyBlock(block.id)
	end
	
	self.blocks[block].health -= LAVA_TICK_DAMAGE
	
	if block.health <= block.maxHealth*0.5 then
		self:changeMaterial(block, "damaged")
	end
end

function blockService:spreadLava(lava: lava) -- Maybe not the best way
	if #lava.neighbouringBlocks == 0 then
		lava.active = false
	end

	for _,air in lava.neighbouringAir do
		self:createLava(air, true)
	end
end

function blockService:lavaTick()
	for _,lava in self.activeLava do
		if lava.active == false then
			continue
		end
		
		for _,n in lava.neighbouringBlocks do
			self:damageBlock(n, LAVA_TICK_DAMAGE)			
		end
		
		lava.neighbouringBlocks, lava.neighbouringAir = self:getNeighbouringBlocks(lava, true)
		self:spreadLava(lava)
	end	
	-- O(n^2).. yes.
	-- is there a faster way of doing this??
	-- No ^^;
end

function blockService:getBlocksByType(blockType: number): {[number]: string}
	if self.blocksByType[blockType] == nil then
		return {}
	end

	return self.blocksByType[blockType]
end

function blockService:canDestroy(pos: Vector3int16 | string): boolean
	if typeof(pos) == "Vector3int16" then
		pos = posToStr(pos)
	end
	
	return not (self.blocks[pos].owner == '0') -- If the block's owned by the server, it can't be removed.
end

function blockService:checkBlockInDir(origin: Vector3int16, direction: Vector3int16)
	local dirToStr = posToStr(direction + origin)
	
	return self.blocks[dirToStr]
end

function blockService:getNeighbouringBlocks(block: block, airFlag: boolean)
	local neighbours = {}
	local air = {}
	
	for i=0,2 do
		for j=0,2 do
			for k=0,2 do
				local pos = block.pos + Vector3int16.new(i-1,j-1,k-1)
				local strPos = posToStr(pos)
				
				if self.blocks[strPos] then
					table.insert(neighbours,self.blocks[strPos])
				elseif airFlag == true then
					if boundCheck(pos) == false then
						table.insert(air, pos)
					end
				end
			end
		end
	end
	
	return neighbours, air
end

function blockService:init()
	return
end

function blockService.newRegistry(): blockRegistry
	local self: blockRegistry = setmetatable({}, blockService)
	
	self:init()
	
	return self
end


return blockService
