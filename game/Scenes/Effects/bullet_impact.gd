extends Node2D

func _ready():
	# Auto-delete after particles finish
	await get_tree().create_timer(0.5).timeout
	queue_free()
