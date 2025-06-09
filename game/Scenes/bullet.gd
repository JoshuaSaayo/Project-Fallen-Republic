extends CharacterBody2D

@export var speed := 3000.0
@export var damage := 10
@export var lifetime: float = 1.5

var direction = Vector2.ZERO
var has_hit := false

func _ready():
	# Auto-remove bullet after lifetime
	await get_tree().create_timer(lifetime).timeout
	if not has_hit:
		queue_free()

func _physics_process(delta):
	if has_hit:
		return
	
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		handle_collision(collision)
		queue_free()

func handle_collision(collision: KinematicCollision2D):
	has_hit = true

	var hit_position = collision.get_position()
	var collider = collision.get_collider()
	if collider.is_in_group("Destructible"):
		if collider.has_method("apply_damage"):
			collider.apply_damage(damage)
			
	if collider and collider.is_in_group("Enemy"):
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
		
		# Spawn blood effect
		spawn_effect("res://Scenes/Effects/blood_splatter.tscn", hit_position, -direction)

		# Spawn blood decal
		var blood_decal = load("res://Scenes/Effects/blood_decal.tscn").instantiate()
		blood_decal.global_position = hit_position
		blood_decal.rotation = randf() * TAU
		blood_decal.scale = Vector2.ONE * randf_range(0.8, 1.2)
		blood_decal.z_index = -1
		get_tree().current_scene.add_child(blood_decal)

	else:
		# Spawn spark effect for wall/tile hit
		spawn_effect("res://Scenes/Effects/bullet_impact.tscn", hit_position, -direction)

func spawn_effect(scene_path: String, hit_position: Vector2, dir: Vector2):
	var effect_scene = load(scene_path)
	if effect_scene == null:
		print("Failed to load effect scene: ", scene_path)
		return

	var effect = effect_scene.instantiate()
	effect.global_position = hit_position
	effect.rotation = dir.angle()

	# Start particle emission manually (safety check)
	if effect.has_node("Spark"):
		effect.get_node("Spark").emitting = true
	elif effect.has_node("Blood"):
		effect.get_node("Blood").emitting = true

	get_tree().current_scene.add_child(effect)
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func set_direction(dir: Vector2):
	direction = dir.normalized()
