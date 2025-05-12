extends Control


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/map_1.tscn")


func _on_load_game_pressed() -> void:
	pass # Replace with function body.


func _on_select_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
