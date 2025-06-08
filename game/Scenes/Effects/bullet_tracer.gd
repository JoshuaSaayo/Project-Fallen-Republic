extends Node2D

@onready var line: Line2D = $Line2D
@onready var kill_timer: Timer = $KillTimer

@export var fade_time: float = 0.2
@export var line_width: float = 2.0
@export var line_color: Color = Color(1, 0.8, 0)  # Yellow-orange

func setup_tracer(start_pos: Vector2, end_pos: Vector2):
	var space_state = get_world_2d().direct_space_state
	
	# Raycast parameters for layer 5 (1 << 4)
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = 1 << 4  # Layer 5
	
	var result = space_state.intersect_ray(query)
	var hit_point = result.position if result else end_pos
	
	# Draw line directly in world coordinates
	line.clear_points()
	line.add_point(start_pos)
	line.add_point(hit_point)
	line.width = line_width
	line.default_color = line_color
	line.modulate.a = 1.0
	
	# Fade and destroy
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 0.0, fade_time)
	tween.tween_callback(queue_free)

func _ready():
	# Initial fade-in
	line.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 1.0, 0.05)
	
	# Safety cleanup in case something goes wrong
	kill_timer.start(fade_time + 0.1)
	kill_timer.timeout.connect(queue_free)
