extends KinematicBody2D

signal water_earned
signal strength_earned

signal stat_changed

# Player movement speed
export var speed = 175
var last_direction = Vector2(0, 1)
var special_playing = false
var attack_playing = false

var health = 100
var health_max = 100
var energy = 20
var energy_max = 20
var resistance = 20
var attack_damage = 30
var save_value = "Persist_child"
onready var sprite = $sprite
onready var container_sprite_front = $bag_front
onready var container_sprite_back = $bag_back
onready var bag = $bag
onready var container_node = $bag/container
onready var energy_bar = $CanvasLayer/energy_bar

var sprite_right = true

onready var refill_scene = preload("res://popup/produced_spent_indicator/strength_earned_particle.tscn")

#var poop = preload ("res://food/poop/poop.tscn")
var fertilizer = preload ("res://food/fertilizer/fertilizer.tscn")

var option_1_bought = false
var option_2_bought = false
var option_3_bought = false
var option_4_bought = false
var option_5_bought = false
var option_6_bought = false
var option_7_bought = false

var container

var container_id

var popup_scene = preload ("res://popup/popup_robot/popup_robot.tscn")
var popup_position = Vector2 (0, - 150)
var object_position = Vector2 (0, 0)

func _ready():
	
	add_to_group("robot", true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	
	self.connect("water_earned",get_tree().root.get_node("Game/game_start"), "_on_water_earned")
	self.connect("strength_earned",get_tree().root.get_node("Game/game_start"), "_on_strength_earned")
	
	#self.connect("stat_changed", get_tree().root.get_node("Game/game_start/CanvasLayer/robot_life_and_energy"), "_on_stats_changed")

	emit_signal("stat_changed", energy)
	

	
func _physics_process(delta):

	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	
	# Appel movement
	var movement = speed * direction * delta
	if special_playing or attack_playing:
		movement = 0 * movement
	move_and_collide(movement)
	
	if not special_playing and not attack_playing:# Animate player based on direction
		animates_player(direction)
	
	$RayCast2D.cast_to = last_direction.normalized() * 100
	

	
func animates_player(direction: Vector2):
	
	if Input.is_action_pressed("left") and sprite_right == true :
		sprite.scale.x = -1
		#container_sprite_back.scale.x = -1
		#container_sprite_front.scale.x = -1
		bag.scale.x = -1
		bag.position.x = 16 
		sprite_right = false
		
	if Input.is_action_pressed("right") and sprite_right == false :
		sprite.scale.x = 1
		#container_sprite_back.scale.x = 1
		#container_sprite_front.scale.x = 1
		bag.scale.x = 1
		bag.position.x = - 16
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
func _input(event):
	
	if Input.is_action_pressed("left"):
		sprite.scale.x = -1
		
	if Input.is_action_pressed("right"):
		sprite.scale.x = 1
		
	if event.is_action_pressed("interact"):
		
		var target = $RayCast2D.get_collider()
		if target != null :
			print ("target, robot")
			if target.is_in_group("animal")  and energy > 0 and target.pet == false :
				if target.happiness < target.max_happiness :
					target.happiness += 5
					var happy_popup = target.love_bubble.instance()
					target.add_child(happy_popup)
					happy_popup.position = target.popup_position
					self.energy -= 1
					emit_signal("stat_changed", energy)	
					target.pet = true
					
					var popup = popup_scene.instance()
					self.add_child(popup)
					popup.position = popup_position
					
			if target.is_in_group("meteor") :
				print("meteor found, robot")
				energy += target.fuel
				emit_signal("strength_earned", target.strength)
				emit_signal("water_earned", target.water)
				target.queue_free()
			
			if target.is_in_group("parasite") and energy > 0 :
				target.health -= attack_damage
				self.energy -= 1
				emit_signal("stat_changed", energy)	
				
				var popup = popup_scene.instance()
				popup.sprite_text = "angry"
				self.add_child(popup)
				popup.position = popup_position
				

			if target.is_in_group("poop") and container == null :
				print ("poop found by robot")
				container = target.specie
				var tree_produced_object = load("res://food/" + str(container) + "/" +  str(container) + ".tscn")
				target.queue_free()
				var object_container = tree_produced_object.instance()
				object_container.position = object_position
				object_container.in_box = true
				object_container.save_value == "Persist_child_robot"
				container_node.add_child(object_container)



			if target.is_in_group("fertilizer") and container == null  :
				container = target.specie
				var tree_produced_object = load("res://food/" + str(container) + "/" +  str(container) + ".tscn")
				target.queue_free()
				var object_container = tree_produced_object.instance()
				object_container.position = object_position
				object_container.in_box = true
				object_container.save_value == "Persist_child_robot"
				container_node.add_child(object_container)
								

			if target.is_in_group("produced") and container == null  :
				
				container = target.specie
				container_id = target.id
				var tree_produced_object = load("res://food/" + str(container) + "/" +  str(container) + ".tscn")
				target.queue_free()
				var object_container = tree_produced_object.instance()
				object_container.id = container_id
				object_container.position = object_position
				object_container.in_box = true
				object_container.save_value == "Persist_child_robot"
				container_node.add_child(object_container)
			
				emit_signal("stat_changed", energy)	
				emit_signal("object_recolted", container, 1, 1)


		else :

			if container != null and energy >= 1 :
				
				for node in get_node("bag/container").get_children() :
					node.queue_free()
				var tree_produced_object = load("res://food/" + str(container) + "/" +  str(container) + ".tscn")
				print ("robo object instanced  " ,tree_produced_object)
				var object_container = tree_produced_object.instance()
				if container_id != null :
					object_container.id = container_id
				get_tree().root.get_node("Game//game_start/YSort").add_child(object_container)
		
				object_container.position = self.position+ last_direction.normalized() * 75
				energy -= 1
				emit_signal("stat_changed", energy)
				container = null
				container_id = null
				emit_signal("object_recolted", container, 0, 0)
				
					
				
	#	if (energy >= 2 and !attack_playing ) :
	#		energy = energy - 2
	#		emit_signal("squidodon_stats_changed", self)
	#		attack_playing = true
	#		var animationlist = [get_animation_direction(last_direction) + "_attack_1",get_animation_direction(last_direction) + "_attack_2"]
	#		var randomattack = animationlist[randi()%animationlist.size()]
			#var attackanimation_2 = get_animation_direction(last_direction) + "_attack_2" 
	#		sprite.play(randomattack)
			
	#		var target = $RayCast2D.get_collider()
	#		if target != null and target.is_in_group("animal") :
	#			target.hit(attack_damage)




func _on_make_fertilizer_pressed():

	for node in container_node.get_children() :
		if node.is_in_group("poop") and energy >= 1 :
			container_node.remove_child(node)
			var fertilizer_container = fertilizer.instance()
			fertilizer_container.in_box = true
			container_node.add_child(fertilizer_container)
			fertilizer_container.position = object_position
			self.energy -= 1
			emit_signal("stat_changed", energy)	
			container = "fertilizer"
	


func _on_squidodon_animation_finished():
	special_playing = false # Replace with function body.
	attack_playing = false


func _on_Timer_timeout():
	if energy > 0 :
		var new_energy = energy - 1
		energy = new_energy

		
	if energy <= 0 :
		var new_health = health - 1
		health = new_health


func _on_refill_pressed():
	
	var object_number = get_node("bag/container").get_child_count()
	var object_in_bag = get_node("bag/container").get_children()
	if object_number >= 1 :
		for node in object_in_bag :
			energy += node.health
			node.queue_free()
		

			var refilled = refill_scene.instance()
			self.add_child(refilled)
			refilled.position = Vector2(0, -150)
			
		container = null
		container_id = null
	
	emit_signal("stat_changed", energy)
		
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"energy" : energy,
		"option_1_bought" : option_1_bought,
		"option_2_bought" : option_2_bought,
		"option_3_bought" : option_3_bought,
		"option_4_bought" : option_4_bought,
		"option_5_bought" : option_5_bought,
		"option_6_bought" : option_6_bought,
		"option_7_bought" : option_7_bought,
		"container" : container,
		"container_id" : container_id ,
	}
	return save

