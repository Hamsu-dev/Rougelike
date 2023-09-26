extends Node
class_name HealthComponent

signal took_damage(current_health)
signal died

@export var max_health: float = 10
var current_health


func _ready():
	current_health = max_health

func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	emit_signal("took_damage", current_health)
	if current_health == 0:
		died.emit()
		owner.queue_free()
