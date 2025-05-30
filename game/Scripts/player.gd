extends CharacterBody2D

signal life_value

@onready var inventory_ui = preload("res://Scenes/inventory.tscn").instantiate()
@onready var ammo_label: Label = $CanvasLayer/AmmoLabel
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var gun_socket: Node2D = $Gun
@onready var weapon_popup: Panel = $WeaponInventoryPopup/InventoryPanel

var gun: Gun = null
var max_health := 100
var inventory: Array = [null, null, null, null]
var current_health := max_health
var movespeed = 200
var bullet_speed = 2000
var bullet = preload("res://Scenes/bullet.tscn")
var attacked = false
var current_weapon_index := 0
var current_weapon = null

func _ready() -> void:
	add_child(inventory_ui)
	inventory_ui.hide()
	health_bar.max_value = max_health
	health_bar.value = current_health

	# Instantiate and store actual weapon instances
	inventory[0] = preload("res://Scenes/Guns/assault.tscn").instantiate()
	inventory[1] = preload("res://Scenes/Guns/smg.tscn").instantiate()
	
	# Add all weapons as children but hide them
	for weapon in inventory:
		if weapon:
			add_child(weapon)
			weapon.visible = false
	
	# Equip first weapon by default
	switch_weapon(0)
	
func switch_weapon(index: int) -> void:
	if index >= 0 and index < inventory.size():
		if inventory[index] != null:
			if current_weapon:
				current_weapon.visible = false  # Just hide the current
			current_weapon_index = index
			current_weapon = inventory[index]
			current_weapon.visible = true
			gun = current_weapon  # Also update your gun reference

func _input(event):
	if event.is_action_pressed("weapon_1"):
		switch_weapon(0)
	elif event.is_action_pressed("weapon_2"):
		switch_weapon(1)
	elif event.is_action_pressed("weapon_3"):
		switch_weapon(2)
	elif event.is_action_pressed("weapon_4"):
		switch_weapon(3)
	if event.is_action_pressed("Inventory"):
		inventory_ui.visible = !inventory_ui.visible
		
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
	
