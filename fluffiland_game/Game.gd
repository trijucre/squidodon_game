extends Node2D

var tilemap_Ground 
var tilemap_Water

var xmap = 100
var ymap = 50
var tilesize = 100

var noise
var custom_gradient
var size_gradient = 2.2

var map_size = Vector2(xmap, ymap)
var possible_position = Vector2(0, -0.6)

var grass_caps = Vector2(1, -0.5)
var ground_caps = Vector2(1, -0.7) 
var water_caps = Vector2(1, -1)
var tree_caps = Vector3(0.5, -0.2, 0.1) 
var animal_cap = Vector2(0.5, 0)

var show_areas = false
#var number_animals = 5 #xmap/20
var pearl_count = 10
var water_count = 10
var water_max = 100
var strength_count = 10
var strength_max = 100

onready var bush = preload("res://food/vegetals/bush/bush.tscn")
onready var tree = preload("res://food/vegetals/tree/tree.tscn")
onready var clover_tree = preload ("res://food/vegetals/clover_tree/clover_tree.tscn")
onready var water_flower = preload ("res://food/vegetals/flowers/water_flower/water_flower.tscn")
onready var pearl_flower = preload ("res://food/vegetals/flowers/pearl_flower/pearl_flower.tscn")
onready var strength_flower = preload("res://food/vegetals/flowers/strength_flower/strength_flower.tscn")
onready var berry_bush = preload("res://food/vegetals/bush/bush.tscn")
onready var big_tree = preload("res://bigtree.tscn")
onready var parasite_algae = preload ("res://food/vegetals/parasite_algae/baby/parasite_algae_baby.tscn")

onready var rabbibranch = preload ("res://entities/rabbibranch/rabbibranch_adult/rabbibranch.tscn")
onready var fluffilus = preload("res://entities/fluffilus/fluffilus_adult/fluffilus.tscn")
onready var cuttledog = preload("res://entities/cuttledog/cuttledog_adult/cuttledog.tscn")
onready var lionfish = preload ("res://entities/lionfish/lionfish_adult/lionfish.tscn")
onready var sand_catshark = preload ("res://entities/sand_catshark/sand_catshark_adult/sand_catshark.tscn")
onready var ancistrus = preload ("res://entities/ancistrus/ancistrus_adult/ancistrus.tscn")
onready var orca_bear = preload("res://entities/orca_bear/orca_bear_adult/orca_bear.tscn")
#onready var orca_bear_node = orca_bear.instance()


var day_count = 1
signal day_number
#signal diversity_number


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

#var first_animal_instance = 10
#var second_animal_instance = 10


func _ready():
	
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
	
	#create the map
	randomize()
	
	#gradient to make the noise fade away at the borders of the screen
	custom_gradient = CustomGradientTexture.new()
	custom_gradient.gradient = Gradient.new()
	custom_gradient.type = CustomGradientTexture.GradientType.RADIAL
	custom_gradient.size = Vector2( xmap * 2,   ymap * 2)
	
	#custom_gradient.resize = Vector2(xmap, ymap)
	
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
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

	
func _process(_delta):
	
	if Input.is_action_just_pressed('pause'):
		get_tree().paused = true
		
	
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
				
					
					
					
func _on_pearl_earned():
	pearl_count += 1
	emit_signal("number_of_pearls", self)

func _on_water_earned():
	water_count += 1
	emit_signal("number_of_water", self)
	
func _on_strength_earned():
	strength_count += 1
	emit_signal("number_of_strength", self)
	
func _on_water_spend():
	water_count -= 1
	emit_signal("number_of_water", self)

func _on_strength_spend():
	strength_count -= 1
	emit_signal("number_of_strength", self)

	
func _on_item_bought():

	emit_signal("number_of_pearls", self)

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
			
func import_orca_bear():
	
	var valid_position = false
	while not valid_position :
		var xorca_bear = randi()% (xmap -2) + 2
		var yorca_bear = randi()% (ymap +2) - 2
		var make_orca_bear = orca_bear.instance()
			
		var data = custom_gradient.get_data()
		data.lock()
		var gradient_value = data.get_pixel(xorca_bear + xmap * 0.5 , yorca_bear + ymap * 0.5).r * size_gradient
			
		var a = noise.get_noise_2d(xorca_bear,yorca_bear)
		data.unlock()
		a -= gradient_value
		if a < possible_position.x and a > possible_position.y :
			$YSort.add_child(make_orca_bear)
			make_orca_bear.position = Vector2(xorca_bear*100, yorca_bear*100)
			valid_position = true

func make_background():
	for x in map_size.x:
		for y in map_size.y:
			if $Grass.get_cell(x,y) == -1:
				if $Grass.get_cell(x,y-1) == 0:
					$Background.set_cell(x,y,0)
				
	$Background.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))

func randomize_player_position():
	var valid_position = false
	
	while not valid_position :
		var xsquidodon = randi()% (xmap - 2) + 2
		var ysquidodon = randi()% (ymap + 2) - 2
		var data = custom_gradient.get_data()
		data.lock()
		var gradient_value = data.get_pixel(xsquidodon + xmap * 0.5 , ysquidodon + ymap * 0.5).r * size_gradient
			
		var a = noise.get_noise_2d(xsquidodon,ysquidodon)
		data.unlock()
		a -= gradient_value
		if a < possible_position.x and a > possible_position.y :
			$YSort/player.position = Vector2(xsquidodon*100, ysquidodon*100)
			valid_position = true
		else :
			valid_position = false


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

func _on_end_of_day_timeout():
	day_count +=  1
	emit_signal ("day_number", self)

	
	var number_of_parasite_algae = get_tree().get_nodes_in_group("parasite").size()
	if number_of_parasite_algae <= 0 :
		randomize()
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




func _on_item_tree_button_pressed():
	var item_tree = preload("res://GUI/items_tree/items_tree.tscn")
	#get_tree().paused = true
	
	$CanvasLayer.add_child(item_tree.instance())




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
		get_tree().root.get_node("Game/YSort").add_child(animal.instance())
		item.set_normal_texture(null)
		item.empty = true
		item.item_name = null
	else :
		pass
		
		
		
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
	
func _on_pearl_flower_item_pressed():
	import_item(pearl_flower)

func _on_berry_bush_item_pressed():
	import_item(berry_bush)
	
func _on_clover_tree_item_pressed():
	import_item(clover_tree)
	
func _on_tree_item_pressed():
	import_item(tree)
	
func _on_big_tree_item_pressed():
	import_item(big_tree)

func _on_water_flower_item_pressed():
	import_item(water_flower)

func _on_strength_flower_item_pressed():
	import_item(strength_flower)

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

#show area occupied by plants when a new is placed

	
	


