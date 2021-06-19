extends StaticBody2D

signal water_spend
signal gender

onready var life_area = $life_space/life_area
onready var area_radius = life_area.shape.radius

var save_value = "Persist_child"

var ray_directions = []
export var look_ahead = 150
export var num_rays = 12


var bush_time =0
var health_time =0

var cost = 4
var energy = 0
var energy_max = 0
var health = 10
var health_max = 10
var specie = "tree"
var hungry = false
onready var used_position = Vector2(-30, -600)


var evolution_1 = "null"
var evolution_1_text = ""
var cost_text_1 = 0

var evolution_2 = "null"
var evolution_2_text = ""
var cost_text_2 = 5

var evolution_3 = "null"
var evolution_3_text = ""
var cost_text_3 = 0


var gender
var opposite_gender
var happiness = 0
var max_happiness = 50
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
var pregnant = false
export(String) var random_noun
export(String) var random_adjective
var creature_name 
var age = 1
var adult_time = 0

onready var sprite = $Sprite

var tree_id

onready var love_bubble = preload("res://popup/love_bubble.tscn")
onready var popup_position = Vector2(0, -200)

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var default = preload("res://entities/tree/tree_adult/sprites/tree_good_health.png")
onready var thirsty = preload ("res://entities/tree/tree_adult/sprites/tree_bad_health.png")


onready var adult_scene = preload("res://entities/tree/tree_adult/tree.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():

	randomize()
		
	add_to_group("tree")
	add_to_group("vegetals")
	add_to_group("creature", true)
	add_to_group("Persist", true)
	add_to_group("persist_child", true)

	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")

	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)

	if gender == null :
		gender = "neutral"
		
	if tree_id == null :
		tree_id = str(self.get_instance_id())
	
	add_to_group(tree_id)

	ray_directions.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

#generate name :

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
	
	

func _on_Timer_timeout():
	

	
	health_time += 1
	
	if health_time >= 60 :
		health -= 1
		energy -= 1
		happiness -= 1
		
		if 	get_tree().root.get_node("Game/game_start").rain_falling == true :
			happiness += 5
			var happy_bubble = love_bubble.instance()
			self.add_child(happy_bubble)
			happy_bubble.position = used_position
		
		
		if 	get_tree().root.get_node("Game/game_start").water_count >= 2 :
			
			emit_signal("water_spend", 2)
			health += 1
			energy += 1
			happiness += 1
			if health > health_max :
				health = health_max
			
			var used = used_indicator.instance()
			self.add_child(used)
			used.position = used_position
		


				
		if health > float(health_max/6) :
			var animation = "default"
			sprite.play(animation)
		elif health > 0 :
			var animation = "thirsty"
			sprite.play(animation)
				
		elif health <= 0 :
			self.queue_free()
		age += 1	
		
		adult_time += 1
							
		health_time =0
	
	if adult_time >= 3000 :
		var adult = adult_scene.instance()
		adult.creature_name = self.creature_name
		adult.happiness = self.happiness
		adult.tree_id = self.tree_id
		adult.age = self.age
		
		get_tree().root.get_node("Game//game_start/YSort").add_child(adult)
		adult.position = self.position
		self.queue_free()

func _process(delta):
		
	if health <= 0 :
		self.queue_free()
	elif health > health_max :
		health = health_max
	
	if energy == 0 and hungry == false:
		hungry = true
		
	elif energy >= energy_max :
		energy = energy_max
		if hungry == true :
			hungry = false
	
	if happiness > max_happiness :
		happiness = max_happiness

	find_food()

func find_food() :
	var space_state = get_world_2d().direct_space_state
	
	for i in num_rays:
			
			var result = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead, [self])
			
			if result :
				var target = result["collider"]
				if target.is_in_group("fertilizer") and hungry == true and target.eatable == true  :
					happiness += target.quality
					health += target.quality
					energy += target.quality
					target.queue_free()
					
func _on_info_panel_pressed():

	var info_panel_scene = preload ("res://GUI/info_panel/info_panel.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.gender_text = gender
	info_panel.pv_text = str (health, "/", health_max)
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.energy = energy
	info_panel.energy_max = energy_max
	info_panel.energy_text = str (energy, "/", energy_max)
	info_panel.name_text = creature_name
	info_panel.happiness = happiness
	info_panel.max_happiness = max_happiness
	info_panel.love_happiness = love_happiness
	info_panel.pregnancy = pregnant
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
	info_panel.age = age
			
	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(info_panel)
	
func _on_plant_nourished(value):
	var popup = love_bubble.instance()
	self.add_child(popup)
	popup.position = popup_position
	happiness += value
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"health" : health,
		"health_time" : health_time,
		"happiness" : happiness,
		"creature_name" : creature_name,
		"tree_id" : tree_id,
		"age" : age,
		"adult_time" : adult_time,
		"hungry" : hungry
	}

	return save

func _draw():
	for i in num_rays:
		draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i] * look_ahead, Color(0, 255, 255), 3)
