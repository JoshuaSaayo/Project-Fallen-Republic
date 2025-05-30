extends Control

@onready var weapon_name: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponName
@onready var weapon_img: TextureRect = $MainLayout/HBoxContainer/DetailsPanel/WeaponImg
@onready var descriptions: RichTextLabel = $MainLayout/HBoxContainer/DetailsPanel/Descriptions
@onready var weapon_type: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponType
@onready var weapon_mag: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMag
@onready var weapon_dmg: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponDMG
@onready var weapon_max_mag: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponMaxMag
@onready var weapon_fire_rate: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponFireRate
@onready var weapon_reload: Label = $MainLayout/HBoxContainer/DetailsPanel/WeaponStats/WeaponReload


var weapon_data = {
	"VK-PDW": {
		"thumbnail": preload("res://Assets/Guns/gun_thumbnails/VK-PDW (QBZ191+X95 HYBRID).png"),
		"type": "SMG",
		"damage": 26,
		"fire_rate": "850 RPM",
		"mag_size": 40,
		"max_reserve": 240,
		"reload_time": 2.9,
		"description": "VK-PDW is a modified variant..."
	},
	# Add other weapons similarly
}

func show_weapon_info(weapon_id: String):
	var data = weapon_data[weapon_id]
	weapon_name.text = weapon_id
	weapon_img.texture = data["thumbnail"]
	weapon_dmg.text = "Damage: %s" % data["damage"]
	weapon_fire_rate.text = "Fire Rate: %s" % data["fire_rate"]
	weapon_mag.text = "Mag Size: %s" % data["mag_size"]
	weapon_max_mag.text = "Max Reserve: %s" % data["max_reserve"]
	weapon_reload.text = "Reload Time: %s" % data["reload_time"]
	# Add other stats...
	descriptions.text = data["description"]
