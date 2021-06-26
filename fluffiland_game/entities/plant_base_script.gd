extends StaticBody2D

signal water_spend
signal strength_spend

onready var stats = $stats

onready var life_area = $fluffi_node_base/life_space/life_area
onready var area_radius = life_area.shape.radius
onready var child_radius = (life_area.shape.radius + 1) * 2

var save_value = "Persist_child"

var ray_directions = []
export var look_ahead = 75
export var num_rays = 18

onready var timer = $fluffi_node_base/Timer
onready var animation = $Sprite/AnimatedSprite
onready var button = $info_panel

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
var love_happiness = 0.8
var baby_happiness= 0
var hungry = false
var good_health = health_max/2
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
var popup_position = Vector2(0, 0)

onready var used_indicator = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
var bush_produced = 0

var orientation_choice

func _ready():
	
	if orientation_choice == null :
		orientation_choice = randi()% 100 + 1
	if orientation_choice > 50 :
		sprite.scale.x = -1
		
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	add_to_group(specie, true)
	add_to_group("tree",true)
	add_to_group("vegetals",true)
	add_to_group("creature", true)

	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	self.connect("strength_spend", get_tree().root.get_node("Game/game_start"), "_on_strength_spend")
	timer.connect("timeout", self, "_on_Timer_timeout")
	button.connect("mouse_entered", self, "show_stat")
	button.connect("mouse_exited", self, "hide_stat")
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
		
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

	
func _process(_delta):
	print ("plant energy ", energy)
	if health <= 0 :
		self.queue_free()
	elif health > health_max :
		health = health_max
	
		if energy < 0 :
			energy = 0

	elif energy >= energy_max and health >= health_max/2 :
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
					animation.play("eating")
					happiness += target.quality
					health += target.quality
					energy += target.quality
					target.queue_free()
					
					var happy_bubble = love_bubble.instance()
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
	
func show_stat():
	print(creature_name," is hovered")
	var info_panel_scene = preload ("res://GUI/info_panel/info_panel.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.gender_text = gender
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.energy = energy
	info_panel.energy_max = energy_max
	info_panel.name_text = creature_name
	info_panel.age = age
			
	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(info_panel)

func hide_stat():
	for node in get_tree().get_nodes_in_group("info_panel"):
		node.queue_free()

func _on_Timer_timeout():

	
	bush_time += 1
	
	
	if bush_time >= 60 :
		bush_produced = get_tree().get_nodes_in_group(tree_id).size()

		if bush_produced <= bush_capacity and energy >= water_consomption :
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
			energy -= water_consomption

		
			
		health -= 1
		happiness -= 1
		
		
		if 	get_tree().root.get_node("Game/game_start").water_count >= water_consomption :
			
			emit_signal("water_spend", water_consomption)

			energy += water_consomption
			if energy > energy_max :
				energy = energy_max
			
		if 	get_tree().root.get_node("Game/game_start").strength_count >= 1 :
			
			emit_signal("strength_spend", 1)

			health += 1
			happiness += 1
			if health > health_max :
				health = health_max
	

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
		
	if (energy <= 0 or health < good_health) and hungry == false:

		var hungry_bubble = hungry_bubble_scene.instance()
		self.add_child(hungry_bubble)
		hungry_bubble.position = used_position
		hungry = true
	
	if energy > 0 and health >= good_health :
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
		"hungry" : hungry,
		"orientation_choice" : orientation_choice
	}

	return save
