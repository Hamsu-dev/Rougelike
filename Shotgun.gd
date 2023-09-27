extends Node2D

func _ready():
	# Get the GunData resource
	var gun_data = preload("res://data/GunData.gd").instance()

	# Check if it's a ShotgunProperties instance
	if gun_data is GunData.ShotgunProperties:
		# Cast it to the ShotgunProperties class
		var shotgun_properties = gun_data as GunData.ShotgunProperties

		# Now you can access the shotgun's properties and use them as needed
		var shotgun_name = shotgun_properties.gun_name
		var shotgun_damage = shotgun_properties.damage
		var shotgun_ammo_capacity = shotgun_properties.ammo_capacity
		var shotgun_reload_time = shotgun_properties.reload_time

		# You can also print these values to verify
		print("Shotgun Name:", shotgun_name)
		print("Shotgun Damage:", shotgun_damage)
		print("Shotgun Ammo Capacity:", shotgun_ammo_capacity)
		print("Shotgun Reload Time:", shotgun_reload_time)
	else:
		print("This gun is not a shotgun.")
