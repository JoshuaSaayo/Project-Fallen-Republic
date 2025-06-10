extends Node2D

@export var drop_weapon_id: String = "vk-v9"
@export var drop_ammo: int = 40
@export var max_health := 50
var health := max_health

func _ready():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered by: ", body.name)
	if body.has_method("get_damage"):
		print("Bullet damage: ", body.get_damage())
		apply_damage(body.get_damage())
		body.queue_free()

func apply_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		break_crate()

func break_crate() -> void:
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("break")
		await $AnimationPlayer.animation_finished
	spawn_loot()
	queue_free()

func spawn_loot() -> void:
	var weapon_loot = preload("res://Scenes/pickable_weapon.tscn").instantiate()
	weapon_loot.global_position = global_position
	weapon_loot.weapon_id = drop_weapon_id
	weapon_loot.ammo_included = drop_ammo
	get_parent().call_deferred("add_child", weapon_loot)
