extends Control

signal catshark_available
signal coral_ocelot_available
signal cuttledog_available
signal ancistrus_available
signal item_bought

var texture
var animated_texture
var entity_name
var cost_item
var description_text = ""

var catshark_masked = true
var cuttledog_masked = true
var coral_ocelot_masked = true
var ancistrus_masked = true

var berry_bush_masked = true
var tree_masked = true
var big_tree_masked = true

onready var unmasked_background = load ("res://GUI/items_tree/information_item/info_background_unmasked.png")
onready var masked_background = load ("res://GUI/items_tree/information_item/background masked.png")
onready var background = load ("res://GUI/items_tree/information_item/background.png")

#variables for eat and produce
onready var eat_1 = $item_information/eat_and_produce/eat_and_produce_box/animal_eat_1
onready var eat_2 = $item_information/eat_and_produce/eat_and_produce_box/animal_eat_2
onready var produce_1 = $item_information/eat_and_produce/eat_and_produce_box/animal_produce_1
onready var produce_2 = $item_information/eat_and_produce/eat_and_produce_box/animal_produce_2

onready var pearl_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_pearl.png")
onready var poop_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_poop.png")
onready var fish_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_fish.png")
onready var mollusc_meat_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_mollusc_meat.png")
onready var berries_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_berries.png")
onready var fruit_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_fruit.png")
onready var bush_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_bush.png")
onready var bigbush_icon = load("res://GUI/items_tree/information_item/eat_and_produce_graphic/eat_produce_bigbush.png")

# Called when the node enters the scene tree for the first time.
func _ready():
		self.connect("item_bought", get_tree().root.get_node("Game"), "_on_item_bought")


func _on_buy_button_pressed():
	
	if cost_item == null :
		pass
		
	elif  get_tree().root.get_node("Game").pearl_count >= cost_item :
		var item_1 = get_tree().root.get_node("Game/CanvasLayer/item_stock/item_stock_container/item_1")
		var item_2 = get_tree().root.get_node("Game/CanvasLayer/item_stock/item_stock_container/item_2")
		var item_3 = get_tree().root.get_node("Game/CanvasLayer/item_stock/item_stock_container/item_3")
		var item_4 = get_tree().root.get_node("Game/CanvasLayer/item_stock/item_stock_container/item_4")
		var item_5 = get_tree().root.get_node("Game/CanvasLayer/item_stock/item_stock_container/item_5")
		var item_6 = get_tree().root.get_node("Game/CanvasLayer/item_stock/item_stock_container/item_6")

		if item_1.empty == true :
			spot_allowance(item_1)
			get_tree().root.get_node("Game").pearl_count -= cost_item
			
		elif item_2.empty == true :
			spot_allowance(item_2)
			get_tree().root.get_node("Game").pearl_count -= cost_item
			
		elif item_3.empty == true :
			spot_allowance(item_3)
			get_tree().root.get_node("Game").pearl_count -= cost_item
			
		elif item_4.empty == true :
			spot_allowance(item_4)
			get_tree().root.get_node("Game").pearl_count -= cost_item
			
		elif item_5.empty == true :
			spot_allowance(item_5)
			get_tree().root.get_node("Game").pearl_count -= cost_item
			
		elif item_6.empty == true :
			spot_allowance(item_6)
			get_tree().root.get_node("Game").pearl_count -= cost_item
			
		else :
			pass
			
		
		
		emit_signal("item_bought")
		
	else :
		pass

func spot_allowance(item) :
	item.set_normal_texture(texture)
	item.item_name = entity_name
	item.empty = false

# Called every frame. 'delta' is the elapsed time since the previous fr
func _on_animals_button_pressed():
	
	$trees/animal_tree.show()
	$trees/vegetal_tree.hide()
	$menu_buttons/vegetals_button.set_pressed(false)
	$menu_buttons/envenments_button.set_pressed(false)
	$menu_buttons/animals_button.set_disabled(true)
	$menu_buttons/vegetals_button.set_disabled(false)
	$item_information/animal_picture.set_texture(null)
	
	for button in get_tree().get_nodes_in_group("vegetals_button") :
		button.set_disabled(false)
		button.set_pressed(false)
		
	$item_information/cost_text.text = ""
	$item_information/health_text.text = ""
	$item_information/energy_text.text = ""
	
	$item_information/description.text = ""


