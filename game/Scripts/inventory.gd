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

# Map button indices to weapon IDs
var weapon_index_map = {
	0: "vk-pdw",
	1: "vk-v9",
	2: "kp-12"  # Add more as needed
}

var selected_index := -1  # Default = nothing selected

var weapon_data = {
	"VK-PDW": {
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-PDW (QBZ191+X95 HYBRID).png"),
		"type": "SMG",
		"damage": 24,
		"fire_rate": "850 RPM",
		"mag_size": 40,
		"max_reserve": 140,
		"reload_time": 2.0,
		"description": "A compact PDW tailored for CQC operations in dense urban zones. Derived from the VK-V9 rifle family with modular internals. Lightweight, accurate, and perfect for fast engagements. Favored by recon troops and security units."
	},
		"VK-V9": {
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-V9 (QBZ191+X95 HYBRID).png"),
		"type": "SMG",
		"damage": 30,
		"fire_rate": "720 RPM",
		"mag_size": 30,
		"max_reserve": 120,
		"reload_time": 2.4,
		"description": "A modular battle rifle platform built for adaptability in both jungle warfare and urban assaults. Balanced recoil and good weight distribution make it easy to handle. Built on lessons from captured foreign designs. Durable, field-ready, and widely deployed."
	},
		"KP-12": {
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/KP-12 Chetrra [TT-33 Tokarev].png"),
		"type": "Pistol",
		"damage": 28,
		"fire_rate": "300 RPM",
		"mag_size": 8,
		"max_reserve": 40,
		"reload_time": 1.8,
		"description": "Compact and durable, the KP-12 is a sidearm with a long history of military service. It sacrifices magazine capacity for ease of concealment and reliability. Ideal for officers and backup roles. Snappy recoil and low profile"
	},
	# Add other weapons similarly
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # allows processing when paused
	visible = false
	
	weapon_1.pressed.connect(_on_weapon_button_pressed.bind(0))
	weapon_2.pressed.connect(_on_weapon_button_pressed.bind(1))
	weapon_3.pressed.connect(_on_weapon_button_pressed.bind(2))
	
func _on_weapon_button_pressed(index: int) -> void:
	var weapon_id = weapon_index_map.get(index, "")
	if weapon_id != "" and weapon_data.has(weapon_id):
		show_weapon_info(weapon_id)
		selected_index = index
		
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

func _on_weapon_selected(index: int) -> void:
	selected_index = index
	# You can also update the DetailsPanel here

func _on_weapon_1_pressed() -> void:
	show_weapon_info("VK-PDW")
	selected_index = 0  # Assuming this is index 0


func _on_weapon_2_pressed() -> void:
	show_weapon_info("VK-V9")
	selected_index = 1  # Assuming this is index 


func _on_weapon_3_pressed() -> void:
	show_weapon_info("KP-12")
	selected_index = 1  # Assuming this is index 


func _on_equip_btn_pressed() -> void:
	if selected_index != -1:
		var weapon_id = weapon_index_map.get(selected_index, "")
		if weapon_id != "":
			var player = get_tree().get_first_node_in_group("Player")
			if player and player.has_method("equip_weapon"):
				player.equip_weapon(weapon_id)
				hide()
				get_tree().paused = false
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_close_btn_pressed() -> void:
	hide()  # Hide the inventory when the button is clicked
	get_tree().paused = false  # Resume the game if paused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Optional: recapture mouse
	
	var crosshairs = get_tree().get_nodes_in_group("Crosshair")
	if crosshairs.size() > 0:
		var crosshair = crosshairs[0]
		# Choose appropriate action:
		crosshair.visible = true  # If you just want to show it
		# OR if you need to call a specific function:
		if crosshair.has_method("show_crosshair"):
			crosshair.show_crosshair()

func update_weapon_buttons():
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		return
	
	weapon_1.visible = player.available_weapons.has("vk-pdw")
	weapon_2.visible = player.available_weapons.has("vk-v9")
	weapon_3.visible = false  # Set this based on your weapons
	
	# You might want to update thumbnails/text here too
