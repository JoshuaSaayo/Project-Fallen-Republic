extends Control



func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/map_1.tscn")  # Replace with your actual game scene


func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _ready():
	$LevelSelection/Level1Btn.connect("pressed", _on_level_selected.bind("res://Maps/map_1.tscn"))
	$LevelSelection/Level2Btn.connect("pressed", _on_level_selected.bind("res://Scenes/world.tscn"))
	
func _on_level_selected(map_path: String):
	Global.selected_map = map_path  # Store selection
	get_tree().change_scene_to_file("res://Scenes/game_controller.tscn")  # Or directly to map	
