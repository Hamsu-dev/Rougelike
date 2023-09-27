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

var can_fire: bool = true
var time_since_last_shot: float = 0.0


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
		
	if !can_fire:
		time_since_last_shot += delta

	if time_since_last_shot >= gun_data.gun_properties.fire_rate:
		can_fire = true
		time_since_last_shot = 0.0  # Reset the time since the last shot


func shoot_shotgun():
	if can_fire and current_ammo > 0:	
		var pellets_to_shoot = min(current_ammo, SHOTGUN_PELLETS)  # Calculate how many pellets to shoot, limited by remaining ammo
		for i in range(pellets_to_shoot):
			var bullet = bulletScene.instantiate() as Bullet
			get_parent().add_child(bullet)

			# Calculate direction with a random spread
			var random_angle = deg_to_rad(randf() * SHOTGUN_SPREAD - SHOTGUN_SPREAD / 2)
			var direction = (get_global_mouse_position() - global_position).rotated(random_angle).normalized()

			bullet.global_position = shot_gun_marker_2d.global_position
			bullet.direction = direction
			bullet.hitbox_component.damage = gun_data.gun_properties.damage

		current_ammo -= pellets_to_shoot  # Deduct the appropriate number of pellets based on remaining ammo
		if current_ammo < 0:
			current_ammo = 0
		hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)
		can_fire = false  # Set to false to enforce fire rate delay


func start_reloading():
	is_reloading = true
	await get_tree().create_timer(gun_data.gun_properties.reload_time).timeout
	current_ammo = gun_data.gun_properties.ammo_capacity
	is_reloading = false
	hud.update_ammo(current_ammo, gun_data.gun_properties.ammo_capacity)
	hud.hide_reloading()
