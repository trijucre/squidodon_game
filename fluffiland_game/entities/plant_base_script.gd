extends StaticBody2D

signal water_spend

onready var stats = $stats

onready var life_area = $life_space/life_area
onready var area_radius = life_area.shape.radius
onready var child_radius = (life_area.shape.radius + 2) * 2

var save_value = "Persist_child"

var ray_directions = []
export var look_ahead = 150
export var num_rays = 12


var bush_time  = 0
var bush_capacity = 0

var energy = 0
var energy_max = 0 
var health = 0
var health_max = 0
var specie =""
var water_consomption = 0
onready var used_position = Vector2(0, -60)


var evolution_1 =""
var evolution_1_text =""
var cost_text_1 = 0

var evolution_2 =""
var evolution_2_text =""
var cost_text_2 =0

var evolution_3 =""
var evolution_3_text=""
var cost_text_3 = 0

var gender
var opposite_gender
var happiness = 0
var max_happiness = 0
var relative_happiness = 0
var love_happiness = 0.8
var baby_happiness= 0
var hungry = false
export(String) var random_noun
export(String) var random_adjective
var creature_name 
var age = 1
var reproduction_chances = 0

var bush_scene 
var seed_scene 
onready var sprite = $Sprite



var tree_id
var rngx = RandomNumberGenerator.new()
var rngy = RandomNumberGenerator.new()

onready var love_bubble = preload("res://popup/love_bubble.tscn")
onready var smile_bubble = preload("res://popup/happy_bubble.tscn")
onready var hungry_bubble_scene = preload("res://popup/fertilizer_bubble.tscn")
onready var popup_position = Vector2(0, -20)

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var default = preload("res://entities/tree/tree_adult/sprites/tree_good_health.png")
onready var thirsty = preload ("res://entities/tree/tree_adult/sprites/tree_bad_health.png")
var bush_produced = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	print (bush_scene, "plant base script")
		

	add_to_group("Persist", true)
	add_to_group("persist_child", true)

	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")

	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
		
	relative_happiness = float(happiness)/float(max_happiness)
	baby_happiness  = float(love_happiness) * float(max_happiness)
	
	gender = "neutral"
		
	if tree_id == null :
		tree_id = str(self.get_instance_id())
	
	add_to_group(tree_id)
		
	ray_directions.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
		
	if hungry == true :
		var hungry_bubble = hungry_bubble_scene.instance()
		self.add_child(hungry_bubble)
		hungry_bubble.position = used_position
	_on_ready()
func _on_ready() :
	print ("test plant base on ready function")
	
func _process(_delta):
		
	if health <= 0 :
		self.queue_free()
	elif health > health_max :
		health = health_max
	
	if energy > 0 and hungry == false:
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
				if target.is_in_group("fertilizer") and target.eatable == true  :
					
					happiness += target.quality
					health += target.quality
					energy += target.quality
					target.queue_free()
					
					var happy_bubble = smile_bubble.instance()
					self.add_child(happy_bubble)
					happy_bubble.position = used_position
					

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
	
	bush_time += 1
	
	
	if bush_time >= 60 :
		bush_produced = get_tree().get_nodes_in_group(tree_id).size()

		if bush_produced <= bush_capacity :
			var count = rand_range(0, 2)
			var bush_radius = randi()% int(child_radius) + int(area_radius)
			var radius = Vector2(bush_radius, 0)
			var center = self.position
			var step = float(count) * PI 
			var spawn_pos = center + radius.rotated(step)

			var tree_bush = bush_scene.instance()
			tree_bush.id = tree_id
			get_tree().root.get_node("Game/game_start/YSort").add_child(tree_bush)

			tree_bush.position = spawn_pos
			

		
			
		health -= 1
		energy -= 1
		happiness -= 1
		
		if 	get_tree().root.get_node("Game/game_start").rain_falling == true :
			happiness += 5
			var happy_bubble = love_bubble.instance()
			self.add_child(happy_bubble)
			happy_bubble.position = used_position
		
		if 	get_tree().root.get_node("Game/game_start").water_count >= water_consomption :
			
			emit_signal("water_spend", water_consomption)
			health += 1
			energy += 1
			happiness += 1
			if health > health_max :
				health = health_max
			
			var used = used_indicator.instance()
			self.add_child(used)
			used.position = used_position

		age += 1	
		
		if happiness >= baby_happiness :
			var seed_chances = randi()%100+1
			if seed_chances >= reproduction_chances :
				var count = rand_range(0, 2)
				var radius = Vector2(child_radius, 0)
				var center = self.position

				var step = float(count) * PI 
				var spawn_pos = center + radius.rotated(step)

				var seed_grow = seed_scene.instance()
				seed_grow.set_position(spawn_pos)
				get_tree().root.get_node("Game/game_start/YSort").add_child(seed_grow)
								
		
		bush_time = 0
		
	if energy <= 0 :
		var hungry_bubble = hungry_bubble_scene.instance()
		self.add_child(hungry_bubble)
		hungry_bubble.position = used_position
	
	if energy > 0 :
		for node in get_children() :
			if node.is_in_group("popup") :
				node.queue_free()
	


	
func _on_bush_produced():
	bush_produced +=1


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

	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"health" : health,
		"energy" : energy,
		"bush_produced" : bush_produced,
		"bush_time" : bush_time,
		"happiness" : happiness,
		"creature_name" : creature_name,
		"tree_id" : tree_id,
		"age" : age, 
		"hungry" : hungry
	}

	return save
