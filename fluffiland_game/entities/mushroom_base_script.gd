extends Node2D

signal strength_earned
signal water_earned

var save_value = "Persist_child"

var ray_directions = []
export var look_ahead = 150
export var num_rays = 12

var evolution_1 = ""
var evolution_1_text = ""
var cost_text_1 = 0
var evolution_2 = ""
var evolution_2_text = ""
var cost_text_2 = 0
var evolution_3 = ""
var evolution_3_text = ""
var cost_text_3 = 0

var health = 0
var health_max = 0

var energy = 0
var energy_max = 0

var gender
var opposite_gender
var happiness = 0
var max_happiness = 0
var love_happiness = 0.8
var baby_happiness
var hungry = false
var age = 1
var strength_production = 0
var water_production = 0
var baby_chances = 0
var energy_needed_to_produce = 0
onready var seed_scene

onready var life_area = $fluffi_node_base/life_space/life_area
onready var area_radius = life_area.shape.radius
onready var child_radius = (life_area.shape.radius + 2) * 2

onready var sprite = $Sprite

export(String) var random_noun
export(String) var random_adjective
var creature_name 

onready var timer = $fluffi_node_base/Timer
onready var animation = $Sprite/AnimatedSprite

onready var produced_indicator = preload("res://popup/produced_spent_indicator/strength_produced_indicator.tscn")
onready var produced_indicator_2 = preload("res://popup/produced_spent_indicator/water_used_indicator.tscn")
onready var produced_position = Vector2(0, -120)

var ressource_generation = 0
var id = str(self.get_instance_id())

onready var hungry_bubble_scene = preload("res://popup/fertilizer_bubble.tscn")
var bubble_position = Vector2(0, -150)
var specie
var orientation_choice

var other_animation_playing = false

var dead = false

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
	if other_animation_playing == false :
		animation.play("default")
	if orientation_choice == null :
		orientation_choice = randi()% 100 + 1
	if orientation_choice > 50 :
		sprite.scale.x = -1
	
	add_to_group(specie, true)
	add_to_group("creature", true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	add_to_group("tree", true)
	add_to_group(id, true)
	
	self.connect("strength_earned", get_tree().root.get_node("Game/game_start"), "_on_strength_earned")
	self.connect("water_earned", get_tree().root.get_node("Game/game_start"), "_on_water_earned")	
	timer.connect("timeout", self, "_on_Timer_timeout")
	animation.connect("animation_finished", self , "_on_AnimatedSprite_animation_finished")
	
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
	
	if hungry == true :
		var hungry_bubble = hungry_bubble_scene.instance()
		self.add_child(hungry_bubble)
		hungry_bubble.position = bubble_position

	gender = "neutral"
		
	ray_directions.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

func _process(_delta):
	
	
	if other_animation_playing == false :
		animation.play("default")
	
	if health <= 0 :
		self.queue_free()
	elif health > health_max :
		health = health_max
	
	if energy < energy_needed_to_produce and hungry == false:
		var hungry_bubble = hungry_bubble_scene.instance()
		self.add_child(hungry_bubble)
		hungry_bubble.position = bubble_position
		hungry = true
		
	if energy > 0 :
		for node in get_children() :
			if node.is_in_group("popup") :
				node.queue_free()

		
	elif energy >= energy_max :
		energy = energy_max
		if hungry == true :
			hungry = false
			
			
	baby_happiness = float(love_happiness) * float(max_happiness)
	if happiness > max_happiness :
		happiness = max_happiness

	find_food()

func find_food() :
	var space_state = get_world_2d().direct_space_state
	
	for i in num_rays:
			
			var result = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead, [self])
			
			if result :

				var target = result["collider"]

				if target.is_in_group("poop") and hungry == true and target.eatable == true :
					other_animation_playing = true
					animation.play("eating")
					self.happiness += target.quality
					self.health += target.quality
					self.energy += target.quality
					target.queue_free()
					
func _on_AnimatedSprite_animation_finished():				
	other_animation_playing = false
	
	if dead == true :
		self.queue_free()


func _on_Timer_timeout():
	ressource_generation += 1

	if ressource_generation >= 60 :
		
		var rain = get_tree().root.get_node("Game/game_start").rain_falling
		if rain == false and energy >= energy_needed_to_produce :
			emit_signal("strength_earned", strength_production)
			energy -= energy_needed_to_produce
			var produced = produced_indicator.instance()
			self.add_child(produced)
			produced.position = produced_position
			
		elif rain == true and energy >= energy_needed_to_produce  :
			emit_signal("water_earned", water_production)
			energy -= energy_needed_to_produce
			var produced = produced_indicator_2.instance()
			self.add_child(produced)
			produced.position = produced_position
			
		age += 1
		
		if happiness >= baby_happiness :
			var seed_chances = randi()%100+1
			if seed_chances >= baby_chances :
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
			happiness -= 1
	
	
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
		"save_value" : save_value,
		"health" : health ,
		"energy" : energy,
		"happiness" : happiness,
		"creature_name" : creature_name,
		"ressource_generation" : ressource_generation,
		"age" : age,
		"hungry" : hungry,
		"orientation_choice" : orientation_choice
	}
	return save



#func _draw():
#	for i in num_rays:
#		draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i] * look_ahead, Color(255, 255, 0), 5)
#		
