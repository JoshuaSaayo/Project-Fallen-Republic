extends Node2D

func _ready():
	if Global.selected_map:
		var map = load(Global.selected_map).instantiate()
		add_child(map)
	else:
		# Default map or return to menu
		get_tree().change_scene_to_file("res://main_menu.tscn")
