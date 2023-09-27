extends Resource
class_name GunData

# Default gun properties
class DefaultGunProperties:
	var gun_name: String = "Default Gun"
	var damage: int = 2
	var ammo_capacity: int = 30
	var reload_time: float = 2.0
	var fire_rate: float = 0.2 

# Shotgun properties
class ShotgunProperties:
	var gun_name: String = "Shotgun"
	var damage: int = 5
	var ammo_capacity: int = 20
	var reload_time: float = 4.0
	var fire_rate: float = 1.0
# Instantiate the default gun properties by default
var gun_properties = DefaultGunProperties.new()
