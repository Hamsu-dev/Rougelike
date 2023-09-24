extends Node2D
@onready var marker_2d = $Node2D/Sprite2D/Marker2D

@onready var bulletScene = preload("res://scenes/Bullet.tscn")
var mouse_pressed = false

func _ready():
	pass

func _unhandled_input(_event):
	if Input.is_action_pressed('attack'):
		mouse_pressed = true
		
	if Input.is_action_just_released('attack') and mouse_pressed:
		var bullet = bulletScene.instantiate() as Node2D
		var root = get_tree().get_root() 
		root.add_child(bullet)
		bullet.global_position = marker_2d.global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		bullet.rotation = bullet.direction.angle()
		mouse_pressed = false
