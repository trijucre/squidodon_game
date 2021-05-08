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
var diversity_level_1 = 0
var diversity_level_2 = 0
var diversity_level_3 = 0

var robot_repaired
var robot_container
var poop_number = 0
var poop_quality = 0
var fertilizer_quality = 0
onready var robot_button = $CanvasLayer/robot_button

var tree_hidden = false
#var number_animals = 5 #xmap/20
var pearl_count = 10
var water_count = 10
var water_max = 1000
var strength_count = 10
var strength_max = 1000

onready var bush = preload("res://food/vegetals/bush/bush.tscn")
onready var tree = preload("res://entities/tree/tree_adult/tree.tscn")
onready var clover_tree = preload ("res://entities/clover_tree/clover_tree_adult/clover_tree.tscn")
onready var fruit_tree = preload ("res://entities/fruit_tree/fruit_tree_adult/fruit_tree.tscn")

onready var big_clover_tree = ("res://entities/big_clover_tree/big_clover_tree_adult/big_clover_tree.tscn")
onready var big_tree = ("res://entities/big_tree/big_tree_adult/big_tree.tscn")
onready var big_fruit_tree = ("res://entities/big_fruit_tree/big_fruit_tree_adult/big_fruit_tree.tscn")

onready var mega_bush_tree = ("res://entities/mega_bush_tree/mega_bush_tree_adult/mega_bush_tree.tscn")
onready var mega_clover_tree = ("res://entities/mega_clover_tree/mega_clover_tree_adult/mega_clover_tree.tscn")
onready var mega_fruit_tree = ("res://entities/mega_fruit_tree/mega_fruit_tree_adult/mega_fruit_tree.tscn")

onready var star_tree_1 =("res://entities/star_tree_1/star_tree_1_adult/star_tree_1.tscn")
onready var star_tree_2 =("res://entities/star_tree_2/star_tree_2_adult/star_tree_2.tscn")
onready var star_tree_3 =("res://entities/star_tree_3/star_tree_3_adult/star_tree_3.tscn")
onready var mega_star_tree = ("res://entities/mega_star_tree/mega_star_tree_adult/mega_star_tree.tscn")

onready var water_flower = preload ("res://entities/water_flower/water_flower_adult/water_flower.tscn")
#onready var pearl_flower = preload ("res://food/vegetals/flowers/pearl_flower/pearl_flower.tscn")
onready var strength_flower = preload("res://entities/strength_flower/strength_flower_adult/strength_flower.tscn")
onready var berry_bush = preload("res://food/vegetals/bush/bush.tscn")
onready var big_strength_flower = preload("res://entities/big_strength_flower/big_strength_flower_adult/big_strength_flower.tscn")
onready var big_water_flower = preload ("res://entities/big_water_flower/big_water_flower_adult/big_water_flower.tscn")
onready var strength_water_flower = preload("res://entities/strength_water_flower/strength_water_flower_adult/strength_water_flower.tscn")
#onready var big_tree = preload("res://bigtree.tscn")
onready var parasite_algae = preload ("res://entities/parasite_algae/baby/parasite_algae_baby.tscn")

onready var fluffiplant = preload("res://entities/fluffiplant/fluffiplant_adult/fluffiplant.tscn")
onready var fluffisprout = preload ("res://entities/fluffisprout/fluffisprout.tscn")
onready var fluffilus = preload("res://entities/fluffilus/fluffilus_adult/fluffilus.tscn")
onready var rabbibranch = preload ("res://entities/rabbibranch/rabbibranch_adult/rabbibranch.tscn")
onready var cuttledog = preload("res://entities/cuttledog/cuttledog_adult/cuttledog.tscn")
onready var lionfish = preload ("res://entities/lionfish/lionfish_adult/lionfish.tscn")
onready var sand_catshark = preload ("res://entities/sand_catshark/sand_catshark_adult/sand_catshark.tscn")
onready var ancistrus = preload ("res://entities/ancistrus/ancistrus_adult/ancistrus.tscn")
onready var orca_bear = preload("res://entities/orca_bear/orca_bear_adult/orca_bear.tscn")
#onready var orca_bear_node = orca_bear.instance()

