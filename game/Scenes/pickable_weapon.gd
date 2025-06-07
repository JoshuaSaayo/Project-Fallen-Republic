extends Area2D
class_name PickableWeapon

@export_category("Weapon Settings")
## The unique ID that matches your WEAPON_DATA in inventory.gd
@export var weapon_id: String = "vk-pdw" : 
	set(id):
		weapon_id = id
		update_weapon_appearance()
## How much ammo this pickup contains        
@export var ammo_included: int = 30
## Display name for pickup prompt
@export var weapon_name: String = "VK-PDW" : 
	set(name):
		weapon_name = name
		if Engine.is_editor_hint():
			notify_property_list_changed()

@export_category("Visuals")
## Override automatic texture loading if needed
@export var weapon_texture: Texture2D : 
	set(texture):
		weapon_texture = texture
		if $Sprite2D:
			$Sprite2D.texture = texture
## Scale adjustment for this weapon type            
@export var display_scale: Vector2 = Vector2(0.5, 0.5)

var can_pick_up := false

# Weapon texture naming convention: "{WEAPON_ID}-PICKABLE.png"
const TEXTURE_PATH = "res://Assets/Guns/pickable_weapons/%s-PICKABLE.png"

func _ready():
	update_weapon_appearance()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func update_weapon_appearance():
	# Load texture if not manually set
	if not weapon_texture:
		var auto_texture = _get_weapon_texture(weapon_id)
		if auto_texture:
			$Sprite2D.texture = auto_texture
	
	# Apply display settings
	$Sprite2D.scale = display_scale
	
	# Auto-name if not set
	if weapon_name.is_empty():
		weapon_name = weapon_id.to_upper()

func _get_weapon_texture(id: String) -> Texture2D:
	var path = TEXTURE_PATH % id.to_upper()
	if ResourceLoader.exists(path):
		return load(path)
	push_warning("Weapon texture not found at: ", path)
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
