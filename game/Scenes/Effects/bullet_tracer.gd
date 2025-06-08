extends Node2D

@onready var line: Line2D = $Line2D
@onready var kill_timer: Timer = $KillTimer

@export var fade_time: float = 0.2
@export var line_width: float = 2.0
@export var line_color: Color = Color(1, 0.8, 0)  # Yellow-orange

func setup_tracer(start_pos: Vector2, end_pos: Vector2):
	var space_state = get_world_2d().direct_space_state
	
	# Corrected raycast parameters for layer 5
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = 1 << 4  # Layer 5 is bit 4 (0-based index)
	
	var result = space_state.intersect_ray(query)
	
	# Debug output
	
	var hit_point = result.position if result else end_pos
	
	# Clear and draw line
	line.clear_points()
	line.add_point(start_pos - global_position)
	line.add_point(hit_point - global_position)
	line.width = line_width
	line.default_color = line_color
	line.modulate.a = 1.0  # Ensure full opacity before fade
	
	# Fade and destroy
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 0.0, fade_time)
	tween.tween_callback(queue_free)

func _ready():
	line.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 1.0, 0.05)
	kill_timer.timeout.connect(queue_free)
