extends Node2D

func _ready():
	$Timer.start()
	$AudioStreamPlayer2D.play()

func _on_timer_timeout() -> void:
	queue_free()
