extends CharacterBody2D

@export var speed := 1000.0
@export var damage := 10
@export var max_distance := 1000.0  # Match tracer length
var direction = Vector2.ZERO
var lifetime: float = 1.5
var distance_traveled := 0.0
var has_hit := false
@onready var tracer_scene = preload("res://Scenes/Effects/bullet_tracer.tscn")

func _ready():
	# Make sure direction is already set before _ready() runs
	var tracer = tracer_scene.instantiate()
	get_parent().add_child(tracer)

	var start_pos = global_position
	var space_state = get_world_2d().direct_space_state
	var ray_length := 2000

	var ray_end = start_pos + direction.normalized() * ray_length
	var query = PhysicsRayQueryParameters2D.create(start_pos, ray_end)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = collision_mask

	var result = space_state.intersect_ray(query)
	var end_pos = result.position if result else ray_end

	tracer.setup_tracer(start_pos, end_pos)

	# Optional lifetime timer
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	if has_hit:
		return
		
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		handle_collision(collision)
		queue_free()  # Immediate destruction

func handle_collision(collision: KinematicCollision2D):
	has_hit = true
	
	# Optional: Spawn impact effect
	var effect = preload("res://Scenes/Effects/bullet_impact.tscn").instantiate()
	effect.position = collision.get_position()
	get_parent().add_child(effect)
	
	# Damage logic
	var collider = collision.get_collider()
	if collider and collider.is_in_group("Enemy"):
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
			
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func set_direction(dir: Vector2):
	direction = dir