func _on_vegetals_button_pressed():

	$trees/animal_tree.hide()
	$trees/vegetal_tree.show()
	$menu_buttons/animals_button.set_pressed(false)
	$menu_buttons/envenments_button.set_pressed(false)
	$menu_buttons/animals_button.set_disabled(false)
	$menu_buttons/vegetals_button.set_disabled(true)
	$item_information/animal_picture.set_texture(null)
	
	for button in get_tree().get_nodes_in_group("animals_button") :
		button.set_disabled(false)
		button.set_pressed(false)
		
	$item_information/cost_text.text = ""
	$item_information/health_text.text = ""
	$item_information/energy_text.text = ""
	
	$item_information/description.text = ""
		
	



func unmasked_button_pressed(animal_stat_selection):
	$item_information/picture_bg.set_texture(unmasked_background)
	
	for node in get_tree().get_nodes_in_group("animal_animation") :
		node.queue_free()
		
	for button in get_tree().get_nodes_in_group("animals_button") :
		if button.is_in_group(entity_name) :
			button.set_pressed(true)
			button.set_disabled(true)
		else :
			button.set_pressed(false)
			button.set_disabled(false)

	
	#$item_information/animal_picture.set_texture(texture)
	var animation_texture = animated_texture.instance()
	$item_information.add_child(animation_texture)
	animation_texture.position = Vector2(1400, 400)
	#$trees/animal_tree/buttons/catshark.set_disabled(true)
	#$trees/animal_tree/buttons/catshark.set_disabled(true)
		
	var animal_stat = animal_stat_selection.instance()
	$item_information/cost_text.text = str(animal_stat.cost)
	$item_information/health_text.text = str(animal_stat.health)
	$item_information/energy_text.text = str(animal_stat.energy)
	$item_information/description.text = str(description_text)
	$item_information/specie_name.text = str(entity_name)

	cost_item = animal_stat.cost

func masked_button_pressed():
	cost_item = null
	entity_name = null
	texture = null
	description_text = str("")
	$item_information/picture_bg.set_texture(masked_background)

	for node in get_tree().get_nodes_in_group("animal_animation") :
		node.queue_free()
		
	for node in get_tree().get_nodes_in_group("vegetal_animation") :
		node.queue_free()
		
	entity_name = null
	texture = null
	
	for button in get_tree().get_nodes_in_group("animals_button") :

		button.set_disabled(false)
		button.set_pressed(false)
	
	
	for node in get_tree().get_nodes_in_group("vegetals_texture") :
		node.queue_free()
		
		entity_name = null
		texture = null
	for button in get_tree().get_nodes_in_group("vegetals_button") :

		button.set_disabled(false)
		button.set_pressed(false)
	
		
	#var animation_texture = null
	$item_information/animal_picture.set_texture(texture)
	
	$item_information/specie_name.text = str("???")
	$item_information/cost_text.text = str("???")
	$item_information/health_text.text = str("???")
	$item_information/energy_text.text = str("???")
	
	$item_information/description.text = str("")
	
	eat_1.set_texture(null)
	eat_2.set_texture(null)
	produce_1.set_texture(null)
	produce_2.set_texture(null)
	

func _on_fluffilus_button_pressed():
	
	entity_name = "fluffilus"
	var animal_stat_selection = preload("res://entities/fluffilus/fluffilus_adult/fluffilus.tscn")
	animated_texture = preload("res://GUI/items_tree/animal_tree/animal_tree_animation_entities/fluffilus_item_tree_animation.tscn")
	texture = preload ("res://items_selected/fluffilus_item/fluffilus_item_texture.png")
	description_text = "An adorable little plant eater\nThey reproduce quickly"
	
	unmasked_button_pressed(animal_stat_selection)
	
	eat_1.set_texture(null)
	eat_2.set_texture(bush_icon)
	produce_1.set_texture(poop_icon)
	produce_2.set_texture(null)


func _on_catshark_pressed():
	
	if catshark_masked == true :
		
		masked_button_pressed()
		
	else :
		
		entity_name = "sand_catshark"
		var animal_stat_selection = preload("res://entities/sand_catshark/sand_catshark_adult/sand_catshark.tscn")
		animated_texture = preload("res://GUI/items_tree/animal_tree/animal_tree_animation_entities/fluffilus_item_tree_animation.tscn")
		texture = preload("res://entities/sand_catshark/sand_catshark_adult/sprites/side_default/catshark_side_default.png")
		description_text = "cute but cunning"
		
		unmasked_button_pressed(animal_stat_selection)
		
		eat_1.set_texture(mollusc_meat_icon)
		eat_2.set_texture(fish_icon)
		produce_1.set_texture(poop_icon)
		produce_2.set_texture(null)


