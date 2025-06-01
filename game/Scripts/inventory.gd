extends Control
@onready var inventory: Control = $"."



@onready var weapon_name: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponName
@onready var weapon_img: TextureRect = $MainLayout/HBoxContainer/DetailsPanel/WeaponImg
@onready var descriptions: RichTextLabel = $MainLayout/HBoxContainer/DetailsPanel/Descriptions
@onready var weapon_type: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponType
@onready var weapon_mag: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMag
@onready var weapon_dmg: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponDMG
@onready var weapon_max_mag: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMaxMag
@onready var weapon_fire_rate: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponFireRate
@onready var weapon_reload: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponReload
@onready var weapon_1: Button = $MainLayout/HBoxContainer/WeaponListPanel/GridContainer/Weapon1
@onready var weapon_2: Button = $MainLayout/HBoxContainer/WeaponListPanel/GridContainer/Weapon2
@onready var weapon_3: Button = $MainLayout/HBoxContainer/WeaponListPanel/GridContainer/Weapon3


var weapon_data = {
	"VK-PDW": {
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-PDW (QBZ191+X95 HYBRID).png"),
		"type": "SMG",
		"damage": 26,
		"fire_rate": "850 RPM",
		"mag_size": 40,
		"max_reserve": 240,
		"reload_time": 2.9,
		"description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
	},
		"VK-V9": {
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-V9 (QBZ191+X95 HYBRID).png"),
		"type": "SMG",
		"damage": 26,
		"fire_rate": "850 RPM",
		"mag_size": 40,
		"max_reserve": 240,
		"reload_time": 2.9,
		"description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
	},
	# Add other weapons similarly
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # allows processing when paused
	visible = false
	
func _input(event):
	if event.is_action_pressed("Inventory"):
		inventory.visible = !inventory.visible

		if inventory.visible:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func show_weapon_info(weapon_id: String):
	var data = weapon_data[weapon_id]
	weapon_name.text = weapon_id
	weapon_img.texture = data["thumbnail"]
	weapon_dmg.text = "Damage: %s" % data["damage"]
	weapon_fire_rate.text = "Fire Rate: %s" % data["fire_rate"]
	weapon_mag.text = "Mag Size: %s" % data["mag_size"]
	weapon_max_mag.text = "Max Reserve: %s" % data["max_reserve"]
	weapon_reload.text = "Reload Time: %s" % data["reload_time"]
	# Add other stats...
	descriptions.text = data["description"]


func _on_weapon_1_pressed() -> void:
	weapon_1.pressed.connect(func(): show_weapon_info("VK-PDW"))


func _on_weapon_2_pressed() -> void:
	weapon_2.pressed.connect(func(): show_weapon_info("VK-V9"))


func _on_weapon_3_pressed() -> void:
	pass # Replace with function body.
