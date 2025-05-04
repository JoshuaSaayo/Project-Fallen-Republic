extends CanvasLayer

@onready var resume_btn: Button = $MenuRect/Resume
@onready var quit_btn: Button = $MenuRect/Quit
@onready var quit_confirm_dialog: ConfirmationDialog = $QuitConfirmDialog

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	resume_btn.pressed.connect(_on_resume_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	quit_confirm_dialog.confirmed.connect(_on_quit_confirmed)

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
	resume_btn.grab_focus()

func resume_game():
	get_tree().paused = false
	visible = false

func _on_resume_pressed() -> void:
	resume_game()

func _on_quit_pressed() -> void:
	quit_confirm_dialog.popup_centered()

func _on_quit_confirmed():
	get_tree().quit()
	

	
