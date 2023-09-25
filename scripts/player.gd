@icon("res://assets/Dungeons Assets/heroes/knight/knight_idle_anim_f0.png")
extends Character

@onready var weapons = $Weapons
@onready var gun1_sprite = $Weapons/Node2D/Sprite2D
@onready var dash = $Dash



@onready var sword: Node2D = get_node('Sword')
@onready var sword_animation_player: AnimationPlayer = sword.get_node('SwordAnimationPlayer')

const GUN2_OFFSET = Vector2(-30, 0)  # Adjust these values as needed
const DASH_COOLDOWN = 10  # 1 second cooldown, adjust as needed
const DASH_SPEED = 800
const DASH_LENGTH = .05
const MAX_SPEED = 60  # Adjust the speed as needed
const GUN_RADIUS = 10 # Adjust the radius of the circular range

var last_dash_time = -DASH_COOLDOWN  # Initialize to allow dashing immediately
var last_print_time = 0

func _process(delta: float):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	global_position += move_direction * MAX_SPEED * delta
	
	if Input.is_action_just_pressed('dash') and Time.get_ticks_msec() - last_dash_time >= DASH_COOLDOWN * 1000:
		dash.start_dash(DASH_LENGTH)
		last_dash_time = Time.get_ticks_msec()
		
	var elapsed_time_since_last_dash = (Time.get_ticks_msec() - last_dash_time) / 1000.0  # Convert to seconds
	var remaining_time = max(0, DASH_COOLDOWN - elapsed_time_since_last_dash)
	if remaining_time > 0 and Time.get_ticks_msec() - last_print_time >= 1000:  # Check if at least 1 second has passed
		last_print_time = Time.get_ticks_msec()
	
	if dash.is_dashing():
		global_position += mouse_direction * DASH_SPEED * delta
#	var speed = DASH_SPEED if dash.is_dashing() else MAX_SPEED
	
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

