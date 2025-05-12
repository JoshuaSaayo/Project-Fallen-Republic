extends CharacterBody2D

@export var speed := 2000.0
@export var damage := 10

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		
		if body.is_in_group("Enemy"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
			print("Enemy hit:", body.name)
			queue_free()
			return
		
		elif body is TileMap or body.name == "TileMap":
			queue_free()
			return

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
	
