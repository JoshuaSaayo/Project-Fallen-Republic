extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/campain_menu.tscn")  # Replace with your actual game scene


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/debug_map.tscn")
