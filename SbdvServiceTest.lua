local Poort = workspace:FindFirstChild("Poort")
local Poort2 = workspace:FindFirstChild("Poort2")
local SbdService = require(script.Parent.Parent.Services.SubdivisionService)
--SbdService.SubdividePart(Poort)

task.wait(1)
local SbdSettings = {}
SbdSettings.part = Poort
SbdSettings.divs = Vector3.new(1,7,7)
SbdSettings.startAnchored = false

SbdService.SubdividePart(SbdSettings)
Poort:Destroy()

SbdSettings.part = Poort2
SbdSettings.divs = Vector3.new(2,2,2)*2
SbdSettings.startAnchored = false

SbdService.SubdividePart(SbdSettings)
Poort2:Destroy()
