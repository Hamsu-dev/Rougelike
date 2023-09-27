extends Area2D
class_name HitboxComponent

@export var damage: int = 2
@export var knockback_force: int = 300
@onready var collision_shape_2d = $CollisionShape2D

var knockback_direction: Vector2 = Vector2.ZERO

func _init() -> void:
	var __ = body_entered.connect(_on_body_entered)
	
func _ready() -> void:
	assert(collision_shape_2d != null)
	
	
func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, knockback_direction, knockback_force)
