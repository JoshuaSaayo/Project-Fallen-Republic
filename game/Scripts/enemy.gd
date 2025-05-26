extends CharacterBody2D

# States
enum {IDLE, CHASING, ATTACKING}
var state = IDLE

# Configurations
@export var move_speed := 80.0
@export var attack_range := 150.0
@export var attack_cooldown := 0.5
@export var roam_radius := 100.0
@export var roam_interval := 3.0
@onready var enemy_anim: AnimatedSprite2D = $EnemyAnim

# Nodes
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var detection_area: Area2D = $DetectionArea
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var gun_pivot: Marker2D = $GunPivot
@onready var ray_cast_2d: RayCast2D = $GunPivot/RayCast2D

# Variables
var life = 100
var target: Node2D = null
var attack_timer := 0.0
var roam_target := Vector2.ZERO
var roam_timer := 0.0

func _ready() -> void:
	detection_area.body_entered.connect(_on_player_detected)
	detection_area.body_exited.connect(_on_player_lost)
	progress_bar.value = life

func _process(_delta):
	if enemy_anim:
		look_at(enemy_anim.global_position)
	
func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			idle_behavior()
		CHASING:
			chase_behavior(delta)
		ATTACKING:
			attack_behavior(delta)

func idle_behavior():
	roam_timer -= get_process_delta_time()
	
	# If it's time to choose a new roam target
	if roam_timer <= 0.0:
		var random_offset = Vector2(randf_range(-roam_radius, roam_radius), randf_range(-roam_radius, roam_radius))
		roam_target = global_position + random_offset
		nav_agent.target_position = roam_target
		roam_timer = roam_interval

	# Move toward roam target
	if nav_agent.is_navigation_finished(): return
	
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * move_speed * 0.5  # Move slower while roaming
	move_and_slide()
	
func chase_behavior(delta):
	if !target: return
	
	nav_agent.target_position = target.global_position
	# Move toward player
	if !nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * move_speed
		move_and_slide()
	
	# Rotate gun toward player
	gun_pivot.look_at(target.global_position)
	
	# Transition to attack if in range
	if global_position.distance_to(target.global_position) < attack_range:
		state = ATTACKING

func attack_behavior(delta):
	if !target: 
		state = IDLE
		return
	
	# Face player while attacking
	gun_pivot.look_at(target.global_position)
	
	# Cooldown management
	attack_timer -= delta
	if attack_timer <= 0.0:
		shoot()
		attack_timer = attack_cooldown
		
	# Return to chase if player moves away
	if global_position.distance_to(target.global_position) > attack_range * 1.2:
		state = CHASING
		
func shoot():
	var bullet = preload("res://Scenes/enemy_bullet.tscn").instantiate()
	bullet.global_position = $GunPivot.global_position
	bullet.direction = (target.global_position - $GunPivot.global_position).normalized()
	get_parent().add_child(bullet)
	
	if $ShootSound:
		$ShootSound.play()
	# Animation placeholder (add later)
	$GunPivot/MuzzleFlash.show()
	await get_tree().create_timer(0.1).timeout
	$GunPivot/MuzzleFlash.hide()
	
	# Play shoot animation here later
	# $AnimationPlayer.play("shoot")

func _on_player_detected(body):
	if body.is_in_group("Player"):
		target = body
		state = CHASING

func _on_player_lost(body):
	if body == target:
		target = null
		state = IDLE
		
func take_damage(amount):
	life -= amount
	progress_bar.value = life
	if life <= 0:
		queue_free()
