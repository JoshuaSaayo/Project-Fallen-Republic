extends CharacterBody2D

var speed = 2000

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	move_and_slide()