onready var pond = preload("res://constructs/pond/pond.tscn")
onready var hill = preload("res://constructs/hill/hill.tscn")

onready var robot_scene = preload("res://entities/robot/robot_broken/robot_broken.tscn")
onready var new_robot = preload ("res://entities/robot/robot/robot.tscn")
onready var infos_robot_scene = preload("res://GUI/info_robot/info_repaired_robot/info_robot.tscn")
onready var robot_stat_scene = preload("res://GUI/info_robot/robot_stats/robot_life_and_energy.tscn")

var option_1_bought = false
var option_2_bought = false
var option_3_bought = false
var option_4_bought = false
var option_5_bought = false
var option_6_bought = false
var option_7_bought = false

var day_count = 1
signal day_number
#signal diversity_number
onready var pause_menu_scene = preload ("res://GUI/pause_menu/pause_menu.tscn")



export var rabbibranch_count = 0
export var cuttledog_count = 0
export var fluffilus_count = 0
export var orca_bear_count = 0
export var coral_ocelot_count = 0
export var sand_catshark_count = 0
export var ancistrus_count = 0


signal number_of_rabbibranch
signal number_of_cuttledog
signal number_of_fluffilus
signal number_of_orca_bear
signal number_of_sand_catshark
signal number_of_coral_ocelot
signal number_of_ancistrus
signal number_of_pearls
signal  number_of_water
signal number_of_strength

signal end_of_day
#var first_animal_instance = 10
#var second_animal_instance = 10


func _ready():
	
	randomize()
	
	add_to_group("Persist", true)
	add_to_group("Persist_parent", true)


	
	emit_signal("number_of_rabbibranch", self)
	emit_signal("number_of_cuttledog", self)
	emit_signal("number_of_fluffilus", self)
	emit_signal("number_of_orca_bear", self)
	emit_signal("number_of_coral_ocelot", self)
	emit_signal("number_of_sand_catshark", self)
	emit_signal("number_of_ancistrus", self)
	
	emit_signal("number_of_pearls", self)
	emit_signal("number_of_strength", self)
	emit_signal("number_of_water", self)
	
	tilemap_Ground = get_tree().root.get_node("Game/Ground")
	tilemap_Water = get_tree().root.get_node("Game/Water")
	
	emit_signal ("day_number", self)

# Called when the node enters the scene tree for the first time.
	self.connect("end_of_day", get_tree().root.get_node("Game"), "_on_end_of_day")
	#create the map
	

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
	
	if saved == false :
		import_robot()
	#make_tree()
	$Camera2D.position.x = xmap*tilesize/2
	$Camera2D.position.y = ymap*tilesize/2	
	print (robot_repaired)
	if robot_repaired == false :
		robot_button.set_disabled(true)
	if saved == false :
		import_parasite_algae()
	
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
	
func make_tree():
	
	for x in map_size.x:
		for y in map_size.y:
			var data = custom_gradient.get_data()
			data.lock()
			var gradient_value = data.get_pixel(x + xmap * 0.5 , y + ymap * 0.5).r * size_gradient
			
			var a = noise.get_noise_2d(x,y)
			data.unlock()
			a -= gradient_value
			
			if a < tree_caps.x and a > tree_caps.y and x > 1 and y > 1 :
				var chance = randi() % 100
				
				if chance >= 99:
					var make_parasite_algae = parasite_algae.instance()
					#var num = randi() % tilesize/8 + tilesize/10
					make_parasite_algae.position = Vector2(x*tilesize, y*tilesize)
					$YSort.add_child(make_parasite_algae)
				
				if chance < 25:
					var make_bush = bush.instance()
					#var num = randi() % tilesize/8 + tilesize/10
					make_bush.position = Vector2(x*tilesize, y*tilesize)
					$YSort.add_child(make_bush)
				
					
func _on_fluffisprout_pressed():
	if pearl_count > 0 :
		var fluffisprout = $CanvasLayer/entities_buttonfluffisprout
		var item_name = "fluffisprout"
		var item_load_scene = "res://items_selected/"+ item_name + "_item/" + item_name + "_item.tscn"
		var animal = load(item_load_scene)
		get_tree().root.get_node("Game/game_start/YSort").add_child(animal.instance())
		pearl_count -= 1
		emit_signal("number_of_pearls", self)
	else :
		pass

