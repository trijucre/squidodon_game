extends "res://entities/robot/robot_scene_base.gd"



onready var spot_1 = $bag/spot_1
onready var spot_2 = $bag/spot_2
onready var spot_3 = $bag/spot_3
#onready var container = $container
onready var top_sprite = $bag/top
onready var timer = $Timer


func _init():


	spot_1_empty = true
	spot_2_empty = true
	spot_3_empty = true
	cook_time = 0
	cooking = false
	meal_ready = false
	type = "cook"

func _ready():

	if spot_1_empty == false :
		recolt(spot_1, ingredient_1_name, ingredient_1_id )

	if spot_2_empty == false :
		recolt(spot_2, ingredient_2_name, ingredient_2_id )

	if spot_3_empty == false :
		recolt(spot_2, ingredient_2_name, ingredient_2_id )
		
	if meal != null and meal_ready == false :
		top_sprite.show()
		timer.start()
	
	elif meal != null and meal_ready == true :
		cook_time = 60
		timer.start()

	
func _process(delta):
	if asked_to_take == true :
		take(delta)
		
	if asked_to_cook == true :
		cook(delta)
	
	if asked_to_depose == true :
		depose(delta)
	
	._process(delta)


func _on_take_pressed():

	_cancel_action()
	asked_to_take = true
		
func _on_cook_pressed():

	_cancel_action()
	asked_to_cook = true

func _on_depose_pressed():

	_cancel_action()
	asked_to_depose = true

func recolt(node, ingredient_name, ingredient_id):

	var ingredient_scene = load ("res://food/" + str(ingredient_name) + "/" + str(ingredient_name)+".tscn")

	var ingredient = ingredient_scene.instance()
	ingredient.id = ingredient_id

	node.add_child(ingredient)
	ingredient.remove_from_group("Persist")
	ingredient.remove_from_group("persist_child")
	
func take(delta) :
	 # get the Physics2DDirectSpaceState object
	var space = get_world_2d().direct_space_state
	# Get the mouse's position
	var mousePos = get_global_mouse_position()
	# Check if there is a collision at the mouse position
	var collision_objects = space.intersect_point(mousePos, 1)
	
	if collision_objects :
		if collision_objects[0].collider.is_in_group("produced")  and Input.is_action_pressed("left_click_mouse") and moving == false :
			target = collision_objects[0].collider
			destination = collision_objects[0].collider.position
			moving = true
	if moving == true :
		position_difference = destination - position
		smoothed_velocity =  position_difference.normalized()* speed * delta #position_difference
		position += smoothed_velocity
		if position_difference.length() <= 2 :
			smoothed_velocity =  position_difference* speed * delta
			asked_to_take = false
			moving = false
			destination = null
			if target != null :
				if target.is_in_group("produced") and container == null  :
					
					if spot_1_empty == true :
						recolt(spot_1, target.specie, target.id)
						spot_1_empty = false
						ingredient_1_name = target.specie
						ingredient_1_id = target.id
						target.queue_free()
						
					elif spot_2_empty == true :
						recolt(spot_2, target.specie, target.id)
						spot_2_empty = false
						ingredient_2_name = target.specie
						ingredient_2_id = target.id
						target.queue_free()		
										
					elif spot_3_empty == true :
						recolt(spot_3, target.specie, target.id)
						spot_3_empty = false
						ingredient_3_name = target.specie
						ingredient_3_id = target.id
						target.queue_free()		
									
					else :
						print ("all cook bot spots are full")



func cook (delta):

	var ingredients_available =  [ingredient_1_name, ingredient_2_name, ingredient_3_name]

	if ingredients_available.count("bush") > 2 :
		meal = null#"salad"
		
	if ingredients_available.count("poop")>=1 :
		meal = "fertilizer"
		
	elif ingredients_available.count("herb") >= 2 and ingredients_available.count(null) <= 0  :
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

		top_sprite.show()
		if cook_time > 0 :
			cook_time = 0
		timer.start()
		asked_to_cook = false
		
	
	
func delete_ingredient(spot):
	for child in spot.get_children():
		child.queue_free()

func depose(delta):
	if Input.is_action_pressed("left_click_mouse") and moving == false:
		destination = get_global_mouse_position()
		moving = true
	if moving == true :
		position_difference = destination - position
		smoothed_velocity =  position_difference.normalized()* speed * delta #position_difference
		position += smoothed_velocity
		if position_difference.length() <= 3 :

			if container != null and energy >= 1 :
	
				for node in container_node.get_children() :
					node.queue_free()
				var tree_produced_object = load("res://food/" + str(container) + "/" +  str(container) + ".tscn")
				var object_container = tree_produced_object.instance()
				if container_id != null :
					object_container.id = container_id
				
				get_tree().root.get_node("Game//game_start/YSort").add_child(object_container)
			
				object_container.position = self.position+ last_direction.normalized() * 75
				energy -= 1
				emit_signal("stat_changed", energy, energy_max)
				container = null
				container_id = null
				emit_signal("object_recolted", container, 0, 0)
			asked_to_depose = false
			moving = false
			destination = null
	
	

func _on_cook_timer_timeout():
	cook_time += 1

	if cook_time >= 30 :

		timer.stop()
		top_sprite.hide()
		var meal_scene = load("res://food/" + str(meal) + "/" + str(meal) + ".tscn")
		var meal_cooked = meal_scene.instance()	
		container_node.add_child(meal_cooked)
		meal_cooked.remove_from_group("Persist")
		meal_cooked.remove_from_group("persist_child")
		meal_ready = true
		container = meal

