extends Node2D

@onready var crosshair: TextureRect = $CanvasLayer/Crosshair

func hide_system_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair.visible = true

func show_system_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	crosshair.visible = false

func _process(_delta):
	if !get_tree().paused:
		crosshair.position = get_viewport().get_mouse_position()
