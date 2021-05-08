extends StaticBody2D


signal strength_earned

var save_value = "Persist_child"

onready var pearl_timer = $pearl_generation
onready var sprite = $flower_sprite
onready var light = $Light2D

onready var area_radius = $Area2D/area.shape.radius

onready var produced_indicator = preload("res://popup/produced_spent_indicator/strength_produced_indicator.tscn")
onready var produced_position = Vector2(30, -120)
onready var used_position = Vector2(-30, -120)

var evolution_1 = "mega_strength_flower"
var evolution_1_text = "energy_path"
var cost_text_1 = 300

var evolution_2 = "null"
var evolution_2_text = ""
var cost_text_2 = 0

var evolution_3 = "null"
var evolution_3_text = ""
var cost_text_3 = 0



var cost = 1
var health = 180
var health_max = 180
var energy = 100
var energy_max = 100

var gender
var opposite_gender
var happiness = 500
var max_happiness = 1000
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var pregnant = false
export(String) var random_noun
export(String) var random_adjective
var creature_name 

var ressource_generation = 0
var specie = "big_strength_flower"# Declare member variables here. Examples:

var tree_id = str(self.get_instance_id())

func _ready():
	randomize()
	

	self.connect("strength_earned", get_tree().root.get_node("Game/game_start"), "_on_strength_earned")
	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	#pearl_timer.start()
	
	var animation = "default"
	sprite.play(animation)
	add_to_group ("flower")
	add_to_group ("vegetals")
	add_to_group ("big_strength_flower")
	add_to_group("tree")
	
	
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


func _process(delta):
	
	if health <= 0 :
		self.queue_free()


func _on_pearl_generation_timeout():
	
	ressource_generation += 1
	if ressource_generation >= 60 :
		emit_signal("strength_earned", 10)
		var produced = produced_indicator.instance()
		self.add_child(produced)
		produced.position = produced_position
		ressource_generation = 0
	#produced.position.y = self.position.y 
	#pearl_timer.start()	
	



func _on_water_button_pressed():
	
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
	info_panel.id = tree_id
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
		"health" : health,
		"ressource_generation" : ressource_generation,
		"name" : creature_name

	}
	return save
