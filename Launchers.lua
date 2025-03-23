local Guns = {}

Guns.default = {
	startVelocity = 550,
	Callback = function(projectile, hit_position, velocity, collisions)
		print("Hit")
		
		projectile:Destroy()
	end,
}

return Guns
