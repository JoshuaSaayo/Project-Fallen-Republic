extends Control
## Inventory system for a top-down shooter game

### Constants
const WEAPON_DATA := {
	"kp-12": {
		"display_name": "KP-12",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/KP-12_Chetrra.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/KP-12-PICKABLE.png"),
		"type": "PISTOL",
		"damage": 28,
		"fire_rate": "300 RPM",
		"mag_size": 8,
		"max_reserve": 40,
		"reload_time": 1.8,
		"description": "Compact and durable sidearm with a long history."
	},
	"ty-23": {
		"display_name": "TY-23",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/TY-23_Naginata.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/TY-23-PICKABLE.png"),
		"type": "PISTOL",
		"damage": 32,
		"fire_rate": "400 RPM",
		"mag_size": 15,
		"max_reserve": 60,
		"reload_time": 1.6,
		"description": "A semi-auto combat pistol with great accuracy and a reinforced slide. Inspired by traditional martial discipline and modern firearms tech. Lightweight, but kicks hard. A favorite among elite agents and SWAT operatives."
	},
	"vk-pdw": {
		"display_name": "VK-PDW",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-PDW.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/VK-PDW-PICKABLE.png"),
		"type": "SMG",
		"damage": 24,
		"fire_rate": "850 RPM",
		"mag_size": 40,
		"max_reserve": 140,
		"reload_time": 2.0,
		"description": "A compact PDW tailored for CQC operations in dense urban zones."
	},
	"kp-s13": {
		"display_name": "KP-S13",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/KP-S13_Prechan.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/KP-S13-PICKABLE.png"),
		"type": "SMG",
		"damage": 24,
		"fire_rate": "850 RPM",
		"mag_size": 40,
		"max_reserve": 140,
		"reload_time": 2.0,
		"description": "A rugged, utilitarian SMG made for military police and checkpoint patrols. Emphasizes reliability and burst suppression. Harsh recoil but simple internals make it easy to repair. A staple among frontier forces and smugglers."
	},
	"kr-85c1": {
		"display_name": "KR-85C1",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/KR-85C1_HK416.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/KR-85C1-PICKABLE.png"),
		"type": "ASSAULT",
		"damage": 34,
		"fire_rate": "680 RPM",
		"mag_size": 30,
		"max_reserve": 150,
		"reload_time": 2.6,
		"description": "Premium-class assault rifle used by elite forces and exported worldwide. Designed with tight tolerances and custom recoil buffering. Exceptionally stable under full-auto fire. Known for its reliability in harsh environments."
	},
	"vk-v9": {
		"display_name": "VK-V9",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-V9.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/VK-V9-PICKABLE.png"),
		"type": "ASSAULT",
		"damage": 30,
		"fire_rate": "720 RPM",
		"mag_size": 30,
		"max_reserve": 120,
		"reload_time": 2.4,
		"description": "A modular battle rifle platform built for adaptability."
	},
	"lp-07": {
		"display_name": "LP-07",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/LP-07.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/LP-07-PICKABLE.png"),
		"type": "SHOTGUN",
		"damage": 90,
		"fire_rate": "220 RPM",
		"mag_size": 12,
		"max_reserve": 48,
		"reload_time": 3.5,
		"description": "The LP-07 is a modular semi-automatic shotgun tailored for versatility in jungle and urban warfare. Its light polymer frame and adjustable stock make it ideal for mobile units. Frequently used by Kalayaan’s marines and APTO"
	},
	"tvr-10": {
		"display_name": "TVR-10",
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/TVR-10.png"),
		"weapon_thumbnail": preload("res://Assets/Guns/pickable_weapons/TVR-10-PICKABLE.png"),
		"type": "SHOTGUN",
		"damage": 105,
		"fire_rate": "220 RPM",
		"mag_size": 10,
		"max_reserve": 40,
		"reload_time": 3,
		"description": "A rugged, no-nonsense pump-action shotgun designed for urban breaching and riot control. Its integrated recoil compensator allows tight spread control even with heavy loads. A favorite among Tianshu riot police and special response forces. Though heavy, it's reliable and brutally effective at close range."
	}
}

### Nodes
@onready var details_panel = {
	"name": $MainLayout/HBoxContainer/DetailsPanel/WeaponName,
	"image": $MainLayout/HBoxContainer/DetailsPanel/WeaponImg,
	"description": $MainLayout/HBoxContainer/DetailsPanel/Descriptions
}

