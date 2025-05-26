extends Node2D

@onready var crosshair: TextureRect = $CanvasLayer/Crosshair

func _process(delta):
	crosshair.position = get_viewport().get_mouse_position()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
