extends Control

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/map_1.tscn")  # Replace with your actual game scene


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
