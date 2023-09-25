extends CharacterBody2D

const speed = 600
var direction = Vector2.ZERO
	
func _process(delta):
	move_and_collide(direction * speed * delta)

func _on_timer_timeout():
	queue_free()