@onready var stats_panel = {
	"type": $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponType,
	"damage": $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponDMG,
	"mag_size": $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMag,
	"max_reserve": $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMaxMag,
	"fire_rate": $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponFireRate,
	"reload_time": $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponReload
}

@onready var grid_container: GridContainer = $MainLayout/HBoxContainer/WeaponListPanel/GridContainer
@onready var weapon_button_scene = preload("res://Scenes/UI/weapon_button.tscn")

### Variables
var selected_weapon_id: String = ""
var weapon_buttons := {}  # Dictionary to track created buttons

### Lifecycle Methods
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	initialize_inventory()
	grid_container.columns = 1  # Force single column layout
	grid_container.set("custom_constants/hseparation", 0)
	grid_container.set("custom_constants/vseparation", 10)  # Space between rows

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		toggle_inventory()

### Public Methods
func initialize_inventory() -> void:
	clear_weapon_list()
	
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		for weapon_id in player.available_weapons:
			add_weapon_to_list(weapon_id)

func add_weapon_to_list(weapon_id: String) -> void:
	if not WEAPON_DATA.has(weapon_id) or weapon_buttons.has(weapon_id):
		return
	
	var new_button = weapon_button_scene.instantiate()
	grid_container.add_child(new_button)
	
	# Configure elements
	var hbox = new_button.get_node("HBoxContainer")
	var thumbnail = hbox.get_node("WeaponThumbnail")
	var button = hbox.get_node("WeaponButton")
	
	# Size settings
	thumbnail.custom_minimum_size = Vector2(64, 64)  # Fixed thumbnail size
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	thumbnail.texture = WEAPON_DATA[weapon_id]["weapon_thumbnail"]
	button.text = WEAPON_DATA[weapon_id]["display_name"]
	button.pressed.connect(_on_weapon_button_pressed.bind(weapon_id))
	
	weapon_buttons[weapon_id] = new_button
	
	# Auto-select first weapon
	if selected_weapon_id.is_empty():
		_on_weapon_button_pressed(weapon_id)

### UI Methods
func toggle_inventory() -> void:
	visible = !visible
	
	if visible:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		initialize_inventory()  # Refresh inventory when opened
		hide_crosshair()
	else:
		close_inventory()

func hide_crosshair() -> void:
	var crosshairs = get_tree().get_nodes_in_group("Crosshair")
	if not crosshairs.is_empty():
		var crosshair = crosshairs[0]
		crosshair.visible = false
		if crosshair.has_method("hide_crosshair"):
			crosshair.hide_crosshair()
			
func close_inventory() -> void:
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	restore_crosshair()

func show_weapon_info(weapon_id: String) -> void:
	var data = WEAPON_DATA.get(weapon_id, {})
	if data.is_empty():
		return
	
	# Update details panel
	details_panel.name.text = data.get("display_name", weapon_id).to_upper()
	details_panel.image.texture = data.get("thumbnail", null)
	details_panel.description.text = data.get("description", "").to_upper()
	
	# Update stats panel
	stats_panel.type.text = "TYPE: %s" % data.get("type", "N/A").to_upper()
	stats_panel.damage.text = "DAMAGE: %s" % data.get("damage", 0)
	stats_panel.mag_size.text = "MAG SIZE: %s" % data.get("mag_size", 0)
	stats_panel.max_reserve.text = "MAX RESERVE: %s" % data.get("max_reserve", 0)
	stats_panel.fire_rate.text = "FIRE RATE: %s" % data.get("fire_rate", "N/A")
	stats_panel.reload_time.text = "RELOAD TIME: %s" % data.get("reload_time", 0)
	
	selected_weapon_id = weapon_id

### Helper Methods
func clear_weapon_list() -> void:
	for child in grid_container.get_children():
		child.queue_free()
	weapon_buttons.clear()

func restore_crosshair() -> void:
	var crosshairs = get_tree().get_nodes_in_group("Crosshair")
	if not crosshairs.is_empty():
		var crosshair = crosshairs[0]
		crosshair.visible = true
		if crosshair.has_method("show_crosshair"):
			crosshair.show_crosshair()

### Signal Handlers
func _on_weapon_button_pressed(weapon_id: String) -> void:
	show_weapon_info(weapon_id)

func _on_equip_btn_pressed() -> void:
	if selected_weapon_id.is_empty():
		return
	
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("equip_weapon"):
		player.equip_weapon(selected_weapon_id)
		close_inventory()

func _on_close_btn_pressed() -> void:
	close_inventory()
