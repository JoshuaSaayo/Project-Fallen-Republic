extends CharacterBody2D

enum {IDLE, CHASING, ATTACKING}
var state = IDLE

@export var move_speed := 80.0
@export var attack_range := 150.0
@export var attack_cooldown := 0.5
@export var roam_radius := 100.0
@export var roam_interval := 3.0

@onready var enemy_anim: AnimatedSprite2D = $EnemyAnim
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var detection_area: Area2D = $DetectionArea
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var gun_pivot: Marker2D = $GunPivot
@onready var muzzle_flash: Sprite2D = $GunPivot/MuzzleFlash

var life := 100
var target: Node2D = null
var attack_timer := 0.0
var roam_target := Vector2.ZERO
var roam_timer := 0.0

func _ready() -> void:
	detection_area.body_entered.connect(_on_player_detected)
	detection_area.body_exited.connect(_on_player_lost)
	progress_bar.value = life

func _process(delta: float) -> void:
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		rotation = lerp_angle(rotation, target_dir.angle(), 5 * delta)

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			idle_behavior()
		CHASING:
			chase_behavior(delta)
		ATTACKING:
			attack_behavior(delta)

func idle_behavior() -> void:
	roam_timer -= get_process_delta_time()
	
	if roam_timer <= 0.0:
		var random_offset = Vector2(
			randf_range(-roam_radius, roam_radius),
			randf_range(-roam_radius, roam_radius)
		)
		roam_target = global_position + random_offset
		nav_agent.target_position = roam_target
		roam_timer = roam_interval

	if !nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * move_speed * 0.5
		move_and_slide()
		rotation = lerp_angle(rotation, direction.angle(), 5 * get_physics_process_delta_time())

func chase_behavior(_delta) -> void:
	if !target: return
	
	nav_agent.target_position = target.global_position
	
	if !nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		velocity = (next_pos - global_position).normalized() * move_speed
		move_and_slide()
	
	gun_pivot.look_at(target.global_position)
	
	if global_position.distance_to(target.global_position) < attack_range:
		state = ATTACKING

func attack_behavior(delta: float) -> void:
	if !target: 
		state = IDLE
		return
	
	gun_pivot.look_at(target.global_position)
	
	attack_timer -= delta
	if attack_timer <= 0.0:
		shoot()
		attack_timer = attack_cooldown
		
	if global_position.distance_to(target.global_position) > attack_range * 1.2:
		state = CHASING
		
func shoot() -> void:
	var bullet = preload("res://Scenes/enemy_bullet.tscn").instantiate()
	bullet.global_position = muzzle_flash.global_position
	bullet.direction = (target.global_position - muzzle_flash.global_position).normalized()
	get_parent().add_child(bullet)
	
	if $ShootSound:
		$ShootSound.play()
	
	muzzle_flash.show()
	await get_tree().create_timer(0.1).timeout
	muzzle_flash.hide()

func _on_player_detected(body: Node2D) -> void:
	if body.is_in_group("Player"):
			target = body
			state = CHASING

func _on_player_lost(body: Node2D) -> void:
	if body == target:
		target = null
		state = IDLE
		
func take_damage(amount: int) -> void:
	life -= amount
	progress_bar.value = life
	if life <= 0:
		queue_free()
