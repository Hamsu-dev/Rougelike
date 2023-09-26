@icon("res://assets/Dungeons Assets/enemies/Wolf/wolf.png")
extends Character
class_name Enemies

@onready var player: CharacterBody2D = get_tree().current_scene.get_node('Player')
@onready var path_timer: Timer = get_node('PathTimer')
@onready var navigation_agent: NavigationAgent2D = get_node('NavigationAgent2D')
@onready var health_component: HealthComponent = $HealthComponent

func _ready():
	health_component.took_damage.connect(_on_took_damage)
	animated_sprite.animation_finished.connect(_on_animation_player_animation_finished)

func chase() -> void:
	if not navigation_agent.is_target_reached():
		var vector_to_next_point: Vector2 = navigation_agent.get_next_path_position() - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		move_direction = vector_to_next_point

		if vector_to_next_point.x > 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true
		elif vector_to_next_point.x < 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		

func _get_path_to_player() -> void:
	navigation_agent.target_position = player.position


func _on_path_timer_timeout():
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		move_direction = Vector2.ZERO

func _on_took_damage(current_health: float):
	print(current_health)
	if current_health > 0:
		animated_sprite.play("hurt")
	else:
		animated_sprite.stop()
		animated_sprite.play("die")
		print("Trying to play die animation")


func _on_animation_player_animation_finished(animation_name: String):
	if animation_name == "die":
		queue_free() 
