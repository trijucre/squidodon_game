extends StaticBody2D

signal strength_earned

var save_value = "Persist_child"

var evolution_1 = "water_flower"
var evolution_1_text = "flower_path"
var cost_text_1 = 8
var evolution_2 = "strength_flower"
var evolution_2_text = "root_path"
var cost_text_2 = 6
var evolution_3 = "null"
var evolution_3_text = ""
var cost_text_3 = 0

var health = 1
var health_max = 1

var energy = 1
var energy_max = 1

var gender
var opposite_gender
var happiness = 500
var max_happiness = 1000
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var pregnant = false

onready var sprite = $sprite
onready var area_radius = $Area2D/area.shape.radius
export(String) var random_noun
export(String) var random_adjective
var creature_name 

onready var produced_indicator = preload("res://popup/produced_spent_indicator/strength_produced_indicator.tscn")
onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var produced_position = Vector2(30, -120)
onready var used_position = Vector2(-30, -120)

var ressource_generation = 0
var sleep_hour
var sleeping = false
var id = str(self.get_instance_id())

var specie = "fluffishroom"

func load_file(file_path):
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	return text
	
func get_random_word_from_file(file_path):
	var text = load_file(file_path).strip_edges()
	var words = text.split("\n")
	for i in range(words.size()):
		# here you can add whatever you want to remove
		# any unwanted characters
		words[i] = words[i].replace(",", "")
		words[i] = words[i].replace(".", "")


	return words[randi() % words.size()]
	
	

func _ready():
	
	add_to_group(specie, true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	add_to_group("tree", true)
	add_to_group(id, true)
	
	self.connect("strength_earned", get_tree().root.get_node("Game/game_start"), "_on_strength_earned")
	
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
	
	sleep_hour = 0.7 + (randf() * 0.2 + 0.05)
	
	if gender == null :
		gender = "neutral"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	
	var sleep = get_tree().root.get_node("Game/game_start/daylight").get_color().r
	

	if sleep < sleep_hour :
		set_sleep()
		sleeping = true
	
func set_sleep():

	var animation = "side_sleep"
	sprite.play(animation)


func _on_info_panel_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel/info_panel.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.gender_text = ""
	info_panel.pv_text = str (health, "/", health_max)
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.energy = energy
	info_panel.energy_max = energy_max
	info_panel.energy_text = str (energy, "/", energy_max)
	info_panel.name_text = creature_name
	info_panel.mood = 50
	info_panel.love_happiness = 50
	info_panel.pregnancy = false
	info_panel.id = id
	info_panel.evolution_1 = evolution_1
	info_panel.evolution_2 = evolution_2
	info_panel.evolution_3 = evolution_3
	info_panel.evolution_1_text = evolution_1_text	
	info_panel.evolution_2_text = evolution_2_text
	info_panel.evolution_3_text = evolution_3_text
	info_panel.cost_text_1 = cost_text_1
	info_panel.cost_text_2 = cost_text_2
	info_panel.cost_text_3 = cost_text_3
	
			
	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(info_panel)
	

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value,
		"creature_name" : creature_name,
		"sleep_hour" : sleep_hour,
		"ressource_generation" : ressource_generation
	}
	return save



func _on_Timer_timeout():
	ressource_generation += 1
	
	if ressource_generation >= 60 :
		emit_signal("strength_earned", 1)
		var produced = produced_indicator.instance()
		self.add_child(produced)
		produced.position = produced_position
		ressource_generation = 0

	#produced.position.y = self.position.y 
	#pearl_timer.start()	
	
