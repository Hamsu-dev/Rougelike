extends Area2D
class_name Bullet

@onready var hitbox_component: HitboxComponent = $HitboxComponent

const speed = 600
var direction = Vector2.ZERO
	
func _process(delta):
		position += direction.normalized() * speed * delta

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body is Barrel:
		body.destroy_barrel()
	queue_free()
