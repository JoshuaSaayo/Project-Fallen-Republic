extends Node2D

@export var max_health := 100
@export var explosion_radius := 100.0
@export var explosion_damage := 50
@export var explosion_scene := preload("res://Scenes/Effects/explosion.tscn")

var health := max_health

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("get_damage"):
		apply_damage(body.get_damage())
		body.queue_free()  # destroy bullet

func apply_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		explode()

func explode() -> void:
	spawn_explosion()
	damage_nearby_objects()
	call_deferred("queue_free")  # destroy vehicle after explosion

func spawn_explosion() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", explosion)

func damage_nearby_objects() -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = explosion_radius
	query.shape = shape
	query.transform = Transform2D(0, global_position)
	query.collision_mask = 1  # Set to whatever layer destructibles/enemies are on

	var results = space_state.intersect_shape(query)

	for result in results:
		var obj = result.get("collider")
		if obj and obj.has_method("apply_damage"):
			obj.apply_damage(explosion_damage)
