extends CharacterBody2D

signal life_value

@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar

var max_health := 100
var current_health := max_health
var movespeed = 200
var bullet_speed = 2000
var bullet = preload("res://Scenes/bullet.tscn")
var attacked = false


func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health



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
	
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.rotation = rotation
	get_parent().add_child(bullet_instance)
	
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
	
