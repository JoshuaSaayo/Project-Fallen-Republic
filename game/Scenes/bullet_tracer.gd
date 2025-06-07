extends Node2D

@onready var line := $Line2D
@onready var kill_timer: Timer = $KillTimer


func setup_tracer(start_pos: Vector2, end_pos: Vector2):
	line.clear_points()
	line.add_point(to_local(start_pos))
	line.add_point(to_local(end_pos))
	
	# Optional: Animate fade out here if you want smooth fading
	kill_timer.start()

func _on_kill_timer_timeout() -> void:
	queue_free()
