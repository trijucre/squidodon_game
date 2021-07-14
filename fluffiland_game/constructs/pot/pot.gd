extends StaticBody2D

var save_value = "Persist_child"

onready var spot_1 = $spot_1
onready var spot_2 = $spot_2
onready var spot_3 = $spot_3
onready var spot_meal = $spot_meal
onready var top_sprite = $top
onready var timer = $Timer

var spot_1_empty = true
var ingredient_1_name
var ingredient_1_id
var spot_2_empty = true
var ingredient_2_name
var ingredient_2_id
var spot_3_empty = true
var ingredient_3_name
var ingredient_3_id
var meal

var cook_time = 0

var cooking = false

var meal_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("construct", true)
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	add_to_group("pot", true)
	
	if spot_1_empty == false :
		find_place(spot_1, ingredient_1_name, ingredient_1_id )

	if spot_2_empty == false :
		find_place(spot_2, ingredient_2_name, ingredient_2_id )

	if spot_3_empty == false :
		find_place(spot_2, ingredient_2_name, ingredient_2_id )
		
	if meal != null and meal_ready == false :
		top_sprite.show()
		timer.start()
	
	elif meal != null and meal_ready == true :
		cook_time = 60
		timer.start()
		
func _add_ingredient (ingredient_name, ingredient_id) :

	if spot_1_empty == true :	
		find_place(spot_1, ingredient_name, ingredient_id )
		spot_1_empty =  false
		ingredient_1_id = ingredient_id
		ingredient_1_name = ingredient_name
	
	elif spot_2_empty == true :	
		find_place(spot_2, ingredient_name, ingredient_id )
		spot_2_empty =  false
		ingredient_2_id = ingredient_id
		ingredient_2_name = ingredient_name
				
	elif spot_3_empty == true :	
		find_place(spot_3, ingredient_name, ingredient_id )
		spot_3_empty =  false
		ingredient_3_id = ingredient_id
		ingredient_3_name = ingredient_name
	else :
		pass
	
func find_place(node, ingredient_name, ingredient_id):

	var ingredient_scene = load ("res://food/" + str(ingredient_name) + "/" + str(ingredient_name)+".tscn")
	var ingredient = ingredient_scene.instance()
	ingredient.id = ingredient_id
	node.add_child(ingredient)
	ingredient.remove_from_group("Persist")
	ingredient.remove_from_group("persist_child")

	
func _on_cook_button_pressed():
	cook()
	
func cook ():
	
	var ingredients_available =  [ingredient_1_name, ingredient_2_name, ingredient_3_name]
	if ingredients_available.count("bush") > 2 :
		meal = null#"salad"
		
	if ingredients_available.count("poop")>=1 :
		print ("ingredients_available.count(null) ", ingredients_available.count(null) )
		meal = "fertilizer"
		
	elif ingredients_available.count("herb") >= 2 and ingredients_available.count(null) <= 0  :
		print ("ingredients_available.count(null) ", ingredients_available.count(null) )
		meal = "medicine"
	
	if meal != null :
	
		delete_ingredient(spot_1)
		spot_1_empty = true
		ingredient_1_name = null
		ingredient_1_id = null
		delete_ingredient(spot_2)
		spot_2_empty = true
		ingredient_2_name = null
		ingredient_2_id = null
		delete_ingredient(spot_3)
		spot_3_empty = true
		ingredient_3_name = null
		ingredient_3_id = null
		print (" spot_1 ", spot_1 , " spot_1_empty ", spot_1_empty,  " ingredient_1_name ", ingredient_1_name, " ingredient_1_id ", ingredient_1_id)
		top_sprite.show()
		if cook_time > 0 :
			cook_time = 0
		timer.start()
		
	
	
func delete_ingredient(spot):
	for child in spot.get_children():
		child.queue_free()


		


func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"spot_1_empty" : spot_1_empty,
		"ingredient_1_name" : ingredient_1_name,
		"ingredient_1_id" : ingredient_1_id,
		"spot_2_empty" : spot_2_empty,
		"ingredient_2_name" : ingredient_2_name,
		"ingredient_2_id" : ingredient_1_id,
		"spot_3_empty" : spot_3_empty,
		"ingredient_3_name" : ingredient_3_name,
		"ingredient_3_id" : ingredient_1_id,
		"meal" : meal,
		"cooking" : cooking,
		"cook_time" : cook_time,
		"meal_ready" : meal_ready
	}

	return save

		


func _on_Timer_timeout():
	cook_time += 1
	print ("timer on, cook time : ", cook_time)

	if cook_time >= 60 :
		print ("pot cooked !")
		timer.stop()
		top_sprite.hide()
		var meal_scene = load("res://food/" + str(meal) + "/" + str(meal) + ".tscn")
		var meal_cooked = meal_scene.instance()	
		spot_meal.add_child(meal_cooked)
		meal_cooked.remove_from_group("Persist")
		meal_cooked.remove_from_group("persist_child")
		meal_ready = true



