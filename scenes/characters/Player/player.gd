@icon("res://assets/Dungeons Assets/heroes/knight/knight_idle_anim_f0.png")
extends Character

@onready var sword: Node2D = get_node('Sword')
@onready var sword_animation_player: AnimationPlayer = sword.get_node('SwordAnimationPlayer')

func _process(_delta: float):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	if Input.is_action_just_pressed('attack') and not sword_animation_player.is_playing():
		sword_animation_player.play('attack')

	sword.rotation = mouse_direction.angle()
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1

func get_input():
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_axis("left", "right")
	move_direction.y = Input.get_axis("up", "down")
