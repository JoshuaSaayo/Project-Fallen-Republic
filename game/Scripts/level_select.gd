extends Control


func _on_map_1_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/map_1.tscn")


func _on_map_2_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/map_2.tscn")


func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
