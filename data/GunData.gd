extends Resource
class_name GunData

# Default gun properties
class DefaultGunProperties:
	var gun_name: String = "Default Gun"
	var damage: int = 2
	var ammo_capacity: int = 10
	var reload_time: float = 2.0

# Shotgun properties
class ShotgunProperties:
	var gun_name: String = "Shotgun"
	var damage: int = 10
	var ammo_capacity: int = 2
	var reload_time: float = 3.5

# Instantiate the default gun properties by default
var gun_properties = DefaultGunProperties.new()
