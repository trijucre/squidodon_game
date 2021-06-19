extends StaticBody2D


signal strength_earned
signal water_earned

var save_value = "Persist_child"

var ray_directions = []
export var look_ahead = 150
export var num_rays = 12

onready var pearl_timer = $pearl_generation
onready var sprite = $flower_sprite
onready var light = $Light2D
onready var light_animation = $AnimationPlayer

onready var life_area = $life_space/life_area
onready var area_radius = life_area.shape.radius
onready var child_radius = (life_area.shape.radius + 1) * 2

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
var energy = 20
var energy_max = 20

var gender
var opposite_gender
var happiness = 0
var max_happiness = 30
var love_happiness = 0.8
var hungry = false
var pregnant = false
export(String) var random_noun
export(String) var random_adjective
var creature_name 
var age = 1

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
		
	ray_directions.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
	
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

	find_food()

func find_food() :
	var space_state = get_world_2d().direct_space_state
	
	for i in num_rays:
			
			var result = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead, [self])
			
			if result :
				var target = result["collider"]
				if target.is_in_group("poop") and hungry == true and target.eatable == true  :
					print (creature_name," ", "has found poop")
					happiness += target.quality
					health += target.quality
					energy += target.quality
					target.queue_free()
					


func _on_pearl_generation_timeout():
	
	ressource_generation += 1
	if ressource_generation >= 60 :
		var rain = get_tree().root.get_node("Game/game_start").rain_falling
		if rain == true :
			emit_signal("water_earned", 2)
			energy -= 2
			var produced = produced_indicator2.instance()
			self.add_child(produced)
			produced.position = produced_position
		elif rain == false :
			emit_signal("strength_earned", 2)
			energy -= 2
			var produced = produced_indicator.instance()
			self.add_child(produced)
			produced.position = produced_position
		age += 1
		
		if happiness >= love_happiness :
				var seed_chances = randi()%100+1
				if seed_chances >= 90 :
					var count = rand_range(0, 2)
					var radius = Vector2(child_radius, 0)
					var center = self.position

					var step = float(count) * PI 
					var spawn_pos = center + radius.rotated(step)

					var seed_grow = seed_scene.instance()
					seed_grow.set_position(spawn_pos)
					get_tree().root.get_node("Game/game_start/YSort").add_child(seed_grow)
				
		ressource_generation = 0
		

		if energy <= 0 :
			health -= 1
	
	if energy <= 0 :
		var hungry_bubble = hungry_bubble_scene.instance()
		self.add_child(hungry_bubble)
		hungry_bubble.position = bubble_position
	
	if energy > 0 :
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
	info_panel.happiness = happiness
	info_panel.max_happiness = max_happiness
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
		"energy" : energy,
		"happiness" : happiness,
		"ressource_generation" : ressource_generation,
		"creature_name" : creature_name,
		"age" : age,
		"hungry" : hungry

	}
	return save
	
func _draw():
	for i in num_rays:
		draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i] * look_ahead, Color(255, 255, 0), 5)
