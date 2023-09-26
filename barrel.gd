extends RigidBody2D
class_name Barrel

@export var PICKUP_SCENE: PackedScene

func destroy_barrel():
	queue_free()
	var pickup: Pickup = PICKUP_SCENE.instantiate()
	pickup.global_position = global_position
	get_parent().add_child(pickup)
