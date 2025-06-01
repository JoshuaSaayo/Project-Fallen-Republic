extends Node2D

@onready var crosshair: TextureRect = $CanvasLayer/Crosshair
@onready var inventory_ui: Control = $UI/Inventory


func _ready():
	hide_system_cursor()
	$CanvasLayer.add_child(inventory_ui)  # Assuming CanvasLayer exists in the scene
	
func _process(_delta):
	crosshair.position = get_viewport().get_mouse_position()

func hide_system_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair.visible = true

func show_system_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	crosshair.visible = false
