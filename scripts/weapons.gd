extends Node2D

@onready var marker_2d = $Node2D/Sprite2D/Marker2D
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@onready var hud = get_tree().get_root().get_node("Game/HUD")
@export var damage: int = 2
@export var max_ammo: int = 10
@export var reload_time: float = 2.0


var current_ammo: int = max_ammo
var is_reloading: bool = false
var mouse_pressed = false


func _unhandled_input(_event):
	if Input.is_action_pressed('attack') and not is_reloading:
		mouse_pressed = true

	if Input.is_action_just_released('attack') and mouse_pressed and not is_reloading:
		if current_ammo > 0:
			shoot_bullet()
			current_ammo -= 1

		mouse_pressed = false
		hud.update_ammo(current_ammo, max_ammo)

	if Input.is_action_just_released('reload') and not is_reloading:
		start_reloading()
		hud.show_reloading()
		
		
func shoot_bullet():
	var bullet = bulletScene.instantiate() as Bullet
	var root = get_tree().get_root() 
	root.add_child(bullet)
	bullet.hitbox_component.damage = damage
	bullet.global_position = marker_2d.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = bullet.direction.angle()

func start_reloading():
	is_reloading = true
	await get_tree().create_timer(reload_time).timeout
	current_ammo = max_ammo
	is_reloading = false
	hud.update_ammo(current_ammo, max_ammo)
	hud.hide_reloading()
