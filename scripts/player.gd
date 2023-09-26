@icon("res://assets/Dungeons Assets/heroes/knight/knight_idle_anim_f0.png")
extends Character
class_name Player

@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var particles = $GPUParticles2D
@onready var weapons = $Weapons
@onready var gun1_sprite = $Weapons/Node2D/Sprite2D
@onready var sword: Node2D = get_node('Sword')
@onready var sword_animation_player: AnimationPlayer = sword.get_node('SwordAnimationPlayer')
@onready var hitbox_component = $Sword/Node2D/Sprite2D/HitboxComponent


const GUN2_OFFSET = Vector2(-30, 0)  # Adjust these values as needed
const MAX_SPEED = 60  # Adjust the speed as needed
const GUN_RADIUS = 10 # Adjust the radius of the circular range


func _ready():
	sword.visible = false


func _process(delta: float):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	global_position += move_direction * MAX_SPEED * delta
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	if Input.is_action_just_pressed('melee') and not sword_animation_player.is_playing():
		sword.visible = true
		sword_animation_player.play('melee')
		sword_animation_player.animation_finished.connect(_on_sword_animation_player_animation_finished)


	sword.rotation = mouse_direction.angle()
	hitbox_component.knockback_direction = mouse_direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
		
func get_input():
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_axis("left", "right")
	move_direction.y = Input.get_axis("up", "down")


func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $AnimatedSprite2D.scale)
	get_tree().current_scene.add_child(ghost)
 
 
func _on_ghost_timer_timeout():
	add_ghost()
 
func dash():
	ghost_timer.start()
	particles.emitting = true
 
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + velocity * 1.5, 0.45)
 
	await tween.finished
	ghost_timer.stop()
	particles.emitting = false


func _input(event):
	if event is InputEventMouseMotion:
		# Get the mouse position in global coordinates
		var mouse_pos = get_global_mouse_position()

		# Calculate the direction from the character to the mouse
		var direction = (mouse_pos - global_position).normalized()

		# Calculate the weapon position within the circular range for the first gun sprite
		var gun1_position = global_position + direction * GUN_RADIUS
		gun1_sprite.global_position = gun1_position
		gun1_sprite.look_at(mouse_pos)

		# Adjust the sprite scaling based on the mouse position relative to the first gun sprite (or adjust as needed)
		if mouse_pos.x < gun1_sprite.global_position.x:
			gun1_sprite.scale = Vector2(1, -1)
		elif mouse_pos.x > gun1_sprite.global_position.x:
			gun1_sprite.scale = Vector2(1, 1)

	if event.is_action_pressed("dash"):
		dash()


func _on_sword_animation_player_animation_finished(animation_name: String):
	if animation_name == "melee":
		sword.visible = false
