extends Node2D

#saving variables
var save_value = "Persist_parent"

var tilemap_Ground 
var tilemap_Water

var xmap = 100
var ymap = 50
var tilesize = 100

var saved = false

var noise_creation 
var noise_variations
var custom_gradient
var size_gradient = 2.2
var noise

var map_size = Vector2(xmap, ymap)
var possible_position = Vector2(1, -0.3)

var grass_caps = Vector2(1, -0.5)
var ground_caps = Vector2(1, -0.7) 
var water_caps = Vector2(1, -1)
var tree_caps = Vector3(0.5, -0.2, 0.1) 
var animal_cap = Vector2(0.5, 0)

var robot_repaired
#robot_container

var tree_hidden = false
#var number_animals = 5 #xmap/20
#var pearl_count = 6
var water_count = 10
var water_max = 1000
var strength_count = 10
var strength_max = 1000
var mana_count = 30
var mana_max = 1000
var rain_falling = false

onready var rain_scene = preload("res://other/rain_scene/rain_scene.tscn")
onready var rain_ground_scene = preload("res://other/rain_scene/rain_scene_ground.tscn")
onready var rain_node = $rain_drop
onready var rain_ground_node = $rain_ground
onready var weather_animation = $AnimationPlayer
var rain_chance

#onready var big_tree = preload("res://bigtree.tscn")
onready var parasite_algae = preload ("res://entities/parasite_algae/parasit_algae_sprout/parasite_alagae_sprout.tscn")


onready var fluffisprout = preload ("res://entities/fluffisprout/fluffisprout.tscn")

#onready var orca_bear_node = orca_bear.instance()

onready var water_point = preload("res://constructs/water_point/water_point.tscn")
onready var hill = preload("res://constructs/hill/hill.tscn")
onready var info_construct = preload ("res://GUI/info_construct/info_construct.tscn")
onready var meteor_scene = preload ("res://other/meteor/meteor.tscn")
onready var meteor_number = 5

onready var robot_scene = preload("res://entities/robot/robot/robot.tscn")
onready var robot_cook_scene = preload ("res://entities/robot/robot_cook/robot_cook.tscn")
onready var new_robot = preload ("res://entities/robot/robot/robot.tscn")
onready var infos_robot_scene = preload("res://GUI/info_robot/info_repaired_robot/info_robot.tscn")
onready var pot_scene = preload("res://constructs/pot/pot.tscn")
onready var robot_hug_scene = preload ("res://entities/robot/robot_hug/robot_hug.tscn")

var parasite_algae_number = (xmap + ymap) / 50
var day_count = 1
var year = 1
signal day_number
signal year
#signal diversity_number
onready var pause_menu_scene = preload ("res://GUI/pause_menu/pause_menu.tscn")

signal end_of_day
signal number_of_water
signal number_of_strength
signal number_of_strength_max
signal number_of_mana
signal number_of_mana_max
signal object_produced
#var first_animal_instance = 10
#var second_animal_instance = 10


func _ready():
	
	randomize()
	
	add_to_group("Persist", true)
	add_to_group("Persist_parent", true)

	emit_signal("number_of_strength", self)
	emit_signal("number_of_water", self)
	emit_signal("number_of_mana", self)
	
	tilemap_Ground = get_tree().root.get_node("Game/Ground")
	tilemap_Water = get_tree().root.get_node("Game/Water")
	
	emit_signal ("day_number", self)
	emit_signal ("year", self)

# Called when the node enters the scene tree for the first time.
	self.connect("end_of_day", get_tree().root.get_node("Game"), "_on_end_of_day")


	if saved == false :
		robot_repaired = false
		noise_variations = randi()
	
	#gradient to make the noise fade away at the borders of the screen
	custom_gradient = CustomGradientTexture.new()
	custom_gradient.gradient = Gradient.new()
	custom_gradient.type = CustomGradientTexture.GradientType.RADIAL
	custom_gradient.size = Vector2( xmap * 2,   ymap * 2)
	
	#custom_gradient.resize = Vector2(xmap, ymap)
	
	
	noise =  OpenSimplexNoise.new()
	noise.seed = noise_variations
	noise.octaves = 2
	noise.period = 15
	noise.persistence = 0.3
	
	#each tilemap is imported (the order is defined in the tree)
	make_water_map()
	make_ground_map()
	make_grass_map()
	

	#make_tree()
	$Camera2D.position.x = xmap*tilesize/2
	$Camera2D.position.y = ymap*tilesize/2	

	if robot_repaired == false :
		#robot_button.set_disabled(true)
		pass
	
	if rain_falling == true :
		set_rain()
	
	if saved == false :
		import_robot()
		import_object(robot_cook_scene)
		import_object(robot_hug_scene)
		import_object(water_point)
	#if saved == false :
	#	import_object(pot_scene)
	
	#if saved == false :
	#	for i in meteor_number :
	#		import_meteor()
	
	#if saved == false :
		#for i in parasite_algae_number :
	#		import_parasite_algae()

	saved = true
	
