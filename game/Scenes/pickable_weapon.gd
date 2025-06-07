extends Area2D

@export var weapon_id: String = "vk-pdw"
@export var ammo_included: int = 30
@export var weapon_name: String = "VK-PDW"

var can_pick_up := false

func _ready():
	# Safe texture loading
	var weapon_texture = _get_weapon_texture(weapon_id)
	if weapon_texture:
		$Sprite2D.texture = weapon_texture
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _get_weapon_texture(id: String) -> Texture2D:
	var texture_path = "res://Assets/Guns/pickable_weapons/VK-PDW (QBZ191+X95 HYBRID)-PICKABLE.png".format([id.to_upper()])
	if ResourceLoader.exists(texture_path):
		return load(texture_path)
	push_error("Weapon texture not found: ", texture_path)
	return null

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
