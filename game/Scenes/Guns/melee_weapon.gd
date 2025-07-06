extends Node2D

@export var damage := 20
@export var cooldown := 0.6

var can_attack := true

func attack():
	if not can_attack:
		return

	print("Melee attack triggered!")
	can_attack = false
	$Area2D.monitoring = true  # Enable collision detection

	await get_tree().create_timer(0.15).timeout
	$Area2D.monitoring = false  # Disable right after short window

	await get_tree().create_timer(cooldown).timeout
	can_attack = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Melee hit: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	elif body.has_method("apply_damage"):
		body.apply_damage(damage)
