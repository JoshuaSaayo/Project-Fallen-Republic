extends StaticBody2D

@export var drop_weapon_id: String = "vk-v9"
@export var drop_ammo: int = 40
@export var max_health := 50

var health := max_health

@onready var health_bar: ProgressBar = $HealthBar

func apply_damage(amount: int) -> void:
	health -= amount
	health_bar.value = health
	health_bar.visible = true
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
