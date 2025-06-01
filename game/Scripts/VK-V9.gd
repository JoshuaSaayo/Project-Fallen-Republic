extends Gun

const DAMAGE = 7
const FIRE_RATE = 0.15  # Time between shots (600 RPM)
const MAG_SIZE = 25
const RELOAD_TIME = 1.5

func _ready():
	damage = DAMAGE
	fire_rate = FIRE_RATE
	mag_size = MAG_SIZE
	reload_time = RELOAD_TIME
	bullet_scene = preload("res://Scenes/bullet.tscn")  # Add this if not set in Inspector

	# Call the parent _ready() to initialize ammo
	super._ready()
