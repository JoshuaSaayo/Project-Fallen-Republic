extends CharacterBody2D

signal life_value

@onready var weapon_label: Label = $CanvasLayer/HBoxContainer/WeaponLabel
@onready var ammo_label: Label = $CanvasLayer/HBoxContainer/AmmoLabel
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var weapon_slot: Node = $WeaponSlot

var max_health := 100
var current_health := max_health
var movespeed := 200
var current_weapons := {}  # Dictionary to store all weapon instances
var current_weapon_id: String = ""
var available_weapons := {
	"kp-12": true  # Player starts with KP-12
}
var inventory := {
	# Pistols
	"kp-12": preload("res://Scenes/Guns/kp_12.tscn"),
	"ty-23": preload("res://Scenes/Guns/ty-23.tscn"),
	
	# SMGs
	"vk-pdw": preload("res://Scenes/Guns/VK-PDW.tscn"),
	"kp-s13": preload("res://Scenes/Guns/kp-s13.tscn"),
	
	# Assault Rifles
	"vk-v9": preload("res://Scenes/Guns/VK-V9.tscn"),
	"kr-85c1": preload("res://Scenes/Guns/kp-s13.tscn"),
	
	# Add more weapons as needed...
}

# Weapon categories and their variants
var weapon_categories := {
	"pistols": ["kp-12", "ty-23"],
	"smgs": ["vk-pdw", "kp-s13"],
	"ars": ["vk-v9", "kr-85c1"],
	"shotguns": ["lp-07", "tvr-10"]
}

# Track current index for each category
var current_category_index := {
	"pistols": 0,
	"smgs": 0,
	"ars": 0,
	"shotguns": 0
}

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# Pre-instantiate all weapons
	for weapon_id in inventory:
		var weapon_instance = inventory[weapon_id].instantiate()
		weapon_instance.visible = false
		weapon_slot.add_child(weapon_instance)
		current_weapons[weapon_id] = weapon_instance
	
	equip_weapon("kp-12")  # Default starting weapon

func equip_weapon(weapon_id: String) -> void:
	if weapon_id == current_weapon_id or not available_weapons.has(weapon_id):
		return

	# Hide current weapon
	if current_weapon_id != "" and current_weapons.has(current_weapon_id):
		current_weapons[current_weapon_id].visible = false

	# Show new weapon
	if current_weapons.has(weapon_id):
		current_weapons[weapon_id].visible = true
		current_weapon_id = weapon_id
		update_ammo_display()

		# Update weapon name label
		var gun = current_weapons[weapon_id] as Gun
		if gun:
			weapon_label.text = gun.display_name
		else:
			weapon_label.text = weapon_id

func cycle_weapon_category(category: String) -> void:
	if not weapon_categories.has(category):
		return
	
	var weapons_in_category = weapon_categories[category]
	if weapons_in_category.size() == 0:
		return
	
	# Get only available weapons in this category
	var available_in_category = []
	for weapon_id in weapons_in_category:
		if available_weapons.get(weapon_id, false):
			available_in_category.append(weapon_id)
	
	if available_in_category.size() == 0:
		return
	
	# Cycle to next weapon in category
	current_category_index[category] = (current_category_index[category] + 1) % available_in_category.size()
	var weapon_to_equip = available_in_category[current_category_index[category]]
	equip_weapon(weapon_to_equip)

func add_weapon_to_inventory(weapon_id: String, ammo: int = 0) -> void:
	if not available_weapons.has(weapon_id):
		available_weapons[weapon_id] = true
		
		# Add weapon instance
		var weapon_instance = load("res://Scenes/Guns/%s.tscn" % weapon_id).instantiate()
		weapon_instance.visible = false
		weapon_slot.add_child(weapon_instance)
		current_weapons[weapon_id] = weapon_instance
		
		# Update inventory UI
	if weapon_id == current_weapon_id and current_weapons.has(weapon_id):
		current_weapons[weapon_id].add_ammo(ammo)
	
	# Add ammo if the weapon is currently equipped
	if weapon_id == current_weapon_id and current_weapons.has(weapon_id):
		current_weapons[weapon_id].add_ammo(ammo)
	
	show_notification("Picked up: " + weapon_id)

func update_ammo_display() -> void:
	if current_weapons.has(current_weapon_id):
		var gun = current_weapons[current_weapon_id]
		ammo_label.text = "Ammo: %d / %d" % [gun.ammo_in_mag, gun.total_reserve_ammo]
		ammo_label.modulate = Color.RED if gun.ammo_in_mag == 0 else Color.WHITE
		if gun.reloading:
			ammo_label.text += " (Reloading...)"

func show_notification(message: String) -> void:
	if has_node("CanvasLayer/Notification"):
		var notif = $CanvasLayer/Notification
		notif.text = message
		notif.visible = true
		get_tree().create_timer(2.0).timeout.connect(func(): notif.visible = false)

func _input(event):
	if event.is_action_pressed("weapon_1"):
		cycle_weapon_category("pistols")
	elif event.is_action_pressed("weapon_2"):
		cycle_weapon_category("smgs")
	elif event.is_action_pressed("weapon_3"):
		cycle_weapon_category("ars")
	elif event.is_action_pressed("weapon_4"):
		cycle_weapon_category("shotguns")
		
func take_damage(damage_amount: int, hit_position: Vector2, hit_direction: Vector2):
	current_health -= damage_amount
	health_bar.value = current_health
	
	spawn_blood_effect(hit_position, hit_direction)
	
	if current_health <= 0:
		die()

func spawn_blood_effect(hit_position: Vector2, direction: Vector2):
	# Blood splatter particles
	var splatter = load("res://Scenes/Effects/blood_splatter.tscn").instantiate()
	splatter.global_position = hit_position
	splatter.rotation = direction.angle()

	var blood_node = splatter.get_node("Blood")
	if blood_node:
		blood_node.emitting = true

	get_tree().current_scene.add_child(splatter)

	# Blood decal on player
	var blood_decal = load("res://Scenes/Effects/blood_decal.tscn").instantiate()
	blood_decal.global_position = position
	blood_decal.rotation = randf() * TAU
	blood_decal.scale = Vector2.ONE * randf_range(0.8, 1.2)
	blood_decal.z_index = -1
	
	get_tree().current_scene.add_child(blood_decal)

func die():
	if $Timer.is_stopped():
		$Timer.start()
	await $Timer.timeout
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)

func _physics_process(_delta) -> void:
	var motion = Vector2()
	if Input.is_action_pressed("up"):
		motion.y -= 1
	if Input.is_action_pressed("down"):
		motion.y += 1
	if Input.is_action_pressed("right"):
		motion.x += 1
	if Input.is_action_pressed("left"):
		motion.x -= 1
		
	velocity = motion.normalized() * movespeed
	move_and_slide()
	look_at(get_global_mouse_position())
	
	if current_weapons.has(current_weapon_id):
		var gun = current_weapons[current_weapon_id]
		if Input.is_action_just_pressed("reload"):
			gun.reload()
		if Input.is_action_pressed("LMB"):
			gun.try_shoot(self)
		
		ammo_label.text = "Ammo: %d / %d" % [gun.ammo_in_mag, gun.total_reserve_ammo]
		ammo_label.modulate = Color.RED if gun.ammo_in_mag == 0 else Color.WHITE
		if gun.reloading:
			ammo_label.text += " (Reloading...)"

func _on_timer_timeout() -> void:
	max_health -= 1 
	emit_signal("life_value", max_health)
