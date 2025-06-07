extends CanvasLayer

@onready var resume_btn: Button = $MenuRect/Resume
@onready var return_main_menu_btn: Button = $MenuRect/ReturnMainMenu
@onready var return_confirm_dialog: ConfirmationDialog = $ReturnConfirmDialog
@onready var world = get_tree().get_first_node_in_group("Worlds")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	return_confirm_dialog.confirmed.connect(_on_quit_confirmed)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # usually Esc key
		toggle_pause()
		get_viewport().set_input_as_handled()

func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game():
	get_tree().paused = true
	visible = true
	world.show_system_cursor()
	resume_btn.grab_focus()

func resume_game():
	get_tree().paused = false
	visible = false
	world.hide_system_cursor()

func _on_resume_pressed() -> void:
	resume_game()

func _on_quit_pressed() -> void:
	return_confirm_dialog.popup_centered()

func _on_quit_confirmed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")  # Update the path
	

	
