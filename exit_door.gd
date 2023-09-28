extends Area2D

signal leaving_level

func _on_body_entered(body):
	print("Body entered")  # Add this line to check if this function is being called
	emit_signal("leaving_level")
