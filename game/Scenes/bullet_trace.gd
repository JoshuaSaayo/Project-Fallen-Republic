extends Line2D

var previous_position: Vector2 = Vector2.ZERO
var bullet_radius := 0.0 #Default: 0.0

func _ready() -> void:
	var bullet_texture = get_parent().texture
	bullet_radius = bullet_texture.get_size().x * 0.5 #default: 0.5
	previous_position = get_parent().global_position
	
func _process(_delta) -> void:
	var current_position = get_parent().global_position
	var direction = (current_position - previous_position).normalized()
	
	add_point(current_position - bullet_radius * direction)
	if points.size() > 20: #default: 20
		remove_point(0)
		
	previous_position = current_position
