extends Node2D

func _ready():
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
