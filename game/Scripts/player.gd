extends CharacterBody2D

signal life_value

@onready var ammo_label: Label = $CanvasLayer/AmmoLabel
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var weapon_slot: Node = $WeaponSlot  # where weapon scene is added
@onready var pickup_prompt: Label = $PickupPrompt

var max_health := 100
var current_health := max_health
var movespeed := 200
var current_weapons := {}  # Dictionary to store all weapon instances
var current_weapon_id: String = ""
var available_weapons := {
	"kp-12": true  # Player starts with KP-12
}  # Tracks which weapons player has unlocked
var inventory := {
	"vk-pdw": preload("res://Scenes/Guns/VK-PDW.tscn"),
	"vk-v9": preload("res://Scenes/Guns/VK-V9.tscn"),
	"kp-12": preload("res://Scenes/Guns/VK-V9.tscn")
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

func add_weapon_to_inventory(weapon_id: String, ammo: int = 0) -> void:
	if not available_weapons.has(weapon_id):
		available_weapons[weapon_id] = true
		
		# Add weapon instance
		var weapon_instance = load("res://Scenes/Guns/%s.tscn" % weapon_id).instantiate()
		weapon_instance.visible = false
		weapon_slot.add_child(weapon_instance)
		current_weapons[weapon_id] = weapon_instance
		
		# Update inventory UI
		var inventory = get_tree().get_first_node_in_group("Inventory")
		if inventory and inventory.has_method("add_weapon_to_list"):
			inventory.add_weapon_to_list(weapon_id)
	
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

func show_pickup_prompt(show: bool, weapon_name: String = "") -> void:
	if show:
		pickup_prompt.text = "Press E to pick up %s" % weapon_name
	pickup_prompt.visible = show

func show_notification(message: String) -> void:
	if has_node("CanvasLayer/Notification"):
		var notif = $CanvasLayer/Notification
		notif.text = message
		notif.visible = true
		get_tree().create_timer(2.0).timeout.connect(func(): notif.visible = false)

func _input(event):
	if event.is_action_pressed("weapon_1"):
		equip_weapon("vk-pdw")
	elif event.is_action_pressed("weapon_2"):
		equip_weapon("vk-v9")
	elif event.is_action_pressed("weapon_3"):
		equip_weapon("kp-12")
		
func take_damage(damage_amount: int):
	current_health -= damage_amount
	health_bar.value = current_health
	
	if current_health <= 0:
		die()

func die():
	if $Timer.is_stopped():
		$Timer.start()
	await $Timer.timeout
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
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
