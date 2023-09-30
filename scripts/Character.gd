@icon("res://assets/Dungeons Assets/heroes/knight/knight_idle_anim_f0.png")
extends CharacterBody2D
class_name Character

const FRICTION: float = 0.15
@export var hp: int = 10
@export var acceleration: int = 30
@export var max_speed: int = 50

@onready var state_machine: Node = get_node('FiniteStateMachine')
@onready var animated_sprite: AnimatedSprite2D = get_node('AnimatedSprite2D')

var move_direction: Vector2 = Vector2.ZERO


func _physics_process(_delta):
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	

func move():
	move_direction = move_direction.normalized() 
	velocity += move_direction * acceleration
	velocity = velocity.limit_length(max_speed)


func take_damage(dam: int, dir: Vector2, force: int) -> void:
	hp -= dam
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += dir * force
	elif hp <= 0:
		state_machine.set_state(state_machine.states.die)
		velocity += dir * force * 2
