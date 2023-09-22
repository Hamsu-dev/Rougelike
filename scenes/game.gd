extends Node


func _init():
	var screen_size: Vector2 = 
	OS.get_screen_size()
	var window_size: Verctor2 = 
	OS.get_window_size()
	
	
	OS.set_window_position(screen_size * 0.5 - window_size * 50)
