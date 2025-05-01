extends CharacterBody2D

var speed = 2000

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	var collision = move_and_slide()
		# Check for collisions with anything (including tiles)
	if get_slide_collision_count() > 0:
		var first_collision = get_slide_collision(0)
		if first_collision.get_collider() is TileMap:
			queue_free()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	#call_deferred("queue_free")
	if body.is_in_group("Enemy"):
		if body.has_method("take_damage"):
			body.take_damage()
	queue_free()
	if body is TileMap or body.name == "TileMap":
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
