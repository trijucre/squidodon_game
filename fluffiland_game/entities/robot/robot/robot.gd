extends "res://entities/robot/robot_scene_base.gd"

func _init():
	type = "take"

func _ready():
	
	if container == "water" :
		var water_scene = load("res://entities/robot/sprites/robot_bag_back_water.png")
						#var water_container = water_scene.instance()
		bag_texture.set_texture(water_scene)

	elif container != null :
		var object_scene = load("res://food/" + str(container) + "/" + str(container) + ".tscn")
		var object = object_scene.instance()
		object.id = container_id
		object.save_value = "Persist_child_robot"
		container_node.add_child(object)

	print ("target robot : ", target)
	
func _process(delta):

	
	if asked_to_take == true :
		take(delta)
		
	if asked_to_depose == true :
		depose(delta)
		
	if asked_to_water == true :
		water(delta)

	._process(delta)

func recolt(target):
	container = target.specie
	container_id = target.id
	var tree_produced_object = load("res://food/" + str(container) + "/" +  str(container) + ".tscn")
	target.queue_free()
	var object_container = tree_produced_object.instance()
	object_container.id = container_id
	object_container.position = object_position
	object_container.in_box = true
	object_container.save_value = "Persist_child_robot"
	container_node.add_child(object_container)
	object_container.remove_from_group("Persist")
	object_container.remove_from_group("persist_child")

func _on_fertilize_pressed():


	for node in container_node.get_children() :
		if node.is_in_group("poop") and energy >= 1 :
			container_node.remove_child(node)
			var fertilizer_container = fertilizer.instance()
			fertilizer_container.in_box = true
			container_node.add_child(fertilizer_container)
			fertilizer_container.position = object_position
			self.energy -= 1
			emit_signal("stat_changed", energy, energy_max)	
			container = "fertilizer"
	
	
func _on_recolt_pressed():

	var object_number = get_node("bag/container").get_child_count()
	var object_in_bag = get_node("bag/container").get_children()
	if object_number >= 1 :
		for node in object_in_bag :
			emit_signal("mana_earned", node.health)
			node.queue_free()
			var refilled = refill_scene.instance()
			self.add_child(refilled)
			refilled.position = Vector2(0, -150)
				
		container = null
		container_id = null



func _on_take_pressed():
	_cancel_action()
	asked_to_take = true
		
func _on_depose_pressed():
	_cancel_action()
	asked_to_depose = true

func _on_water_pressed():
	_cancel_action()
	asked_to_water = true


func take(delta):
	 # get the Physics2DDirectSpaceState object
	var space = get_world_2d().direct_space_state
	# Get the mouse's position
	var mousePos = get_global_mouse_position()
	# Check if there is a collision at the mouse position
	var collision_objects = space.intersect_point(mousePos, 1)
	
	if collision_objects :
		if (collision_objects[0].collider.is_in_group("produced") or collision_objects[0].collider.is_in_group("water_point") ) and Input.is_action_pressed("left_click_mouse") and moving == false :
			target = collision_objects[0].collider
			print ("target selected robot : ", target)
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
				print ("target reached : ", target)
				if target.is_in_group("produced") and container == null  :
					recolt(target)
				
				elif target.is_in_group("water_point") and target.water_stock > 0 and container == null :
						container = "water"
						var water_scene = load("res://entities/robot/sprites/robot_bag_back_water.png")
						#var water_container = water_scene.instance()
						bag_texture.set_texture(water_scene)
						target.water_stock -= 1
						print ("waterpoint water stock :",target.water_stock)
						
				elif target.is_in_group("meteor") :
					print("meteor found, robot")
					energy += target.fuel
					emit_signal("stat_changed", energy, energy_max)
					emit_signal("strength_earned", target.strength)
					emit_signal("water_earned", target.water)
					target.queue_free()
				else : pass
			
func depose(delta):
	if Input.is_action_pressed("left_click_mouse") and moving == false:
		destination = get_global_mouse_position()
		moving = true
	if moving == true :
		position_difference = destination - position
		smoothed_velocity =  position_difference.normalized()* speed * delta #position_difference
		position += smoothed_velocity
		if position_difference.length() <= 1 :
			smoothed_velocity =  position_difference* speed * delta
			if container != null and energy >= 1 :
				for node in get_node("bag/container").get_children() :
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
	
	

func water(delta) :
	var space = get_world_2d().direct_space_state
		# Get the mouse's position
	var mousePos = get_global_mouse_position()
		# Check if there is a collision at the mouse position
	var collision_objects = space.intersect_point(mousePos, 1)
	print ("water function activated")
	if collision_objects :
		if collision_objects[0].collider.is_in_group("vegetals") and Input.is_action_pressed("left_click_mouse") and moving == false :
			target = collision_objects[0].collider
			destination = collision_objects[0].collider.position
			moving = true
			print ("moving to plant to water it")
	if moving == true :
		position_difference = destination - position
		smoothed_velocity =  position_difference.normalized()* speed * delta #position_difference
		position += smoothed_velocity
		
		if position_difference.length() <= 2 :
			smoothed_velocity =  position_difference* speed * delta
			asked_to_water = false	
			moving = false
			destination = null
			if target != null :
				if container == "water" and energy >= 1 and target.is_in_group("vegetals"):
					container = null
					var earth_scene = load("res://entities/robot/sprites/robot_bag_back.png")
					bag_texture.set_texture(earth_scene)
					energy -= 1
					emit_signal("stat_changed", energy, energy_max)
					if target.health < target.health_max :
						print ("water given by robot to", target.specie)
						target.health += 1
						target.happy(1)
				
					




