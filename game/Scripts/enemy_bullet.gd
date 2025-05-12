extends Area2D

# Configuration
@export var speed := 1000.0
@export var damage := 10
var direction := Vector2.RIGHT

func _ready():
	# Auto-destroy after timer ends
	$Timer.timeout.connect(queue_free)
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
	queue_free()  # Destroy on hit
