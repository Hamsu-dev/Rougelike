extends Area2D
class_name Bullet

#@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_component = $HitboxComponent

const speed = 600
var direction = Vector2.ZERO
	
func _process(delta):
		position += direction.normalized() * speed * delta

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body is Barrel:
		body.destroy_barrel()
	elif body.has_node("HitboxComponent"):
		var hitbox = body.get_node("HitboxComponent")
		hitbox.knockback_direction = direction # Set the direction of knockback
		hitbox._on_body_entered(body) # Apply damage
	queue_free()
