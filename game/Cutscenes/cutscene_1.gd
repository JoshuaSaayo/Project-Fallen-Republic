extends Control

var lines = [
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_1.jpg"},
	{ "name": "[VO – News Anchor’]"},
	{ "text": "In a historic shift across the southern Pacific, three culturally aligned nations — Sukhothaya, Xiengkha, and Thanmyo — have officially signed the Tri-South Pacific League Accord."},
	{ "text": "TRI-SOUTH PACT FINALIZED – NEW ALLIANCE EMERGES"},
	{ "text": '“The TSPL promises mutual economic growth, resource-sharing, and a unified defense posture.”'},
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_1.2.jpg"},
	{ "name": "lorem"},
	{ "text": '“But not everyone is celebrating…”'},
	{ "name": "TSPL"},
	{ "text": "Kampura must choose solidarity or isolation."},
	{ "text": '“The Kampura-Preyvatan Confederate Union, or KPCU, has rejected TSPL’s invitation—sparking rising tensions across shared borders.”'},
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_1.3.jpg" },
	{ "name": "Female Reporter"},
	{ "text": "“Breaking news: Mass illness is reported across Thanmyo’s eastern border towns. Local authorities blame toxic runoff from Kampura’s energy grid near Namkhet Valley.”" },
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_2.jpg"},
	{ "name": "TSPL Spokesman" },
	{ "text": "“This is a deliberate act. The imperialist KPCU has poisoned our lands—again.”" },
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_3.jpg" },
	{ "name": "Female Reporter" },
	{ "text": "“TSPL officials now claim rainfall is contaminated due to emissions from Chakranet 02 — calling it an ‘environmental war crime.’”" },
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_4.jpg" },
	{ "text": "lol" }
]


var index = 0
var current_index = 0
var current_name = ""  # Track current speaker

@onready var dialogue_label = $DialogueBoxPanel/DialogueText
@onready var next_btn: Button = $NextBtn
@onready var background_image: TextureRect = $Panel/TextureRect
@onready var name_label: Label = $NamePanel/NameLabel


func _ready():
	show_next_line()
	
func _on_next_btn_pressed():
	show_next_line()
	if current_index >= lines.size():
		start_game()
		return

func show_next_line():
	while current_index < lines.size():
		var entry = lines[current_index]
		current_index += 1

		if entry.has("name"):
			current_name = entry["name"]
			name_label.text = current_name

		if entry.has("bg"):
			background_image.texture = load(entry["bg"])

		if entry.has("text"):
			name_label.text = current_name
			dialogue_label.text = entry["text"]
			return  # Only wait for user input after displaying text

	# If all lines are done
	print("End of dialogue")

	# Keep showing current name even if "name" isn't updated
	name_label.text = current_name
		
	current_index += 1
	
func start_game():
	get_tree().change_scene_to_file("res://Maps/map_1.tscn")  # change this to your main scene
