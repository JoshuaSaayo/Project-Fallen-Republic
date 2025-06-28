extends Gun

const DAMAGE = 26
const FIRE_RATE = 0.230  # 3.45s / 15 shots
const MAG_SIZE = 15
const RELOAD_TIME = 2.0
const MAG_RESERVE = 45

func _ready():
	damage = DAMAGE
	fire_rate = FIRE_RATE
	mag_size = MAG_SIZE
	reload_time = RELOAD_TIME
	total_reserve_ammo = MAG_RESERVE
	bullet_scene = preload("res://Scenes/bullet.tscn")  # Add this if not set in Inspector

	# Call the parent _ready() to initialize ammo
	super._ready()
