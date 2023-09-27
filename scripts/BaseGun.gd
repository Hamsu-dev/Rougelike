extends Node2D
class_name BaseGun

@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@export var gun_data: GunData
@onready var hud = get_tree().get_root().get_node("Game/HUD")
@onready var gun_sprite = $Node2D/BaseGun2D
@onready var base_gun_marker_2d = $Node2D/BaseGun2D/BaseGunMarker2D


var current_ammo: int
var is_reloading: bool = false
var mouse_pressed = false

const GUN_RADIUS = 10 # Adjust the radius of the circular range

# Fire rate variables
var can_fire: bool = true
var time_since_last_shot: float = 0.0


func _ready():
	if gun_data:
		current_ammo = gun_data.gun_properties.ammo_capacity
		hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)  # Update ammo count on HUD on initialization
	else:
		print("Warning: gun_data is not assigned!")

func _process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	rotation = mouse_direction.angle()

	# Calculate the weapon position within the circular range
	var gun_position = global_position + mouse_direction * GUN_RADIUS
	gun_sprite.global_position = gun_position
	gun_sprite.look_at(get_global_mouse_position())

	# Adjust the sprite scaling based on the mouse position relative to the gun sprite
	if get_global_mouse_position().x < gun_sprite.global_position.x:
		gun_sprite.scale = Vector2(1, -1)
	elif get_global_mouse_position().x > gun_sprite.global_position.x:
		gun_sprite.scale = Vector2(1, 1)

# Update time since the last shot
	if !can_fire:
		time_since_last_shot += delta

	# Check if the gun can fire again based on the fire rate
	if time_since_last_shot >= gun_data.gun_properties.fire_rate:
		can_fire = true
		time_since_last_shot = 0.0

func shoot_bullet():
	if can_fire and current_ammo > 0:
		var bullet = bulletScene.instantiate() as Bullet
		var root = get_tree().get_root() 
		root.add_child(bullet)
		bullet.global_position = get_bullet_spawn_position()
		bullet.hitbox_component.damage = gun_data.gun_properties.damage
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		bullet.rotation = bullet.direction.angle()
		current_ammo -= 1
		hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)
		can_fire = false 


func get_bullet_spawn_position():
	return base_gun_marker_2d.global_position


func start_reloading():
	is_reloading = true
	await get_tree().create_timer(gun_data.gun_properties.reload_time).timeout
	current_ammo = gun_data.gun_properties.ammo_capacity
	is_reloading = false
	hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)  # Update ammo count on HUD after reloading
	hud.hide_reloading()
