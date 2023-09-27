extends CanvasLayer

@onready var ammo_label = $AmmoLabel
@onready var reload_label = $ReloadLabel

func _ready():
	reload_label.hide()

func update_ammo(current_ammo, max_ammo):
	if current_ammo == 0:
		ammo_label.text = "Reload!"
	else:
		ammo_label.text = "Ammo: %s/%s" % [current_ammo, max_ammo]

func show_reloading():
	ammo_label.text = "Reloading..."
	reload_label.show()

func hide_reloading():
	reload_label.hide()
