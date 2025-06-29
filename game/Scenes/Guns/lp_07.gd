extends Gun

const DAMAGE = 9
const FIRE_RATE = 0.7
const MAG_SIZE = 12
const RELOAD_TIME = 3.5
const MAG_RESERVE = 48

func _ready():
	damage = DAMAGE
	fire_rate = FIRE_RATE
	mag_size = MAG_SIZE
	reload_time = RELOAD_TIME
	total_reserve_ammo = MAG_RESERVE
	pellet_count = 7                # 🔫 Multiple projectiles
	spread_angle = 12.0             # 🌪 Wider cone spread
	bullet_scene = preload("res://Scenes/bullet.tscn")
	super._ready()
