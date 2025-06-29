extends StaticBody2D

@export var max_hp: int = 100
var hp: int

@onready var intact_vehicle: Sprite2D = $IntactVehicle
@onready var exploded_vehicle: Sprite2D = $ExplodedVehicle
@onready var healthbar: ProgressBar = $Healthbar
@onready var explosion_particles: GPUParticles2D = $ExplosionParticles

var destroyed := false

func _ready():
	hp = max_hp
	exploded_vehicle.visible = false
	healthbar.max_value = max_hp
	healthbar.value = hp
	add_to_group("Destructible")  # So bullets can detect this

func apply_damage(amount: int):
	if destroyed:
		return

	hp -= amount
	healthbar.value = hp

	if hp <= 0:
		explode()

func explode():
	destroyed = true

	# Swap to destroyed visuals
	intact_vehicle.visible = false
	exploded_vehicle.visible = true

	# Trigger explosion effect
	explosion_particles.emitting = true

	# Disable collision
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true

	# Optional: Hide health bar or let it fade out
	healthbar.visible = false

	# Optional: queue_free after time
	# await get_tree().create_timer(5).timeout
	# queue_free()
