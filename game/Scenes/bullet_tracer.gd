extends Node2D  # Matches your scene root

@onready var line: Line2D = $Line2D  # Reference to child Line2D
@onready var kill_timer: Timer = $KillTimer

@export var fade_time: float = 0.2
@export var line_width: float = 2.0
@export var line_color: Color = Color(1, 0.8, 0)  # Yellow-orange

func setup_tracer(start_pos: Vector2, end_pos: Vector2):
	# Configure the Line2D child
	line.width = line_width
	line.default_color = line_color
	
	# Clear and set points
	line.clear_points()
	line.add_point(to_local(start_pos))  # Convert to local space
	line.add_point(to_local(end_pos))
	
	# Fade out effect
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 0.0, fade_time)
	await tween.finished
	queue_free()

# Optional: Initialize with fade-in
func _ready():
	line.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 1.0, 0.05)
	
	# Safety: Auto-delete if something goes wrong
	kill_timer.timeout.connect(queue_free)
