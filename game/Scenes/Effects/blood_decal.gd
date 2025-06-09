extends Node2D

@onready var timer = $Timer

func _ready():
	timer.start(10)  # Start timer for 10 seconds

func _on_timer_timeout() -> void:
	queue_free()  # Delete the node
