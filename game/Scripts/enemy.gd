extends CharacterBody2D

var motion = Vector2()

func _physics_process(delta: float) -> void:
	var Player = get_parent().get_node("Player")
	
	position += (Player.position - position)/50
	look_at(Player.position)
	move_and_collide(motion)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		queue_free()

func take_damage():
	call_deferred("queue_free")  # or play animation/sound first, then free
