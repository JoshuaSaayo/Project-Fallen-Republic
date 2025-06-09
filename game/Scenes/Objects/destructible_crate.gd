extends Node2D

@export var max_health := 50
var health := max_health

func _ready():
	$Area2D.body_entered.connect(_on_area_2d_body_entered)

func apply_damage(amount: int):
	health -= amount
	if health <= 0:
		break_crate()

func break_crate():
	# Optional: Play animation or particle effect
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("break")

	# Optional: Spawn loot or debris
	spawn_loot()
	queue_free()

func spawn_loot():
	var weapon_loot = preload("res://Scenes/pickable_weapon.tscn").instantiate()
	weapon_loot.global_position = global_position
	get_tree().current_scene.add_child(weapon_loot)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("get_damage"):
		apply_damage(body.get_damage())
		body.queue_free()  # Destroy bullet
