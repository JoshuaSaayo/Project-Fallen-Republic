extends CharacterBody2D

@export var speed := 1000.0
@export var damage := 10
@export var max_distance := 1000.0

var direction = Vector2.ZERO
var lifetime: float = 1.5
var distance_traveled := 0.0
var has_hit := false

func _physics_process(delta):
	if has_hit:
		return
		
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		handle_collision(collision)
		queue_free()

func handle_collision(collision: KinematicCollision2D):
	has_hit = true
	
	# Optional: Spawn impact effect
	var effect = preload("res://Scenes/Effects/bullet_impact.tscn").instantiate()
	effect.position = collision.get_position()
	get_parent().add_child(effect)
	# Force emission again, just in case
	var spark = effect.get_node("Spark")  # Adjust path to your GPUParticles2D node
	if spark:
		spark.emitting = true
		
	# Get the direction the bullet was moving
	var spark_rotation = collision.get_normal()
	var incoming = -direction.normalized()
	effect.rotation = spark_rotation.angle() + PI  # Flip to spark away from surface
	effect.rotation = incoming.angle()
	
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
