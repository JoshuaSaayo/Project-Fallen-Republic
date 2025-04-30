extends CharacterBody2D

signal life_value

var life = 100
var movespeed = 500
var bullet_speed = 2000
var bullet = preload("res://Scenes/bullet.tscn")
var attacked = false


func _ready() -> void:
	emit_signal("life_value", life)

func _process(delta: float) -> void:
	if attacked:
		if life <= 0:
			kill()
		if $Timer.is_stopped():
			$Timer.start()

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
	life -= 1 
	emit_signal("life_value", life)
