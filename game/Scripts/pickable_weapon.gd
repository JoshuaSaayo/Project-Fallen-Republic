extends Area2D

@export var weapon_id: String = "vk-pdw"  # Set this in the inspector for each weapon instance
@export var ammo_included: int = 30  # Ammo that comes with this pickup

var can_pick_up := false

func _ready():
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		can_pick_up = true
		# Show pickup prompt (you can implement this)
		body.show_pickup_prompt(true, weapon_id)

func _on_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		can_pick_up = false
		# Hide pickup prompt
		body.show_pickup_prompt(false)

func _input(event):
	if can_pick_up and event.is_action_pressed("interact"):
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			player.add_weapon_to_inventory(weapon_id, ammo_included)
			queue_free()  # Remove the pickup from the world