func _on_pond_pressed():
	if strength_count > 50 :
		var pond = $CanvasLayer/entities_button/pond
		var item_name = "pond"
		var item_load_scene = "res://items_selected/"+ item_name + "_item/" + item_name + "_item.tscn"
		var animal = load(item_load_scene)
		get_tree().root.get_node("Game/game_start/YSort").add_child(animal.instance())
		strength_count -= 50
		emit_signal("number_of_strength", self)
	else:
		pass # Replace with function body.


func _on_hill_pressed():
	if strength_count > 0 :
		var pond = $CanvasLayer/entities_button/hill
		var item_name = "hill"
		var item_load_scene = "res://items_selected/"+ item_name + "_item/" + item_name + "_item.tscn"
		var animal = load(item_load_scene)
		get_tree().root.get_node("Game/game_start/YSort").add_child(animal.instance())
		strength_count -= 50
		emit_signal("number_of_strength", self)
	else :
		pass # Replace with function body.


func _on_pearl_earned():
	pearl_count += 1
	emit_signal("number_of_pearls", self)

func _on_water_earned(water_value):
	water_count += water_value
	emit_signal("number_of_water", self)
	
func _on_strength_earned(strength_value):
	strength_count += strength_value
	emit_signal("number_of_strength", self)
	
func _on_water_spend(water_value):
	print ("water spent ", water_value)
	water_count -= water_value

	emit_signal("number_of_water", self)

func _on_strength_spend(strength_value):
	strength_count -= strength_value
	emit_signal("number_of_strength", self)

	
func _on_item_bought_pearl():
	emit_signal("number_of_pearls", self)

func _on_item_bought_strength():
	emit_signal("number_of_strength", self)

func import_parasite_algae():
	for x in map_size.x:
			for y in map_size.y:
				var data = custom_gradient.get_data()
				data.lock()
				var gradient_value = data.get_pixel(x + xmap * 0.5 , y + ymap * 0.5).r * size_gradient
				
				var a = noise.get_noise_2d(x,y)
				data.unlock()
				a -= gradient_value
				
				if a < tree_caps.x and a > tree_caps.y and x > 1 and y > 1 :
					var chance = randi() % 1000
					
					if chance >= 995:
						var make_parasite_algae = parasite_algae.instance()
						#var num = randi() % tilesize/8 + tilesize/10
						make_parasite_algae.position = Vector2(x*tilesize, y*tilesize)
						$YSort.add_child(make_parasite_algae)

func import_fluffilus():
	var valid_position = false
	while not valid_position :
		var xanimal = randi()% (xmap -2) + 2
		var yanimal = randi()% (ymap +2) - 2
		var make_fluffilus = fluffilus.instance()
			
		var data = custom_gradient.get_data()
		data.lock()
		var gradient_value = data.get_pixel(xanimal + xmap * 0.5 , yanimal + ymap * 0.5).r * size_gradient
			
		var a = noise.get_noise_2d(xanimal,yanimal)
		data.unlock()
		a -= gradient_value
		if a < possible_position.x and a > possible_position.y :
			$YSort.add_child(make_fluffilus)
			make_fluffilus.position = Vector2(xanimal*tilesize, yanimal*tilesize)
			valid_position = true
					
func import_cuttledog():

	var valid_position = false
	while not valid_position :
		var xcuttledog = randi()% (xmap -2) + 2
		var ycuttledog = randi()% (ymap +2) - 2
		var make_cuttledog = cuttledog.instance()
			
		var data = custom_gradient.get_data()
		data.lock()
		var gradient_value = data.get_pixel(xcuttledog + xmap * 0.5 , ycuttledog + ymap * 0.5).r * size_gradient
			
		var a = noise.get_noise_2d(xcuttledog,ycuttledog)
		data.unlock()
		a -= gradient_value
		if a < possible_position.x and a > possible_position.y :
			$YSort.add_child(make_cuttledog)
			make_cuttledog.position = Vector2(xcuttledog*100, ycuttledog*100)
			valid_position = true
			
