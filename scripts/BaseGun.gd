extends Node2D
class_name BaseGun

@onready var marker_2d = $Node2D/Sprite2D/Marker2D
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@export var gun_data: GunData
@onready var hud = get_tree().get_root().get_node("Game/HUD")
@onready var gun_sprite = $Node2D/Sprite2D



var current_ammo: int
var is_reloading: bool = false
var mouse_pressed = false

const GUN_RADIUS = 10 # Adjust the radius of the circular range

func _ready():
	# Load properties from the GunData resource
	if gun_data:
		current_ammo = gun_data.ammo_capacity
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


func _unhandled_input(_event):
	if Input.is_action_pressed('attack') and not is_reloading:
		mouse_pressed = true

	if Input.is_action_just_released('attack') and mouse_pressed and not is_reloading:
		if current_ammo > 0:
			shoot_bullet()
			current_ammo -= 1

		mouse_pressed = false
		hud.update_ammo(current_ammo, gun_data.ammo_capacity)

	if Input.is_action_just_released('reload') and not is_reloading:
		start_reloading()
		hud.show_reloading()
		
func shoot_bullet():
	var bullet = bulletScene.instantiate() as Bullet
	var root = get_tree().get_root() 
	root.add_child(bullet)
	bullet.hitbox_component.damage = gun_data.damage
	bullet.global_position = marker_2d.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = bullet.direction.angle()

func start_reloading():
	is_reloading = true
	await get_tree().create_timer(gun_data.reload_time).timeout
	current_ammo = gun_data.ammo_capacity
	is_reloading = false
	hud.update_ammo(current_ammo, gun_data.ammo_capacity)
	hud.hide_reloading()
