extends KinematicBody2D

signal water_earned
signal strength_earned
signal mana_earned

signal stat_changed
signal robot_here

# Player movement speed
var speed = 175
var last_direction = Vector2(0, 1)
var special_playing = false
var attack_playing = false
var id = str(self.get_instance_id())
var type
var energy = 3
var energy_max = 3
var save_value = "Persist_child"
onready var sprite = $sprite
onready var bag = $bag
onready var bag_texture = $bag/bag_back
onready var container_node = $bag/container

var moving_to_point = Vector2(0,0)

var sprite_right = true

onready var refill_scene = preload("res://popup/produced_spent_indicator/strength_earned_particle.tscn")
onready var robot_action_scene = preload ("res://GUI/robot_interface/robot_action.tscn")
onready var robot_button_scene = preload ("res://GUI/user_interface/robot_button/robot_button.tscn")
onready var camera = get_tree().root.get_node("Game/game_start/Camera2D")

#var poop = preload ("res://food/poop/poop.tscn")
var fertilizer = preload ("res://food/fertilizer/fertilizer.tscn")

var container

var container_id

var popup_scene = preload ("res://popup/popup_robot/popup_robot.tscn")
var popup_position = Vector2 (0, - 150)
var object_position = Vector2 (0, 0)


#const SMOOTH_SPEED = 200
var position_difference = Vector2()
var smoothed_velocity = Vector2()
var asked_to_move = false
var asked_to_short_move = false
var asked_to_take = false
var asked_to_depose = false
var asked_to_water = false
var asked_to_hug = false
var asked_to_cook = false
var destination
var moving = false
var target
var time_to_recharge = 0

var movement_available = true
var take_available = false
var depose_available = false
var refill_available = false
var hug_available= false
var cook_available = false

#variable cook robot
#onready var spot_1
#onready var spot_2
#onready var spot_3
#onready var top_sprite
#onready var timer

var spot_1_empty
var ingredient_1_name
var ingredient_1_id
var spot_2_empty
var ingredient_2_name
var ingredient_2_id
var spot_3_empty 
var ingredient_3_name
var ingredient_3_id
var meal
var cook_time
var cooking 
var meal_ready 

func _ready():
	
	add_to_group("robot", true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	add_to_group(id, true)
	self.connect("water_earned",get_tree().root.get_node("Game/game_start"), "_on_water_earned")
	self.connect("strength_earned",get_tree().root.get_node("Game/game_start"), "_on_strength_earned")
	self.connect("mana_earned",get_tree().root.get_node("Game/game_start"), "_on_mana_earned")
	
	var robot_nodepath = self.get_path()
	
	var robot_button = robot_button_scene.instance()
	robot_button.robot_nodepath = robot_nodepath
	robot_button.id = id
	robot_button.type = type
	get_tree().root.get_node("Game/game_start/CanvasLayer/robot_button_node/GridContainer").add_child(robot_button)
	var node_path = robot_button.get_path()
	
	self.connect("stat_changed", get_tree().root.get_node(node_path), "_on_stats_changed")
	emit_signal("stat_changed", energy, energy_max)
	
	print ("robot container : ", container)

func _process(delta):
	
	# Get player input
	var direction: Vector2
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	if energy > energy_max :
		energy = energy_max

	# Appel movement
	if asked_to_move == true :
		move(delta)
	
	if 	asked_to_short_move == true :
		short_move(delta)

	if not special_playing and not attack_playing:# Animate player based on direction
		animates_player(direction)
	
	

	
func animates_player(direction: Vector2):

	
	if direction.x > 0 and sprite_right == true :
		sprite.scale.x = -1
		bag.position.x = -19
		#container_sprite_back.scale.x = -1
		#container_sprite_front.scale.x = -1
		bag.scale.x = -1
		sprite_right = false
		
	if direction.x < 0 and sprite_right == false :
		sprite.scale.x = 1
		#container_sprite_back.scale.x = 1
		#container_sprite_front.scale.x = 1
		bag.scale.x = 1
		bag.position.x = 19
		sprite_right = true
	
	if direction != Vector2.ZERO:
		# update last_direction
		last_direction = direction
		
		# Choose walk animation based on movement direction
		var animation = "walk"
		
		# Play the walk animation
		sprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = "default"
		sprite.play(animation)
		

#animation special attack	



func _on_squidodon_animation_finished():
	special_playing = false # Replace with function body.
	attack_playing = false


func _on_refill_pressed():

	_cancel_action()
	var object_number = get_node("bag/container").get_child_count()
	var object_in_bag = get_node("bag/container").get_children()
	if object_number >= 1 :
		for node in object_in_bag :
			energy += node.health
			emit_signal("stat_changed", energy, energy_max)
			node.queue_free()
			

			var refilled = refill_scene.instance()
			self.add_child(refilled)
			refilled.position = Vector2(0, -150)
				
		container = null
		container_id = null
		
	emit_signal("stat_changed", energy)

func _on_destroy_robot_pressed():
	self.queue_free()

func _on_go_to_robot_pressed():
	camera.position = position
	_on_robot_action_pressed()

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"energy" : energy,
		"container" : container,
		"container_id" : container_id ,
		"asked_to_depose" : asked_to_depose,
		"asked_to_move" : asked_to_move,
		"asked_to_take" : asked_to_take,
		"asked_to_water" : asked_to_water,
		"asked_to_hug" : asked_to_hug,
		"time_to_recharge" : time_to_recharge,
		"id" : id,
		"type": type,
		"destination": destination,
		"moving" : moving,
		#"target" : str(target),
		#save for cook robot
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
	print ("tagret saved : ",target)
	return save
	


func _on_robot_action_pressed():

	var robot_action = robot_action_scene.instance()
	#get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(robot_action)
	$CanvasLayer.add_child(robot_action)
	#robot_action.position = position

func _on_move_pressed():
	_cancel_action()
	asked_to_move = true

func _on_short_move_pressed() :
	_cancel_action()
	asked_to_short_move = true
	print ("asked to short move")

func short_move(delta):
	#print ("moving shoud be false, moving : ", moving)
	if moving == false :
		destination = get_global_mouse_position()
		moving = true
	if moving == true and asked_to_short_move == true :
		position_difference = destination - position
		smoothed_velocity =  position_difference.normalized()* speed * delta #position_difference
		position += smoothed_velocity
		if position_difference.length() <= 2  :
			asked_to_short_move = false
			moving = false
			destination = null
		

func move(delta):
	if Input.is_action_pressed("left_click_mouse") and moving == false:
		destination = get_global_mouse_position()
		moving = true
	if moving == true and asked_to_move == true :
		position_difference = destination - position
		smoothed_velocity =  position_difference.normalized()* speed * delta #position_difference
		position += smoothed_velocity
		if position_difference.length() <= 2 :
			asked_to_move = false
			moving = false
			destination = null

func _cancel_action():
	asked_to_move = false
	asked_to_take = false
	asked_to_depose = false
	asked_to_water = false
	asked_to_hug = false
	asked_to_cook = false
	moving = false
	destination = null

func _on_Timer_timeout():
	time_to_recharge += 1
	if time_to_recharge >= 60 :
		if energy < energy_max :
			energy += 1
		time_to_recharge = 0
		emit_signal("stat_changed", energy)
		
	
	
