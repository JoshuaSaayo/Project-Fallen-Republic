extends Area2D

@export var weapon_id: String = "vk-pdw"
@export var ammo_included: int = 30
@export var weapon_name: String = "VK-PDW"

var can_pick_up := false

func _ready():
	# Set the correct sprite/texture for this weapon
	$Sprite2D.texture = load("res://Assets/Guns/pickable_weapons/VK-PDW (QBZ191+X95 HYBRID)-PICKABLE.png" % weapon_id.to_upper())
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		can_pick_up = true
		body.show_pickup_prompt(true, weapon_name)

func _on_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		can_pick_up = false
		body.show_pickup_prompt(false)

func _input(event):
	if can_pick_up and event.is_action_pressed("interact"):
		var player = get_tree().get_first_node_in_group("Player")
		if player and player.has_method("add_weapon_to_inventory"):
			player.add_weapon_to_inventory(weapon_id, ammo_included)
			queue_free()
