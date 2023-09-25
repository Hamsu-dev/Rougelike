extends CharacterBody2D
class_name Bullet

@onready var hitbox_component: HitboxComponent = $HitboxComponent

const speed = 600
var direction = Vector2.ZERO
	
func _process(delta):
	var collisionResult = move_and_collide(direction * speed * delta)
	if collisionResult != null:
		queue_free()

func _on_timer_timeout():
	queue_free()
