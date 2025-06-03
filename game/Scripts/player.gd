extends CharacterBody2D

signal life_value

@onready var ammo_label: Label = $CanvasLayer/AmmoLabel
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var gun_socket: Node2D = $Gun
@onready var weapon_popup: Panel = $WeaponInventoryPopup/InventoryPanel
@onready var weapon_slot: Node = $WeaponSlot  # where weapon scene is added

var gun: Gun = null
var max_health := 100
var current_health := max_health
var movespeed = 200
var bullet_speed = 2000
var bullet = preload("res://Scenes/bullet.tscn")
var attacked = false
var current_weapon_index: String = ""
var current_weapon: Node = null
var current_weapons := {}  # Dictionary to store all weapon instances
var current_weapon_id: String = ""
var inventory := {
	"vk-pdw": preload("res://Scenes/Guns/VK-PDW.tscn"),
	"vk-v9": preload("res://Scenes/Guns/VK-V9.tscn")
}

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# Pre-instantiate all weapons
	for weapon_id in inventory:
		var weapon_scene = inventory[weapon_id]
		var weapon_instance = weapon_scene.instantiate()
		weapon_instance.visible = false
		weapon_slot.add_child(weapon_instance)
		current_weapons[weapon_id] = weapon_instance
	
	equip_weapon("vk-pdw")  # Default weapon
	
func equip_weapon(weapon_id: String) -> void:
	if weapon_id == current_weapon_id:
		return  # Already equipped
	
	# Validate weapon exists
	if not inventory.has(weapon_id):
		push_error("Attempted to equip invalid weapon: " + weapon_id)
		return
	
	# Hide current weapon
	if current_weapon_id != "" and current_weapons.has(current_weapon_id):
		current_weapons[current_weapon_id].visible = false
	
	# Show new weapon
	if current_weapons.has(weapon_id):
		current_weapons[weapon_id].visible = true
		current_weapon = current_weapons[weapon_id]
		gun = current_weapon
		current_weapon_id = weapon_id
	else:
		push_error("Weapon not found in current_weapons: " + weapon_id)

func _input(event):
	if event.is_action_pressed("weapon_1"):
		equip_weapon("vk-pdw")
	elif event.is_action_pressed("weapon_2"):
		equip_weapon("vk-v9")
		
func take_damage(damage_amount: int):
	current_health -= damage_amount
	health_bar.value = current_health  # Update progress bar
	
	# Optional visual feedback
	#$AnimationPlayer.play("hit_flash")
	
	if current_health <= 0:
		die()

func die():
	if $Timer.is_stopped():
		$Timer.start()
	# Your death handling code here
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
		
	motion = motion.normalized() * movespeed
	velocity = motion  # Set the built-in "velocity" property
	move_and_slide()   # No arguments needed
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("LMB"):
		fire()
	if Input.is_action_just_pressed("reload"):
		gun.reload()
	if gun:
		ammo_label.text = "Ammo: %d / %d" % [gun.ammo_in_mag, gun.total_reserve_ammo]
	if gun.ammo_in_mag == 0:
		ammo_label.modulate = Color.RED
	else:
		ammo_label.modulate = Color.WHITE
	if gun.reloading:
		ammo_label.text += " (Reloading...)"
		# Continuous fire if gun is automatic
	if gun and Input.is_action_pressed("LMB"):
		gun.try_shoot(self)
		
func fire():
	if gun.try_shoot(self):
		# You can play sound or animation here
		pass
	
func kill():
	get_tree().reload_current_scene()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		attacked = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if "Enemy" in body.name:
		attacked = false

func _on_timer_timeout() -> void:
	max_health -= 1 
	emit_signal("life_value", max_health)
	
