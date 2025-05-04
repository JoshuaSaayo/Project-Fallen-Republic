extends Control

var lines = [
		
	{ "text": "[VISUAL: NEWS MONTAGE – GRAINY TV FOOTAGE]"},
	{ "text": '[VO – News Anchor]: “In a historic shift across the southern Pacific, three culturally aligned nations — Sukhothaya, Xiengkha, and Thanmyo — have officially signed the Tri-South Pacific League Accord…”'},
	{ "text": "[TEXT ON SCREEN: ‘TRI-SOUTH PACT FINALIZED – NEW ALLIANCE EMERGES’]"},
	{ "text": '“The TSPL promises mutual economic growth, resource-sharing, and a unified defense posture.”'},
	{ "text": "[VISUAL: Parade, flags, leaders shaking hands]"},
	{ "text": '“But not everyone is celebrating…”'},
	{ "text": "[TEXT ON SCREEN: ‘TSPL: “Kampura must choose solidarity or isolation.”’]"},
	{ "text": '“The Kampura-Preyvatan Confederate Union, or KPCU, has rejected TSPL’s invitation—sparking rising tensions across shared borders.”'},
	{ "text": '[TEXT FADES IN: ‘KPCU DENIES UNITY: CITES “EXPANSIONIST AGENDA”’]'},
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_1.jpg"},
	
	{ "text": "[VISUAL: CHAOTIC NEWS FEEDS, BORDER TOWN FOOTAGE, MASKED VILLAGERS]", "bg": "res://Assets/Game_vn/visual_intro/cutscene_2.jpg" },
	{ "text": "[VO – Female Reporter (urgent tone)]:" },
	{ "text": "“Breaking news: Mass illness is reported across Thanmyo’s eastern border towns... Local authorities blame toxic runoff from Kampura’s energy grid near Namkhet Valley.”" },
	{ "text": "[TEXT: ‘POISONED WATERS – RIVER OF DEATH?’]" },
	{ "text": "[VISUAL: Dead fish, villagers protesting, fire near irrigation lines]" },
	{ "text": "[VO – TSPL Spokesman]:" },
	{ "text": "“This is a deliberate act. The imperialist KPCU has poisoned our lands—again.”" },
	{ "text": "[VISUAL: Poster – ‘KPCU IS THE WEST’S PUPPET!’]" },
	{ "text": "[VO – Female Reporter]:" },
	{ "text": "“TSPL officials now claim rainfall is contaminated due to emissions from Chakranet 02 — calling it an ‘environmental war crime.’”" },
	{ "text": "[VISUAL: Fake leaked footage of ‘chemical barrels’ dumped near water]" },
	{ "text": "[BROADCAST ENDS IN STATIC]" },
	{ "bg": "res://Assets/Game_vn/visual_intro/cutscene_2.jpg"}
]


var index = 0
var current_index = 0

@onready var dialogue_label = $DialogueBoxPanel/RichTextLabel
@onready var next_btn: Button = $NextBtn
@onready var background_image: TextureRect = $Panel/TextureRect


func _ready():
	show_next_line()
	
func _on_next_btn_pressed():
	show_next_line()

func show_next_line():
	if current_index >= lines.size():
		start_game()
		return
	var entry = lines[current_index]
	
	# Only update text if the key exists
	if entry.has("text"):
		dialogue_label.text = entry["text"]
	else:
		dialogue_label.text = ""  # Clear if no text
	# Only update background if the key exists
	if entry.has("bg"):
		background_image.texture = load(entry["bg"])
	
	current_index += 1


func start_game():
	get_tree().change_scene_to_file("res://Maps/map_1.tscn")  # change this to your main scene
