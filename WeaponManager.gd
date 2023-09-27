extends Node2D
class_name WeaponManager

var current_weapon: Node2D
var weapons: Array = []  # This will store all the weapon nodes

func _ready():
	# Assuming all weapon nodes are children of this manager
	for child in get_children():
		if child is BaseGun:
			weapons.append(child)
			child.hide()  # Hide all weapons initially

	# Set the default weapon
	if weapons.size() > 0:
		set_current_weapon(weapons[0])

func set_current_weapon(weapon: Node2D):
	if current_weapon:
		current_weapon.hide()
	current_weapon = weapon
	current_weapon.show()

func switch_to_next_weapon():
	var index = weapons.find(current_weapon)
	index = (index + 1) % weapons.size()
	set_current_weapon(weapons[index])

# Add more functions as needed, like switch_to_previous_weapon, add_weapon, etc.
