extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar

var motion = Vector2()
var life = 100

func _ready() -> void:
	progress_bar.value = life

func _physics_process(delta: float) -> void:
	var Player = get_parent().get_node("../Player")
	position += (Player.position - position)/50
	move_and_collide(motion)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		pass
		queue_free()

func take_damage():
	life -= 1
	progress_bar.value = life
	if life <= 0:
		queue_free()
	#call_deferred("queue_free")  # or play animation/sound first, then free
