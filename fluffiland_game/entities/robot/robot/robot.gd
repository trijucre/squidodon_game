extends KinematicBody2D

signal water_earned
signal strength_earned
signal poop_recolted

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

var bush = preload("res://food/vegetals/bush/bush.tscn")
var clover = null
var fruit = null

var option_1_bought = false
var option_2_bought = false
var option_3_bought = false
var option_4_bought = false
var option_5_bought = false
var option_6_bought = false
var option_7_bought = false

var container

func _ready():
	
	add_to_group("robot", true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)

	self.connect("poop_recolted", get_tree().root.get_node("Game/game_start/CanvasLayer/info_robot"), "_on_poop_recolted")

	
	self.connect("stat_changed", get_tree().root.get_node("Game/game_start/CanvasLayer/robot_life_and_energy"), "_on_stats_changed")
	emit_signal("stat_changed")
	
func _physics_process(delta):
	
	randomize()
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
	
	
func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "right"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"
	
	
func animates_player(direction: Vector2):
	
	if Input.is_action_pressed("left"):
		sprite.scale.x = -1
		
	if Input.is_action_pressed("right"):
		sprite.scale.x = 1
	
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
		if target != null and energy > 0 :
		
			if target.is_in_group("animal") :
				if target.happiness < target.max_happiness :
					target.happiness = +10
					var happy_popup = target.love_bubble.instance()
					target.add_child(happy_popup)
					happy_popup.position = target.popup_position
					self.energy -= 1
					emit_signal("stat_changed", "strength", 1)		
			
			if target.is_in_group("parasite") :
				target.health -= attack_damage
				self.energy -= 1
				emit_signal("stat_changed", "strength", 1)		
				
			if target.is_in_group("poop") :
				target.queue_free()
				self.energy -= 1
				emit_signal("poop_recolted", 1)
				emit_signal("stat_changed", "strength", 1)		
								
			if target.is_in_group("bush") :
				target.queue_free()
				self.energy -= 1
				container = target.specie
				emit_signal("stat_changed", "strength", 1)		

		else :

			if container != null :
				print ("robot container is full")
				if container == "bush" :
					print ("robot contains a bush")
					var bush_container = bush.instance()
					get_tree().root.get_node("Game//game_start/YSort").add_child(bush_container)
					bush_container.position = self.position+ last_direction.normalized() * 75
					container = null
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
		
	elif event.is_action_pressed("special"):
	
		var animation = get_animation_direction(last_direction) + "_special"
		if (energy >= 4 and !special_playing ) :
			energy = energy - 4
			emit_signal("squidodon_stats_changed", self)
			special_playing = true
			#var animation = get_animation_direction(last_direction) + "_special"
			sprite.play(animation) 
	
	if Input.is_action_pressed("interact"):
		var target = $RayCast2D.get_collider()
		if target != null and target.is_in_group("bush") :
			eat(target)
				

signal squidodon_stats_changed()

func eat(target) :
	
	health += target.health/10
	
	if health > health_max :
			health = health_max
	emit_signal("squidodon_stats_changed", self)
	
	energy += target.energy/10
	
	if energy > energy_max :
			energy = energy_max
	emit_signal("squidodon_stats_changed", self)
	
	target.energy = 0
	target.health = 0
	
	


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


func _on_robot_updated(option_number):
	print ("robot_updated")
	print (option_number," selectionnée par robot")
	
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
		
func _on_infos_button_pressed():
	pass # Replace with function body.

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"option_1_bought" : option_1_bought,
		"option_2_bought" : option_2_bought,
		"option_3_bought" : option_3_bought,
		"option_4_bought" : option_4_bought,
		"option_5_bought" : option_5_bought,
		"option_6_bought" : option_6_bought,
		"option_7_bought" : option_7_bought
	}
	return save
