extends Node2D
class_name Shotgun

@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@export var gun_data: GunData
@onready var hud = get_tree().get_root().get_node("Game/HUD")
@onready var shot_gun_2d = $Node2D/ShotGun2D
@onready var shot_gun_marker_2d = $Node2D/ShotGun2D/ShotGunMarker2D

var current_ammo: int
var is_reloading: bool = false

const GUN_RADIUS = 10  # Same as BaseGun
const SHOTGUN_SPREAD = 30.0
const SHOTGUN_PELLETS = 6

func _ready():
	gun_data.gun_properties = gun_data.ShotgunProperties.new()  # Set the gun data to ShotgunProperties
	current_ammo = gun_data.gun_properties.ammo_capacity
	hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)  # Update ammo count on HUD on initialization

func _process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	rotation = mouse_direction.angle()

	# Calculate the weapon position within the circular range
	var gun_position = global_position + mouse_direction * GUN_RADIUS
	shot_gun_2d.global_position = gun_position
	shot_gun_2d.look_at(get_global_mouse_position())

	# Adjust the sprite scaling based on the mouse position relative to the shotgun sprite
	if get_global_mouse_position().x < shot_gun_2d.global_position.x:
		shot_gun_2d.scale = Vector2(1, -1)
	elif get_global_mouse_position().x > shot_gun_2d.global_position.x:
		shot_gun_2d.scale = Vector2(1, 1)


func shoot_shotgun():
	if current_ammo > 0:
		current_ammo -= 1
		hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)
	elif current_ammo < 0 or current_ammo == 0:
		start_reloading()
		
	for i in range(SHOTGUN_PELLETS):
		var bullet = bulletScene.instantiate()
		get_parent().add_child(bullet)

		# Calculate direction with a random spread
		var random_angle = deg_to_rad(randf() * SHOTGUN_SPREAD - SHOTGUN_SPREAD / 2)
		var direction = (get_global_mouse_position() - global_position).rotated(random_angle).normalized()

		bullet.global_position = shot_gun_marker_2d.global_position
		bullet.direction = direction
		bullet.hitbox_component.damage = gun_data.gun_properties.damage

func start_reloading():
	is_reloading = true
	await get_tree().create_timer(gun_data.gun_properties.reload_time).timeout
	current_ammo = gun_data.gun_properties.ammo_capacity
	is_reloading = false
	hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)
	hud.hide_reloading()
