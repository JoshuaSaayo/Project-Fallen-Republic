extends Area2D

@export var speed := 1000.0
@export var damage := 10
var direction := Vector2.RIGHT

func _ready():
	$Timer.timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)

	# Rotate bullet to face its direction
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func _physics_process(delta):
	position += direction.normalized() * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("take_damage"):
		body.take_damage(damage, global_position, direction)

	queue_free()