func _on_coral_ocelot_pressed():

	if coral_ocelot_masked == true :
		masked_button_pressed()
	
	else :
		
		entity_name = "coral_ocelot"
		var animal_stat_selection = preload("res://entities/lionfish/lionfish_adult/lionfish.tscn")
		animated_texture = preload("res://GUI/items_tree/animal_tree/animal_tree_animation_entities/fluffilus_item_tree_animation.tscn")
		texture = preload("res://entities/lionfish/lionfish_adult/sprites/side_default/lionfish_side_default.png")
		description_text = "they're really colorful !"
		
		unmasked_button_pressed(animal_stat_selection)
		
		eat_1.set_texture(mollusc_meat_icon)
		eat_2.set_texture(fish_icon)
		produce_1.set_texture(poop_icon)
		produce_2.set_texture(null)

func _on_cuttledog_pressed():
	
	if cuttledog_masked == true :
		masked_button_pressed()
	
	else :
		
		entity_name = "cuttledog"
		var animal_stat_selection = preload("res://entities/cuttledog/cuttledog_adult/cuttledog.tscn")
		animated_texture = preload("res://GUI/items_tree/animal_tree/animal_tree_animation_entities/fluffilus_item_tree_animation.tscn")
		texture = preload("res://entities/cuttledog/cuttledog_adult/sprites/side_default/cuttledog_default.png")
		description_text = "they eat a lot of different things !"
		
		unmasked_button_pressed(animal_stat_selection)

		eat_1.set_texture(mollusc_meat_icon)
		eat_2.set_texture(berries_icon)
		produce_1.set_texture(poop_icon)
		produce_2.set_texture(null)
		
func _on_rabbibranch_button_pressed():
	

	entity_name = "rabbibranch"
	var animal_stat_selection = preload("res://entities/rabbibranch/rabbibranch_adult/rabbibranch.tscn")		
	animated_texture = preload("res://GUI/items_tree/animal_tree/animal_tree_animation_entities/fluffilus_item_tree_animation.tscn")
	texture = preload("res://items_selected/rabbibranch_item/rabbibranch_item.png")
	description_text ="They're really cute\nThey produce pearls too, that's cool"
	
	unmasked_button_pressed(animal_stat_selection)
	
	eat_1.set_texture(null)
	eat_2.set_texture(bush_icon)
	produce_1.set_texture(pearl_icon)
	produce_2.set_texture(null)
	
	
func _on_ancistrus_button_pressed():
	
	if ancistrus_masked == true :
		masked_button_pressed()
	
	else :
		
		entity_name = "ancistrus"
		var animal_stat_selection = preload("res://entities/ancistrus/ancistrus_adult/ancistrus.tscn")
		animated_texture = preload("res://GUI/items_tree/animal_tree/animal_tree_animation_entities/fluffilus_item_tree_animation.tscn")
		texture = preload ("res://items_selected/ancistrus_item/ancistrus_item_texture.png")
		description_text = "they eat poop, that's useful"
		
		unmasked_button_pressed(animal_stat_selection)

		eat_1.set_texture(null)
		eat_2.set_texture(poop_icon)
		produce_1.set_texture(bush_icon)
		produce_2.set_texture(null)
	
	
	
func _on_bush_button_pressed():
	
	entity_name = "bush"
	var vegetal_stat_selection = preload("res://food/vegetals/bush/bush.tscn")
	animated_texture = preload("res://food/vegetals/bush/bush.tscn")
	texture = preload("res://food/vegetals/bush/sprite/bush.png")
	description_text = "a nice little bush\nit grows easily and quickly"
	
	unmasked_button_pressed(vegetal_stat_selection)
	
func _on_pearl_flower_button_pressed():
	entity_name = "pearl_flower"
	var vegetal_stat_selection = preload("res://food/vegetals/flowers/pearl_flower/pearl_flower.tscn")
	animated_texture = preload("res://food/vegetals/bush/bush.tscn")
	texture = preload("res://food/vegetals/flowers/pearl_flower/sprites/pearl_flower_open.png")
	description_text = "a flower that gives pearls !"
	
	unmasked_button_pressed(vegetal_stat_selection)
	