func _process(_delta):
	

	if Input.is_action_just_pressed('pause'):
		var pause_menu = pause_menu_scene.instance()
		
		get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(pause_menu)
		
	
func make_water_map():
	for x in map_size.x:
		for y in map_size.y:
			#get the data of the gradient
			var data = custom_gradient.get_data()
			#lock the data before get the pixel color
			data.lock()
			var gradient_value = data.get_pixel(x + xmap * 0.5 , y + ymap * 0.5).r * size_gradient
			data.unlock()
			var a = noise.get_noise_2d(x,y)
			
			a -= gradient_value
			
			if a < water_caps.x and a > water_caps.y:
				$Water.set_cell(x,y,0)
	$Water.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	
func make_ground_map():
	for x in map_size.x:
		for y in map_size.y:
			
			var data = custom_gradient.get_data()
			data.lock()
			var gradient_value = data.get_pixel(x + xmap * 0.5 , y + ymap * 0.5).r * size_gradient
			
			var a = noise.get_noise_2d(x,y)
			data.unlock()
			a -= gradient_value
			
			if a < ground_caps.x and a > ground_caps.y:
				$Ground.set_cell(x,y,0)
	$Ground.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	
func make_grass_map():
	for x in map_size.x:
		for y in map_size.y:
			
			var data = custom_gradient.get_data()
			data.lock()
			var gradient_value = data.get_pixel(x + xmap * 0.5 , y + ymap * 0.5).r * size_gradient
			
			var a = noise.get_noise_2d(x,y)
			data.unlock()
			
			a -= gradient_value
			if a < grass_caps.x and a > grass_caps.y:
				$Grass.set_cell(x,y,0)
	$Grass.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))

				
func _on_fluffi_pressed(gender):
	var item_name = "fluffisprout"
	var item_load_scene = "res://items_selected/"+ item_name + "_item/" + item_name + "_item.tscn"
	var animal_scene = load(item_load_scene)
	var animal = animal_scene.instance()
	animal.gender = gender
	get_tree().root.get_node("Game/game_start/YSort").add_child(animal)


func _on_construct_panel_pressed(ressource_given_count_max, ressource_given, ressource_transferred, id) :

	var info_panel = info_construct.instance()
	
	if ressource_given == "water" :
		if water_count > ressource_given_count_max :
			info_panel.ressource_given_count_max = ressource_given_count_max
		else :
			info_panel.ressource_given_count_max = water_count
	
	if ressource_given == "strength" :
		if strength_count > ressource_given_count_max :
			info_panel.ressource_given_count_max = ressource_given_count_max
		else :
			info_panel.ressource_given_count_max = strength_count
			
	info_panel.ressource_given = ressource_given
	info_panel.ressource_transferred = ressource_transferred
	info_panel.id = id
	
	get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(info_panel)
	info_panel.position = Vector2 (1500, 100)

#func _on_water_earned(water_value):
#	water_count += water_value
#	emit_signal("number_of_water", self)
	
func _on_strength_earned(strength_value):
	if strength_count < strength_max :
		strength_count += strength_value
		emit_signal("number_of_strength", self)
	
func _on_mana_earned(mana_value):
	if mana_count < mana_max :
		mana_count += mana_value
		emit_signal("number_of_mana", self)

func _on_mana_max_modified (stock_value) :
	mana_max += stock_value
	emit_signal("number_of_mana_max", self)

func _on_strength_max_modified (stock_value) :
	strength_max += stock_value
	emit_signal("number_of_strength_max", self)
	
#func _on_water_spend(water_value):
#	water_count -= water_value
#	emit_signal("number_of_water", self)

func _on_strength_spend(strength_value):
	strength_count -= strength_value
	emit_signal("number_of_strength", self)

func _on_mana_spend(mana_value):
	mana_count -= mana_value
	emit_signal("number_of_mana", self)
	
	
#func _on_fluffisprout_created(fluffisprout_number, fluffisprout_cost) :
#	if fluffisprout_cost >= strength_count and pearl_count <= 0 :
#		pearl_count += fluffisprout_number
#		strength_count -= fluffisprout_cost
#		emit_signal("number_of_strength", self)
#		emit_signal("number_of_pearls", self)
		
