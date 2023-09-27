extends Node2D
class_name WeaponManager

@onready var hud = get_tree().get_root().get_node("Game/HUD")

var current_weapon: Node2D
var weapons: Array = []  # This will store all the weapon nodes

func _ready():
	# Assuming all weapon nodes are children of this manager
	for child in get_children():
		if child is BaseGun or child is Shotgun: 
			weapons.append(child)
			child.hide()  # Hide all weapons initially

	# Set the default weapon
	if weapons.size() > 0:
		set_current_weapon(weapons[0])


func handle_input():
	if Input.is_action_just_pressed('attack') and not current_weapon.is_reloading:
		if current_weapon is BaseGun:
			current_weapon.shoot_bullet()
		elif current_weapon is Shotgun:
			current_weapon.shoot_shotgun()
	elif Input.is_action_just_pressed('reload') and not current_weapon.is_reloading:
		current_weapon.start_reloading()
	elif Input.is_action_just_pressed("switch_weapon"):
		print("switch")
		switch_to_next_weapon()


func set_current_weapon(weapon: Node2D):
	if current_weapon:
		current_weapon.hide()
	current_weapon = weapon
	current_weapon.show()
	hud.update_ammo(current_weapon.current_ammo, current_weapon.gun_data.gun_properties.ammo_capacity)


func switch_to_next_weapon():
	var index = weapons.find(current_weapon)
	
	
	if index != -1:
		current_weapon.hide()
	index = (index + 1) % weapons.size()
	current_weapon = weapons[index]
	current_weapon.show()
	hud.update_ammo(current_weapon.current_ammo, current_weapon.gun_data.gun_properties.ammo_capacity)	

