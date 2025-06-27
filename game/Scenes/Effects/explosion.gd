extends Node2D

func _ready():
	$Timer.start()
	$AudioStreamPlayer2D.play()

func _on_Timer_timeout():
	queue_free()