#func _on_item_bought_pearl():
#	emit_signal("number_of_pearls", self)

#func _on_item_bought_strength():
#	emit_signal("number_of_strength", self)

func import_parasite_algae():
	for x in map_size.x:
		for y in map_size.y:
			var algae_generation = randi()% 1000 + 1
			if algae_generation > 999 :
				var valid_position = false
				while not valid_position :
					var xalgae = randi()% (xmap -2) + 2
					var yalgae = randi()% (ymap +2) - 2
					var make_parasite_algae = parasite_algae.instance()
						
					var data = custom_gradient.get_data()
					data.lock()
					var gradient_value = data.get_pixel(xalgae + xmap * 0.5 , yalgae + ymap * 0.5).r * size_gradient
						
					var a = noise.get_noise_2d(xalgae,yalgae)
					data.unlock()
					a -= gradient_value
					if a < possible_position.x and a > possible_position.y :
						$YSort.add_child(make_parasite_algae)
						make_parasite_algae.position = Vector2(xalgae*tilesize, yalgae*tilesize)
						valid_position = true
			
func	import_object(object_scene):
	
	var valid_position = false
	while not valid_position :
		var xobject = randi()% (xmap -2) + 2
		var yobject = randi()% (ymap +2) - 2
		var object = object_scene.instance()
			
		var data = custom_gradient.get_data()
		data.lock()
		var gradient_value = data.get_pixel(xobject + xmap * 0.5 , yobject + ymap * 0.5).r * size_gradient
		

			
		var a = noise.get_noise_2d(xobject,yobject)
		data.unlock()
		a -= gradient_value

		if a < possible_position.x and a > possible_position.y :
			$YSort.add_child(object)
			object.position = Vector2(xobject*100, yobject*100)
			valid_position = true
			
			
func import_robot():
	
	var valid_position = false
	while not valid_position :
		var xrobot = randi()% (xmap -2) + 2
		var yrobot = randi()% (ymap +2) - 2
		var robot = robot_scene.instance()
			
		var data = custom_gradient.get_data()
		data.lock()
		var gradient_value = data.get_pixel(xrobot + xmap * 0.5 , yrobot + ymap * 0.5).r * size_gradient
		

			
		var a = noise.get_noise_2d(xrobot,yrobot)
		data.unlock()
		a -= gradient_value

		if a < possible_position.x and a > possible_position.y :
			$YSort.add_child(robot)
			robot.position = Vector2(xrobot*100, yrobot*100)
			valid_position = true

func make_background():
	for x in map_size.x:
		for y in map_size.y:
			if $Grass.get_cell(x,y) == -1:
				if $Grass.get_cell(x,y-1) == 0:
					$Background.set_cell(x,y,0)
				
	$Background.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))


func _on_fluffisprout_item_pressed(gender):
	var mouse_position = get_local_mouse_position()#get_viewport().get_mouse_position()
	var mouse_x = mouse_position.x
	var mouse_y = mouse_position.y
	var fluffisprout_instance = fluffisprout.instance()
	fluffisprout_instance.gender = gender
	$YSort.add_child(fluffisprout_instance)
	fluffisprout_instance.position = (Vector2(mouse_x,mouse_y))

func _on_algae_cut():
	strength_count += -1
	emit_signal("number_of_strength", self)

func set_rain():
	var rain = rain_scene.instance()
	var rain_ground = rain_ground_scene.instance()
	rain_ground.process_material.emission_box_extents = Vector3(float(xmap*tilesize), float(ymap*tilesize), 0 )
	rain_ground.position = Vector2 (xmap*tilesize/2, ymap*tilesize/2)
	rain_ground.set_visibility_rect(Rect2(0, 0, 2000, 1200))

	rain.process_material.emission_box_extents = Vector3(float(xmap*tilesize), float(ymap*tilesize), 0 )
	rain.position = Vector2 (xmap*tilesize/2, ymap*tilesize/2)
	rain.set_visibility_rect(Rect2(0, 0, 2000, 1200))
	
	rain_node.add_child(rain)
	rain_ground_node.add_child(rain_ground)
	
	weather_animation.set_current_animation("day_and_night_rain")


func stop_rain():
	for child in rain_node.get_children() :
		child.queue_free()
		
	for child in rain_ground_node.get_children() :
		child.queue_free()		
	
	weather_animation.set_current_animation("day_and_night")
		
