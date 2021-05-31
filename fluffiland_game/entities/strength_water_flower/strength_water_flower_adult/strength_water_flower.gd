extends StaticBody2D


signal strength_earned
signal water_earned

var save_value = "Persist_child"

onready var pearl_timer = $pearl_generation
onready var sprite = $flower_sprite
onready var light = $Light2D
onready var light_animation = $AnimationPlayer

onready var area_radius = $Area2D/area.shape.radius

onready var produced_indicator = preload("res://popup/produced_spent_indicator/strength_earned_particle.tscn")
onready var produced_indicator2 = preload("res://popup/produced_spent_indicator/water_produced_indicator.tscn")
onready var produced_position = Vector2(0, -120)
onready var produced_position2 = Vector2(0, -120)


var evolution_1 = "big_strength_water_flower"
var evolution_1_text = "ressource_path"
var cost_text_1 = 35

var evolution_2 = "null"
var evolution_2_text = ""
var cost_text_2 = 0

var evolution_3 = "null"
var evolution_3_text = ""
var cost_text_3 = 0

var health = 5
var health_max = 5
var energy = 0
var energy_max = 0

var gender
var opposite_gender
var happiness = 0
var max_happiness = 30
var love_happiness = 0.8
var pregnant = false
export(String) var random_noun
export(String) var random_adjective
var creature_name 
var age = 1

var hungry_time = 0
onready var hungry_bubble_scene = preload("res://popup/fertilizer_bubble.tscn")
var bubble_position = Vector2(0, -150)

var ressource_generation = 0
var specie = "strength_water_flower"# Declare member variables here. Examples:


var id = str(self.get_instance_id())

onready var seed_scene = preload("res://entities/strength_water_flower/strength_water_flower_egg/strength_water_flower_egg.tscn")

func _ready():
	randomize()
	
	self.connect("water_earned", get_tree().root.get_node("Game/game_start"), "_on_water_earned")
	self.connect("strength_earned", get_tree().root.get_node("Game/game_start"), "_on_strength_earned")
	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	#pearl_timer.start()
	
	var animation = "default"
	sprite.play(animation)
	add_to_group("creature", true)
	add_to_group ("flower")
	add_to_group ("vegetals")
	add_to_group ("strength_water_flower")
	add_to_group("tree")
	add_to_group(id, true)
	
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
	
	light_animation.seek(60 - get_tree().root.get_node("Game/game_start/end_of_day").get_time_left() , true)
	
	if gender == null :
		gender = "neutral"
	print ("str_wtr_flower_here")
	emit_signal("gender",self)
	
	print (creature_name, " ", specie, " ",happiness)
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


func _process(_delta):
	
	if health <= 0 :
		self.queue_free()
	
	if health > health_max :
		health = health_max

	
func _on_pearl_generation_timeout():
	
	ressource_generation += 1
	if ressource_generation >= 60 :
		var rain = get_tree().root.get_node("Game/game_start").rain_falling
		if rain == true :
			emit_signal("water_earned", 2)
			var produced = produced_indicator2.instance()
			self.add_child(produced)
			produced.position = produced_position
		elif rain == false :
			emit_signal("strength_earned", 2)
			var produced = produced_indicator.instance()
			self.add_child(produced)
			produced.position = produced_position
		age += 1
		
		if happiness >= love_happiness :
				var seed_chances = randi()%100+1
				if seed_chances >= 90 :
					var count = rand_range(0, 2)
					var radius = Vector2(area_radius, 0)
					var center = self.position

					var step = float(count) * PI 
					var spawn_pos = center + radius.rotated(step)

					var seed_grow = seed_scene.instance()
					seed_grow.set_position(spawn_pos)
					get_tree().root.get_node("Game/game_start/YSort").add_child(seed_grow)
				
		ressource_generation = 0
		
	if health <= 1 :
		var hungry_bubble = hungry_bubble_scene.instance()
		self.add_child(hungry_bubble)
		hungry_bubble.position = bubble_position
	
	if health > 1 :
		for node in get_children() :
			if node.is_in_group("popup") :
				node.queue_free()

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
	info_panel.mood = float(happiness)/float(max_happiness)
	info_panel.love_happiness = love_happiness
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
	info_panel.age = age
			
	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(info_panel)
	
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"health" : health,
		"happiness" : happiness,
		"ressource_generation" : ressource_generation,
		"creature_name" : creature_name,
		"age" : age,
		"hungry_time" : hungry_time

	}
	return save
