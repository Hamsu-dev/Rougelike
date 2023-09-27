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
	elif body.has_method("take_damage"):
		body.take_damage(hitbox_component.damage, hitbox_component.knockback_direction, hitbox_component.knockback_force)
		queue_free()