func _on_end_of_day_timeout():
	day_count +=  1
	emit_signal ("day_number", self)
	if day_count <= 33 :
		rain_chance = 33
	
	elif day_count > 99 :
		year += 1
		day_count = 0

	elif day_count > 66 :
		rain_chance = 1
	
	elif day_count > 33 :
		rain_chance = 95
	
	
	var chance_of_meteor = randi()% 100 + 1 
	if chance_of_meteor > 95 :
		import_object(meteor_scene)

	var weather = randi()% 100 + 1
	if rain_chance >= weather :
		if rain_falling == true :
			pass
		elif rain_falling == false :
			set_rain()
			rain_falling = true
	else :
		if rain_falling == true :
			stop_rain()
			rain_falling = false
			
		elif rain_falling == false :
			pass
	
	
	
	if day_count > 10 :
		for creature in get_tree().get_nodes_in_group("creature") :
			var sickness_chance = randi()% 100 + 1
			if sickness_chance >= 98 :
				print ("creature got sick")
				if creature.sick == false :
					creature.sick = true
				
		#import_parasite_algae()

		
		
	emit_signal("end_of_day")
	



func _on_robot_repaired():

	robot_repaired = true
	var old_robot = get_tree().root.get_node("Game/game_start/YSort/robot_broken")
	var make_new_robot = new_robot.instance()

	get_tree().root.get_node("Game/game_start/YSort").add_child(make_new_robot)
	make_new_robot.position = old_robot.position
	
	old_robot.queue_free()


func _on_evolution_selected(text, id, cost):

	evolution(text, id, cost)
	
func 	evolution(text, id, cost) :
	if mana_count >= cost :

		var entity_scene = load ("res://entities/" + text + "/" + text +"_adult/"+ text +".tscn")
		var entity = entity_scene.instance()
		for node in  get_tree().get_nodes_in_group(id) :
			if not node.is_in_group("produced") :
				entity.gender = node.gender
				entity.position = node.position
				entity.creature_name = node.creature_name
				entity.happiness = node.happiness
				entity.age = node.age
				if not entity.is_in_group("animal") :
					entity.orientation_choice = node.orientation_choice
					
				$YSort.add_child(entity)
				node.queue_free()
				mana_count -= cost
				emit_signal("number_of_mana", self)







func _on_hide_tree_button_pressed():
		for node in get_tree().get_nodes_in_group("hideable") :
			node.sprite.play("hidden")
			
func _on_show_tree_pressed():
		for node in get_tree().get_nodes_in_group("hideable") :
			node.sprite.play("default")
			
			
func produce_object(parent_position, parent_path, min_radius, max_radius, object_scene, id, object_type):
	
	self.connect ("object_produced", get_tree().root.get_node(parent_path), "_on_object_produced")
	
	var earth_position = Vector2(1, -0.3)
	var valid_position = false
	var try_number = 0
	while not valid_position :
		var count = rand_range(0, 2)
		var bush_radius = randi()% int(min_radius) + int(max_radius)
		var radius = Vector2(bush_radius, 0)
		var center = parent_position
		var step = float(count) * PI 
		var spawn_pos = center + radius.rotated(step)
		var object = object_scene.instance()
		#var data = custom_gradient.get_data()
		#data.lock()
		#var gradient_value = data.get_pixel( float(spawn_pos.x/(0.5 * tilesize)) , float(spawn_pos.y/(0.5 * tilesize)) ).r * size_gradient
		try_number += 1
		print ("try number :", try_number)
		#var a = noise.get_noise_2d(spawn_pos.x,spawn_pos.y)
		#data.unlock()
		#a -= gradient_value
		var tilemap_ground  = $Ground.get_cell(spawn_pos.x/tilesize ,spawn_pos.y/tilesize )

		if tilemap_ground == 0 :

			get_tree().root.get_node("Game/game_start/YSort").add_child(object)
			object.position = spawn_pos
			valid_position = true
			emit_signal("object_produced", object_type)
		
		if try_number >= 10 :
			object.queue_free()
			valid_position = true
			


		



func save():
	var save = {
			"name" : get_name(),
			"filename" : get_filename(),
			"parent" : get_parent().get_path(),
			"pos_x" : position.x, # Vector2 is not supported by JSON
			"pos_y" : position.y,
			"save_value" : save_value ,
			"xmap" : xmap,
			"ymap" : ymap,
			"noise_variations" : int(noise_variations),
			"custom_gradient" : custom_gradient,
			"size_gradient" : size_gradient,
			"map_size.x" : map_size.x,
			"map_size.y" : map_size.y,
			"day_count" : day_count,
			"water_count" : water_count,
			"strength_count" : strength_count,
			"mana_count" : mana_count,
			"saved" : saved,
			"robot_repaired" : robot_repaired,
			"rain_falling" : rain_falling,
			"year" : year,
			"rain_chance" : rain_chance

	}
	return save










