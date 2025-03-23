local ProjectileService = require(script.Parent.Parent.Services.ProjectileService)
local GunTypes = require(script.Parent.Parent.Configs.Launchers)
local AmmoTypes = require(script.Parent.Parent.Configs.Projectiles)
local proj = ProjectileService.createLauncher("default", "762_39_fmj")

for i=1, 512 do
	proj:fire(Vector3.new(0,5,0), Vector3.new(0,0,1))
	task.wait(0.1)
end