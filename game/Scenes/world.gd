extends Node2D


func _on_player_life_value(value) -> void:
	$CanvasLayer/ProgressBar.value = value
	
