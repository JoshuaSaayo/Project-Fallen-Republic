extends Gun

const DAMAGE = 30
const FIRE_RATE = 0.0807  # Time between shots (600 RPM)
const MAG_SIZE = 30
const RELOAD_TIME = 2.4
const MAG_RESERVE = 120

func _ready():
	damage = DAMAGE
	fire_rate = FIRE_RATE
	mag_size = MAG_SIZE
	reload_time = RELOAD_TIME
	total_reserve_ammo = MAG_RESERVE
	bullet_scene = preload("res://Scenes/bullet.tscn")  # Add this if not set in Inspector

	# Call the parent _ready() to initialize ammo
	super._ready()