func _on_strength_flower_button_pressed():
	entity_name = "strength_flower"
	var vegetal_stat_selection = preload("res://food/vegetals/flowers/strength_flower/strength_flower.tscn")
	animated_texture = preload("res://food/vegetals/bush/bush.tscn")
	texture = preload("res://food/vegetals/flowers/pearl_flower/sprites/pearl_flower_open.png")
	description_text = "produce nutrients for a healthy ground !!"
	
	unmasked_button_pressed(vegetal_stat_selection)
	
func _on_water_flower_button_pressed():
	entity_name = "water_flower"
	var vegetal_stat_selection = preload("res://food/vegetals/flowers/water_flower/water_flower.tscn")
	animated_texture = preload("res://food/vegetals/bush/bush.tscn")
	texture = preload("res://food/vegetals/flowers/water_flower/sprites/water_flower_open.png")
	description_text = "a beautiful plant that stock water !"
	
	unmasked_button_pressed(vegetal_stat_selection)

	
func _on_berry_bush_button_pressed():
	
	if berry_bush_masked == true :
		
		masked_button_pressed()
	
	else :	
	
		entity_name = "berry_bush"
		var vegetal_stat_selection = preload("res://food/vegetals/bush/bush.tscn")
		animated_texture = preload("res://food/vegetals/bush/bush.tscn")
		texture = preload("res://food/vegetals/bush/sprite/bush.png")
		description_text = "a bush that grows berries\nSome animals love it !"
		

		for button in get_tree().get_nodes_in_group("vegetals_button") :
			button.set_disabled(false)
			button.set_pressed(false)
			
		unmasked_button_pressed(vegetal_stat_selection)


func _on_tree_button_pressed():
	
	if tree_masked == true :
			masked_button_pressed()
	
	else :
	
		entity_name = "tree"
		var vegetal_stat_selection = preload("res://food/vegetals/tree/tree.tscn")
		texture = preload("res://food/vegetals/tree/sprites/tree_good_health.png")
		animated_texture = preload("res://food/vegetals/bush/bush.tscn")
		description_text = "a big and pretty tree"
		
		for button in get_tree().get_nodes_in_group("vegetals_button") :
			button.set_disabled(false)
			button.set_pressed(false)
			
		unmasked_button_pressed(vegetal_stat_selection)

func _on_clover_tree_button_pressed():
	
	
	entity_name = "clover_tree"
	var vegetal_stat_selection = preload("res://food/vegetals/clover_tree/clover_tree.tscn")
	texture = preload("res://food/vegetals/tree/sprites/tree_good_health.png")
	animated_texture = preload("res://food/vegetals/bush/bush.tscn")
	description_text = "A nice tree.\nClover grows well near it"
	
	for button in get_tree().get_nodes_in_group("vegetals_button") :
			button.set_disabled(false)
			button.set_pressed(false)
			
	unmasked_button_pressed(vegetal_stat_selection)

func _on_big_tree_button_pressed():
	
	if big_tree_masked == true :
			masked_button_pressed()
	
	else :
		entity_name = "big_tree"
		var vegetal_stat_selection = preload("res://food/vegetals/bush/bush.tscn")
		texture = preload("res://food/vegetals/bush/sprite/bush.png")
		animated_texture = preload("res://food/vegetals/bush/bush.tscn")
		description_text = "It produces fruits that some animals love !"
		
		for button in get_tree().get_nodes_in_group("vegetals_button") :
			button.set_disabled(false)
			button.set_pressed(false)
			
		unmasked_button_pressed(vegetal_stat_selection)
	


func _on_close_item_tree_pressed():
	get_tree().paused = false
	self.queue_free()
	cost_item = null
	

#unmask masked buttons

func _on_catshark_unmasked():
	catshark_masked = false

func _on_cuttledog_unmasked():
	cuttledog_masked = false

func _on_coral_ocelot_unmasked():
	coral_ocelot_masked = false
	
func _on_ancistrus_button_unmasked():
	ancistrus_masked = false

func _on_berry_bush_button_unmasked():
	berry_bush_masked = false

func _on_tree_button_unmasked():
	tree_masked = false 

func _on_big_tree_button_unmasked():
	big_tree_masked = false
















