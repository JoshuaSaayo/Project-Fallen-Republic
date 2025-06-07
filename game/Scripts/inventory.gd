extends Control
## Inventory system for a top-down shooter game

# UI References
@onready var weapon_name: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponName
@onready var weapon_img: TextureRect = $MainLayout/HBoxContainer/DetailsPanel/WeaponImg
@onready var descriptions: RichTextLabel = $MainLayout/HBoxContainer/DetailsPanel/Descriptions
@onready var weapon_type: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponType
@onready var weapon_mag: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMag
@onready var weapon_dmg: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponDMG
@onready var weapon_max_mag: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMaxMag
@onready var weapon_fire_rate: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponFireRate
@onready var weapon_reload: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponReload

@onready var weapon_buttons := [
	$MainLayout/HBoxContainer/WeaponListPanel/GridContainer/Weapon1,
	$MainLayout/HBoxContainer/WeaponListPanel/GridContainer/Weapon2,
	$MainLayout/HBoxContainer/WeaponListPanel/GridContainer/Weapon3
]

# Weapon data
const WEAPON_INDEX_MAP := {
	0: "vk-pdw",
	1: "vk-v9",
	2: "kp-12"
}

var selected_index := -1  # -1 means nothing selected

const WEAPON_DATA := {
	"vk-pdw": {
		"display_name": "VK-PDW",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-PDW (QBZ191+X95 HYBRID).png"),
		"type": "SMG",
		"damage": 24,
		"fire_rate": "850 RPM",
		"mag_size": 40,
		"max_reserve": 140,
		"reload_time": 2.0,
		"description": "A compact PDW tailored for CQC operations in dense urban zones. Derived from the VK-V9 rifle family with modular internals. Lightweight, accurate, and perfect for fast engagements. Favored by recon troops and security units."
	},
	"vk-v9": {
		"display_name": "VK-V9",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-V9 (QBZ191+X95 HYBRID).png"),
		"type": "SMG",
		"damage": 30,
		"fire_rate": "720 RPM",
		"mag_size": 30,
		"max_reserve": 120,
		"reload_time": 2.4,
		"description": "A modular battle rifle platform built for adaptability in both jungle warfare and urban assaults. Balanced recoil and good weight distribution make it easy to handle. Built on lessons from captured foreign designs. Durable, field-ready, and widely deployed."
	},
	"kp-12": {
		"display_name": "KP-12",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/KP-12 Chetrra [TT-33 Tokarev].png"),
		"type": "Pistol",
		"damage": 28,
		"fire_rate": "300 RPM",
		"mag_size": 8,
		"max_reserve": 40,
		"reload_time": 1.8,
		"description": "Compact and durable, the KP-12 is a sidearm with a long history of military service. It sacrifices magazine capacity for ease of concealment and reliability. Ideal for officers and backup roles. Snappy recoil and low profile"
	}
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Process even when game is paused
	visible = false
	
	# Connect weapon buttons
	for i in weapon_buttons.size():
		weapon_buttons[i].pressed.connect(_on_weapon_button_pressed.bind(i))
	
	update_weapon_buttons()

#region Input Handling
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		toggle_inventory()

func toggle_inventory() -> void:
	visible = !visible
	
	if visible:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		restore_crosshair()
#endregion

#region Weapon Display
func show_weapon_info(weapon_id: String) -> void:
	var data = WEAPON_DATA.get(weapon_id, {})
	if data.is_empty():
		return
	
	weapon_name.text = data.get("display_name", weapon_id)
	weapon_img.texture = data.get("thumbnail", null)
	weapon_type.text = "Type: %s" % data.get("type", "N/A")
	weapon_dmg.text = "Damage: %s" % data.get("damage", 0)
	weapon_fire_rate.text = "Fire Rate: %s" % data.get("fire_rate", "N/A")
	weapon_mag.text = "Mag Size: %s" % data.get("mag_size", 0)
	weapon_max_mag.text = "Max Reserve: %s" % data.get("max_reserve", 0)
	weapon_reload.text = "Reload Time: %s" % data.get("reload_time", 0)
	descriptions.text = data.get("description", "")
#endregion

#region Button Handlers
func _on_weapon_button_pressed(index: int) -> void:
	var weapon_id = WEAPON_INDEX_MAP.get(index, "")
	if weapon_id.is_empty() || !WEAPON_DATA.has(weapon_id):
		return
	
	show_weapon_info(weapon_id)
	selected_index = index

func _on_equip_btn_pressed() -> void:
	if selected_index == -1:
		return
	
	var weapon_id = WEAPON_INDEX_MAP.get(selected_index, "")
	if weapon_id.is_empty():
		return
	
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("equip_weapon"):
		player.equip_weapon(weapon_id)
		close_inventory()

func _on_close_btn_pressed() -> void:
	close_inventory()
#endregion

#region Utility Functions
func update_weapon_buttons() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		return
	
	for i in weapon_buttons.size():
		var weapon_id = WEAPON_INDEX_MAP.get(i, "")
		weapon_buttons[i].visible = player.available_weapons.has(weapon_id) if weapon_id else false

func close_inventory() -> void:
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	restore_crosshair()

func restore_crosshair() -> void:
	var crosshairs = get_tree().get_nodes_in_group("Crosshair")
	if crosshairs.is_empty():
		return
	
	var crosshair = crosshairs[0]
	crosshair.visible = true
	if crosshair.has_method("show_crosshair"):
		crosshair.show_crosshair()
#endregion