func import_lionfish():

	var valid_position = false
	while not valid_position :
		var xanimal = randi()% (xmap -2) + 2
		var yanimal = randi()% (ymap +2) - 2
		var make_lionfish = lionfish.instance()
			
		var data = custom_gradient.get_data()
		data.lock()
		var gradient_value = data.get_pixel(xanimal + xmap * 0.5 , yanimal + ymap * 0.5).r * size_gradient
			
		var a = noise.get_noise_2d(xanimal,yanimal)
		data.unlock()
		a -= gradient_value
		if a < possible_position.x and a > possible_position.y :
			$YSort.add_child(make_lionfish)
			make_lionfish.position = Vector2(xanimal*100, yanimal*100)
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
		
		print ("x robot ,", xrobot," y robo  ,",yrobot ,"   gradient value ,",gradient_value)
			
		var a = noise.get_noise_2d(xrobot,yrobot)
		data.unlock()
		a -= gradient_value
		print ("value a to check if robot can be put here :", a)
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




# count the number of animals in game
func _on_rabbibranch_birth():
	rabbibranch_count += 1
	emit_signal("number_of_rabbibranch", self)
	
func _on_rabbibranch_death() :
	rabbibranch_count -= 1
	emit_signal("number_of_rabbibranch", self)

func _on_cuttledog_cuttledog_birth():
	cuttledog_count += 1
	emit_signal("number_of_cuttledog", self)

func _on_cuttledog_cuttledog_death():
	cuttledog_count -=1
	emit_signal("number_of_cuttledog", self)
	
	
func _on_fluffilus_fluffilus_birth():
	fluffilus_count += 1
	emit_signal("number_of_fluffilus", self)
	
func _on_fluffilus_fluffilus_death():
	fluffilus_count -= 1
	emit_signal("number_of_fluffilus", self)
	
func _on_orca_bear_orca_bear_birth():
	orca_bear_count += 1
	emit_signal("number_of_orca_bear", self)
	
func _on_orca_bear_orca_bear_death():
	orca_bear_count -= 1
	emit_signal("number_of_orca_bear", self)
	

func _on_lionfish_lionfish_birth():
	coral_ocelot_count += 1
	emit_signal("number_of_lionfish", self)
	
func _on_lionfish_lionfish_dearh():
	coral_ocelot_count -= 1
	emit_signal("number_of_lionfish", self)
	
func _on_sand_catshark_sand_catshark_birth():
	sand_catshark_count += 1
	emit_signal("number_of_sand_catshark", self)
	
func _on_sand_catshark_death() :
	sand_catshark_count -= 1
	emit_signal("number_of_sand_catshark", self)
	
func _on_ancistrus_birth():
	ancistrus_count += 1
	emit_signal("number_of_ancistrus", self)
	
func _on_ancistrus_death():
	ancistrus_count -= 1
	emit_signal("number_of_ancistrus", self)






func _on_item_tree_button_pressed():
	pass
	#var item_tree_scene = preload("res://GUI/items_tree/items_tree.tscn")
	#get_tree().paused = true
	#var item_tree = item_tree_scene.instance()
	#$CanvasLayer.add_child(item_tree)
	


#stock items and import them in game :

func _on_item_1_pressed():
	var item_1 = $CanvasLayer/item_stock/item_stock_container/item_1
	item_pressed(item_1)

func _on_item_2_pressed():
	var item_2 = $CanvasLayer/item_stock/item_stock_container/item_2
	item_pressed(item_2)

func _on_item_3_pressed():
	var item_3 = $CanvasLayer/item_stock/item_stock_container/item_3
	item_pressed(item_3)


func _on_item_4_pressed():
	var item_4 = $CanvasLayer/item_stock/item_stock_container/item_4
	item_pressed(item_4)


func _on_item_5_pressed():
	var item_5 = $CanvasLayer/item_stock/item_stock_container/item_5
	item_pressed(item_5)


func _on_item_6_pressed():
	var item_6 = $CanvasLayer/item_stock/item_stock_container/item_6
	item_pressed(item_6)
	
	
