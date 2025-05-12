extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var detection_area: Area2D = $DetectionArea

var motion = Vector2()
var life = 100
var target: CharacterBody2D  = null
var can_chase = false  # New flag to control chasing

func _ready() -> void:
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	progress_bar.value = life

func _physics_process(delta: float) -> void:
	if can_chase and target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * 50
		move_and_slide()
	else:
		velocity = Vector2.ZERO  # Stop moving when not chasing
		

func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		target = body
		can_chase = true  # Only enable chasing when player is in range


func take_damage():
	life -= 10
	progress_bar.value = life
	if life <= 0:
		queue_free()
	#call_deferred("queue_free")  # or play animation/sound first, then free
