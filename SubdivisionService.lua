local PartDivisionService = {}

-- For documentation on how this works, see SubdivisionServiceTest

export type divSettings = {
	part: BasePart,
	divs: Vector3,
	startAnchored: boolean?,
	defaultParent: Instance?
}

local function createPartFromBasePart(part: BasePart, startAnchored)
	local newPart = Instance.new("Part")
	newPart.Anchored = startAnchored
	newPart.Color = part.Color
	newPart.Material = part.Material
	newPart.TopSurface = part.TopSurface
	newPart.BottomSurface = part.BottomSurface
	newPart.Transparency = part.Transparency
	newPart.AssemblyLinearVelocity = part.AssemblyLinearVelocity
	newPart.AssemblyAngularVelocity = part.AssemblyAngularVelocity
	
	return newPart
end

local function createRotatePart(size, sbdv)
	local rot_part = Instance.new("Part")
	rot_part.Anchored = true
	rot_part.Size = size	
	rot_part.Position = (size + size/sbdv)/2
	
	return rot_part	
end

local function newPartGroup(part, parent)
	local group = Instance.new("Model")
	group.Parent = ((parent == nil) and workspace) or parent
	group.Name = "Subdivided"..part.Name
	
	return group	
end

function PartDivisionService.SubdividePart(params: divSettings)
	assert(params.part ~= nil, "A part must be specified to be subdivided!")
	assert(typeof(params.divs) == "number" or typeof(params.divs) == "Vector3", "divs must be of type Vector3 or number!")
	
	local subdivisions: number | Vector3 = params.divs
	local part: BasePart = params.part
	local startAnchored: boolean? = params.startAnchored
	local defaultParent: Instance? = params.defaultParent
	
	if typeof(subdivisions) == "number" then
		assert(params.divs > 0, "Subdivisions cannot be zero!")
		subdivisions = params.divs*Vector3.one
	else
		assert(params.divs.x*params.divs.y > 0 and params.divs.x*params.divs.z > 0 and params.divs.y * params.divs.z > 0, "Subdivisions cannot be zero!")
	end
	
	local group = newPartGroup(part, defaultParent)
	local subdividedSize = part.Size/subdivisions
	
	for i=1, subdivisions.X do
		for j=1, subdivisions.Y do
			for k=1, subdivisions.Z do
				local newPart = createPartFromBasePart(part, startAnchored)
				newPart.Size = part.Size/subdivisions
				newPart.Parent = group
				newPart.Position = subdividedSize*Vector3.new(i,j,k)
			end														
		end
	end
	
	local rot_part = createRotatePart(part.Size, subdivisions)
	group.PrimaryPart = rot_part
	group:SetPrimaryPartCFrame(part.CFrame)
	rot_part:Destroy()
	
	return group	
end

return PartDivisionService
