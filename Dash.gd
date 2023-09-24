extends Node2D

@onready var dash_timer = $DashTimer


func start_dash(duration):
	dash_timer.wait_time = duration
	dash_timer.start()


func is_dashing():
	return !dash_timer.is_stopped()
