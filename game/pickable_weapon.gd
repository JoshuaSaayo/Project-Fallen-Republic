extends Area2D

@export var weapon_type: String  # e.g., "SMG", "Shotgun"

signal weapon_picked(weapon_type: String)

func _ready():
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body):
	if body.name == "Player":  # or use a group like "player"
		body.switch_weapon(weapon_type)
		queue_free()  # remove the weapon after pickup