func item_pressed(item):
	if item.texture_normal != null :
		var item_name = item.item_name
		var item_load_scene = "res://items_selected/"+ item_name + "_item/" + item_name + "_item.tscn"
		var animal = load(item_load_scene)
		get_tree().root.get_node("Game/game_start/YSort").add_child(animal.instance())
		item.set_normal_texture(null)
		item.empty = true
		item.item_name = null
	else :
		pass
		



func _on_fluffisprout_item_pressed():
	import_item(fluffisprout)

		
func _on_rabbibranch_item_pressed():
	import_item(rabbibranch)
		
func _on_fluffilus_item_pressed():
	import_item(fluffilus)
	
func _on_sand_catshark_item_pressed():
	import_item(sand_catshark)

func _on_cuttledog_item_pressed() :
	import_item(cuttledog)

func _on_coral_ocelot_item_pressed():
	import_item(lionfish)

func _on_ancistrus_item_pressed():
	import_item(ancistrus)


func _on_bush_item_pressed():
	import_item(bush)
	
#func _on_pearl_flower_item_pressed():
#	import_item(pearl_flower)

func _on_berry_bush_item_pressed():
	import_item(berry_bush)
	
func _on_clover_tree_item_pressed():
	import_item(clover_tree)
	
func _on_tree_item_pressed():
	import_item(tree)

func _on_water_flower_item_pressed():
	import_item(water_flower)

func _on_strength_flower_item_pressed():
	import_item(strength_flower)
	
func _on_big_strength_flower_item_pressed():
	import_item(big_strength_flower)

func _on_big_water_flower_item_pressed():
	import_item(big_water_flower)	

func _on_strength_water_flower_item_pressed():
	import_item(strength_water_flower)	

	
func _on_pond_item_pressed():
	import_item(pond)

func _on_hill_item_pressed():
	import_item(hill)


func import_item(item):
	var mouse_position = get_local_mouse_position()#get_viewport().get_mouse_position()
	var mouse_x = mouse_position.x
	var mouse_y = mouse_position.y
	var make_item = item.instance()
	$YSort.add_child(make_item)
	make_item.position = (Vector2(mouse_x,mouse_y))
	
#vegetal  watering action

#func _on_tree_watered():
	#water_count += -1
	#emit_signal("number_of_water", self)

#func _on_tree_energized():
	#strength_count -= 1
	#emit_signal("number_of_strength", self)
	
func _on_algae_cut():
	strength_count += -1
	emit_signal("number_of_strength", self)
	
	
func _on_end_of_day_timeout():
	day_count +=  1
	emit_signal ("day_number", self)

	#save game every day
	#parasites grow every day
	

	emit_signal("end_of_day")

func _on_diversity_level_1_enter():
	diversity_level_1 += 1

func _on_diversity_level_1_out():
	diversity_level_1 -= 1
		
func _on_diversity_level_2_enter():
	diversity_level_2 += 1

func _on_diversity_level_2_out():
	diversity_level_2 -= 1
	
func _on_diversity_level_3_enter():
	diversity_level_3 += 1

func _on_diversity_level_3_out():
	diversity_level_3 -= 1
	
func _on_robot_repaired():
	print ("robot_repaired")
	robot_repaired = true
	robot_button.set_disabled(false)
	var old_robot = get_tree().root.get_node("Game/game_start/YSort/robot_broken")
	var make_new_robot = new_robot.instance()
	
	var robot_stat = robot_stat_scene.instance()
	make_new_robot.health = robot_stat.health
	make_new_robot.energy = robot_stat.energy
	
	get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(robot_stat)
	robot_stat.position = Vector2 (10, 800)
	print("robotstat path :",robot_stat.get_path())
	
	get_tree().root.get_node("Game/game_start/YSort").add_child(make_new_robot)
	make_new_robot.position = old_robot.position
	
	old_robot.queue_free()
	
func _on_robot_updated(option_number):
	print ("signal send from robot interface to game_start")
	if option_number == 1 :
		option_1_bought = true
	
	if option_number == 2 :
		option_2_bought = true
	
	if option_number == 3 :
		option_3_bought = true

	if option_number == 4 :
		option_4_bought = true
		
	if option_number == 5 :
		option_5_bought = true

	if option_number == 6 :
		option_6_bought = true
		
	if option_number == 7 :
		option_7_bought = true
	
	print ("option 1 bought", option_1_bought)

