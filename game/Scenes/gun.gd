extends Node2D
class_name Gun

@export var damage: int = 10
@export var fire_rate: float = 0.1  # Seconds between shots
@export var mag_size: int = 30
@export var reload_time: float = 1.8
@export var bullet_scene: PackedScene


var ammo_in_mag: int
var total_reserve_ammo: int = 90
var can_shoot: bool = true
var reloading: bool = false
var last_shot_time: float = 0

func spawn_tracer(start_pos: Vector2, end_pos: Vector2):
	var tracer = preload("res://Scenes/bullet_tracer.tscn").instantiate()
	get_parent().add_child(tracer)
	tracer.global_position = Vector2.ZERO
	tracer.setup_tracer(start_pos, end_pos)
	
func _ready():
	ammo_in_mag = mag_size
	bullet_scene = preload("res://Scenes/bullet.tscn")

func try_shoot(owner_node: Node2D):
	if not can_shoot or reloading:
		return false

	if ammo_in_mag <= 0:
		reload()
		return false

	var time_since_last_shot = Time.get_ticks_msec() / 1000.0 - last_shot_time
	if time_since_last_shot < fire_rate:
		return false

	# Fire
	last_shot_time = Time.get_ticks_msec() / 1000.0
	ammo_in_mag -= 1

	var bullet = bullet_scene.instantiate()
	bullet.global_position = owner_node.global_position
	bullet.rotation = owner_node.rotation
	if bullet.has_method("set_direction"):
		bullet.set_direction(owner_node.get_global_mouse_position() - owner_node.global_position)
	owner_node.get_parent().add_child(bullet)
	
	var shot_sound = get_node("ShotSound")
	if shot_sound:
		shot_sound.play()
		
	if ammo_in_mag == 0:
		reload()
		
	spawn_tracer(owner_node.global_position, owner_node.get_global_mouse_position())
	
	return true
	


func reload():
	if reloading or ammo_in_mag == mag_size or total_reserve_ammo == 0:
		return
		
	var reload_sound = get_node("ReloadSound")
	if reload_sound:
		reload_sound.play()
		
	reloading = true
	can_shoot = false
	await get_tree().create_timer(reload_time).timeout

	var needed = mag_size - ammo_in_mag
	var to_reload = min(needed, total_reserve_ammo)
	ammo_in_mag += to_reload
	total_reserve_ammo -= to_reload

	reloading = false
	can_shoot = true
