extends Node2D  # Matches your scene root

@onready var line: Line2D = $Line2D  # Reference to child Line2D
@onready var kill_timer: Timer = $KillTimer

@export var fade_time: float = 0.2
@export var line_width: float = 2.0
@export var line_color: Color = Color(1, 0.8, 0)  # Yellow-orange

func setup_tracer(start_pos: Vector2, end_pos: Vector2):
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collide_with_areas = false  # Only collide with physics bodies
	query.collision_mask = 1 << 5  # Adjust if your tilemap uses a different layer

	var result = space_state.intersect_ray(query)
	var hit_point = result.position if result else end_pos

	# Draw the line up to the hit point
	line.width = line_width
	line.default_color = line_color
	line.clear_points()
	line.add_point(to_local(start_pos))
	line.add_point(to_local(hit_point))

	# Fade out
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
