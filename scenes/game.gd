extends Node2D

var borders = Rect2(1, 1, 60, 40)
const Player = preload("res://scenes/characters/Player/player.tscn")
const Exit = preload("res://exit_door.tscn")
@onready var tile_map = $NavigationRegion2D/TileMap


func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker_Map.new(Vector2(19, 11), borders)
	var map = walker.walk(500)
	
	var player = Player.instantiate()
	add_child(player)
	player.position = map.front()*32
	
	var exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position * 32
	exit.leaving_level.connect(reload_level)
	
	walker.queue_free()
	var cells = []
	for location in map:
		cells.append(location)
	tile_map.set_cells_terrain_connect(0, cells, 0, -1)


func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("enter"):
		reload_level()
