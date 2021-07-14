extends "res://entities/robot/robot_scene_base.gd"

func _init():
	type = "hug"

func _process(delta):
	if asked_to_hug == true :
		hug(delta)
	
	._process(delta)


func _on_hug_pressed(number):
	if number == id :
		_cancel_action()
		asked_to_hug = true
		
func hug(delta):
	var space = get_world_2d().direct_space_state
		# Get the mouse's position
	var mousePos = get_global_mouse_position()
		# Check if there is a collision at the mouse position
	var collision_objects = space.intersect_point(mousePos, 1)
	if collision_objects :
		if collision_objects[0].collider.is_in_group("creature") and Input.is_action_pressed("left_click_mouse") and moving == false :
			target = collision_objects[0].collider
			destination = collision_objects[0].collider.position
			moving = true

	if moving == true :
		position_difference = destination - position
		smoothed_velocity =  position_difference.normalized()* speed * delta #position_difference
		position += smoothed_velocity
		
		if position_difference.length() <= 2 :
			smoothed_velocity =  position_difference* speed * delta
			asked_to_hug = false	
			moving = false
			destination = null
			if target != null :
				print ("target, robot")
				if target.is_in_group("creature")  and energy > 0 :#and target.pet == false :
					if target.happiness < target.max_happiness :
						target.happiness += 5
						var happy_popup = target.love_bubble.instance()
						target.add_child(happy_popup)
						happy_popup.position = target.popup_position
						self.energy -= 1
						emit_signal("stat_changed", energy, energy_max)	
						#target.pet = true
						
						var popup = popup_scene.instance()
						self.add_child(popup)
						popup.position = popup_position