func _on_fertilizer_created(quality):
	fertilizer_quality = quality
	
func _on_robot_button_pressed():
	var info_robot = infos_robot_scene.instance()
	
	info_robot.option_1_bought = option_1_bought
	info_robot.option_2_bought = option_2_bought
	info_robot.option_3_bought = option_3_bought
	info_robot.option_4_bought = option_4_bought
	info_robot.option_5_bought = option_5_bought
	info_robot.option_6_bought = option_6_bought
	info_robot.option_7_bought = option_7_bought
	
	info_robot.poop_number = poop_number
	info_robot.poop_quality = poop_quality
	info_robot.container = robot_container

	info_robot.fertilizer = 0
	info_robot.fertilizer_quality = 0
	
	get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(info_robot)
	get_tree().paused = true
	
func _on_object_recolted(object, quality, number_of_object):
	
	robot_container = object
	
	if robot_container == "poop" :
		poop_number += number_of_object
		poop_quality += quality
		print ("poop quality", poop_quality)


func _on_evolution_1_selected(text_1, id, cost_text_1):

	print ("evolution 1 selected")
	print ("evolution name   ", text_1)
	print ("identity", id)
	print ("cost", cost_text_1)
	if strength_count >= cost_text_1 :

		var entity_scene = load ("res://entities/" + text_1 + "/" + text_1 +"_adult/"+ text_1 +".tscn")
		var entity = entity_scene.instance()
		for node in  get_tree().get_nodes_in_group(id) :
			entity.gender = node.gender
			entity.position = node.position
			entity.creature_name = node.creature_name
			print ("evoltion 1 entity name :", entity.creature_name)
			$YSort.add_child(entity)
			node.queue_free()
			strength_count -= cost_text_1
			emit_signal("number_of_strength", self)


		
func _on_evolution_2_selected(text_2, id, cost_text_2):

	print ("evolution 2 selected")
	print ("evolution name   ", text_2)
	print ("identity", id)
	if strength_count >= cost_text_2 :
		
		var entity_scene = load ("res://entities/" + text_2 + "/" + text_2 +"_adult/"+ text_2 +".tscn")
		var entity = entity_scene.instance()
		for node in  get_tree().get_nodes_in_group(id) :
	
			entity.gender = node.gender
			entity.position = node.position
			entity.creature_name = node.creature_name
			print ("evoltion 2 node name :", node.creature_name)
			print ("evoltion 2 entity name :", entity.creature_name)
			$YSort.add_child(entity)
			node.queue_free()
			strength_count -= cost_text_2
			emit_signal("number_of_strength", self)
	
func _on_evolution_3_selected(text_3, id, cost_text_3):

	print ("evolution 3 selected")
	print ("evolution name   ", text_3)
	print ("identity", id)
	if strength_count >= cost_text_3 :
		var entity_scene = load ("res://entities/" + text_3 + "/" + text_3 +"_adult/"+ text_3 +".tscn")
		var entity = entity_scene.instance()
		for node in  get_tree().get_nodes_in_group(id) :
			entity.gender = node.gender
			entity.position = node.position
			entity.creature_name = node.creature_name
			print ("evoltion 3 entity name :", entity.creature_name)
			$YSort.add_child(entity)
			node.queue_free()
			strength_count -= cost_text_3
			emit_signal("number_of_strength", self)
			print ("strength count", strength_count)
	else :
		pass
	


func _on_hide_tree_button_pressed():
		for node in get_tree().get_nodes_in_group("tree") :
			node.sprite.play("hidden")
			
func _on_show_tree_pressed():
		for node in get_tree().get_nodes_in_group("tree") :
			node.sprite.play("default")

	
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
			"pearl_count" : pearl_count,
			"saved" : saved,
			"robot_repaired" : robot_repaired,
			"option_1_bought" : option_1_bought,
			"option_2_bought" : option_2_bought,
			"option_3_bought" : option_3_bought,
			"option_4_bought" : option_4_bought,
			"option_5_bought" : option_5_bought,
			"option_6_bought" : option_6_bought,
			"option_7_bought" : option_7_bought

	}
	return save










