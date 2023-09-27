@icon("res://assets/Dungeons Assets/heroes/knight/knight_idle_anim_f0.png")
extends Character
class_name Player

@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var particles = $GPUParticles2D
@onready var base_gun: Node2D = $WeaponManager/BaseGun/Node2D/BaseGun2D
@onready var sword: Node2D = get_node('Sword')
@onready var sword_animation_player: AnimationPlayer = sword.get_node('SwordAnimationPlayer')
@onready var hitbox_component = $Sword/Node2D/Sprite2D/HitboxComponent
@onready var weapon_manager = $WeaponManager
@onready var shotgun: Node2D = $WeaponManager/Shotgun


const MAX_SPEED = 60  # Adjust the speed as needed

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
		
	if Input.is_action_pressed("dash"):
		dash()
	weapon_manager.handle_input()
		
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


func _on_sword_animation_player_animation_finished(anim_name):
	if anim_name == "melee":
		sword.visible = false
