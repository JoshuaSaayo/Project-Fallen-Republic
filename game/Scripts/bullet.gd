extends CharacterBody2D

var speed = 2000

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Bullet hit: ", body.name)
	if body.is_in_group("Enemy"):
		if body.has_method("take_damage"):
			body.take_damage()
		call_deferred("queue_free")
