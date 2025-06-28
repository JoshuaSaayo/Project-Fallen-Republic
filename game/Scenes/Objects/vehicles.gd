extends Area2D

@export var max_health := 100
@export var explosion_scene := preload("res://Scenes/Objects/exploded_vehicle.tscn")
@export var destroyed_scene := preload("res://Scenes/Objects/exploded_vehicle.tscn")

var health := max_health

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_damage"):
		print("Hit by: ", body.name)
		apply_damage(body.get_damage())
		body.queue_free()

func apply_damage(amount: int) -> void:
	health -= amount
	health = clamp(health, 0, max_health)
	update_healthbar()
	if health <= 0:
		explode_and_transform()

func update_healthbar() -> void:
	if has_node("TextureProgressBar"):  # adjust node path if nested
		$TextureProgressBar.value = health
		
func explode_and_transform():
	# Spawn explosion FX
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", explosion)

	# Spawn destroyed version
	var wreck = destroyed_scene.instantiate()
	wreck.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", wreck)

	# Remove current node
	call_deferred("queue_free")
