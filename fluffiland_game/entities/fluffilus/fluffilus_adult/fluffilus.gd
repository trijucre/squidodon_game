extends KinematicBody2D
#save variables




signal ai_stats_changed
signal fluffilus_birth
signal fluffilus_death
signal gender

var save_value = "Persist_child"

var evolution_1 = "cuttledog"
var evolution_1_text = "squid_path"
var cost_text_1 = 25
var evolution_2 = "ammoneep"
var evolution_2_text = "shell_path"
var cost_text_2 = 25
var evolution_3 = "null"
var evolution_3_text = "null"
var cost_text_3 = 0

var produce_1 = "poop"
var produce_2 = null
var eat_1 = "bush"
var eat_2 = null

var other_animation_playing = false

export var speed = 50
export var run_speed = 50
var max_speed = speed
export var steer_force = 1
export var look_ahead = 600
export var num_rays = 12

var rng = RandomNumberGenerator.new()
var rngx = RandomNumberGenerator.new()
var rngy = RandomNumberGenerator.new()
# context array

var ray_directions = []
var love = []
var interest = []
var danger = []
var something_interresting = []
var robot = []

var chosen_dir = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var now
var last_time = 0

var direction : Vector2
var last_direction = Vector2(0, 1)
var sprite_direction = "left"
var change_direction_counter = 10
#var bounce_countdown = 0
var collision
#name
export(String) var random_noun
export(String) var random_adjective
var creature_name 

#animal state
var specie = "fluffilus"
var gender 
var opposite_gender
var pregnant = false
var size = 1
var resistance = 0
var health = 4
var health_max = 4
var energy = 5
var energy_max = 5
var attack_distance = 50
var baby_incubation = 540
var sleeping = false
var id = str(self.get_instance_id())
#hunger
var hungry = false
var hunger = 4
var age = 1
var robot_seen = false
var memory_of_robot = 0
var in_love = false

#meat produced variable (produce meat whaen dying
var meat_produced = false

#variable to know if the creature is wounded, the variable healed will change during the time until it rechaes 10
#It means then that hurt = false.
var hurt = false
var healed = 0
# happiness
var happiness = 0
var max_happiness = 50
var love_happiness = 0.8
var baby_happiness = float(love_happiness) * float(max_happiness)
#attack variables
var attack_cooldown_time = 200
var next_attack_time = 0
var attack_damage = 1

#variables death
export var spawn_area : Rect2 = Rect2(self.position.x, self.position.y, 50, 50)
onready var meat_scene = load("res://food/meat/Squid_meat/squid_meat.tscn")
var pregnancy_time = 0
export var meat_number = 1
var dead = false
var pet = false
var pet_time = 0
var need_friend = true
var time_to_meet_friend = 0
#variable childbirth
var egg_scene = preload("res://entities/fluffilus/fluffilus_egg/fluffilus_egg.tscn")
var egg_number = 1

#variables poop

var food_eaten = false
onready var poop_scene = load("res://food/poop/poop.tscn")
var poop_time = 0

#variable popup
var love_bubble = preload("res://popup/love_bubble.tscn")
var hunger_bubble = preload("res://popup/hunger_bubble.tscn")
var happy_bubble = preload("res://popup/happy_bubble.tscn")
var surprise_bubble = preload("res://popup/surprise_bubble.tscn")
var sleep_bubble = preload("res://popup/sleep_bubble.tscn")
var curious_bubble= preload("res://popup/curious_bubble.tscn")
onready var popup_position = Vector2(0, -200)
# var for bubble per second
#var alert = 0
var sleep_time = 0

# when the aniaml goes to sleep, random, it's set in the _ready function
var sleep_hour
var wake_hour

var directionX 
var directionY 
var movement

var time = 0

var love_here = false
var obstacle_here = false
var danger_here = false
var something_here = false
var robot_here = false

var food_found = false

var creature_size_choose = randi()% 100 + 1
var creature_size



func _ready():

	randomize()
	#size of the creature
	if creature_size == null :
		if creature_size_choose < 23 :
			creature_size = 0.9

		elif creature_size_choose >= 76 :
			creature_size = 1.2
		
		else :
			creature_size = 1
		
	$CollisionShape2D.scale = Vector2(creature_size, creature_size)
	$AnimatedSprite.scale = Vector2(creature_size, creature_size)
	
	#when creature goes to sleep
	if sleep_hour == null :
		sleep_hour = 20 + randi()% 10 + 1
	if wake_hour == null :
		wake_hour = 60 - (randi()% 10 + 1)

	if sleeping == true :
		var sleep_popup = sleep_bubble.instance()
		self.add_child(sleep_popup)
		sleep_popup.position = popup_position
		
	#name of the creature
	if creature_name == null :
		random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
		random_adjective = str(get_random_word_from_file("res://other/adjectiveslist.txt"))
		creature_name = str(random_adjective," ", random_noun)
	
	if opposite_gender == null :
		if gender == "male" :
			opposite_gender = "female"
		if gender == "female" :
			opposite_gender = "male"

	emit_signal("gender",self)
	
	add_to_group("animal", true)
	add_to_group("creature", true)
	add_to_group("prey", true)
	add_to_group(specie, true)
	add_to_group(id, true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	
	self.connect("fluffilus_birth", get_tree().root.get_node("Game/game_start"), "_on_fluffilus_fluffilus_birth")
	self.connect("fluffilus_death", get_tree().root.get_node("Game/game_start"), "_on_fluffilus_fluffilus_death")
	
	
	
	emit_signal("fluffilus_birth")
	
	# emi to show health bar for test, delete this code after test
	emit_signal("ai_stats_changed", self)
	
	
	
	rng.randomize()
	rngx.randomize()
	rngy.randomize()
	
	directionY = 0
	directionX = 0

	
	love.resize(num_rays)
	interest.resize(num_rays)
	danger.resize(num_rays)
	something_interresting.resize(num_rays)
	ray_directions.resize(num_rays)
	robot.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
		interest[i] = 0.0
		danger [i] = 0.0
		love[i] = 0.0
		danger[i] = 0.0
		robot[i] = 0.0
#generate name :
	
func load_file(file_path):
	var file = File.new()
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	return text
	
func get_random_word_from_file(file_path):
	var text = load_file(file_path).strip_edges()
	var words = text.split("\n")
	for i in range(words.size()):
		# here you can add whatever you want to remove
		# any unwanted characters
		words[i] = words[i].replace(",", "")
		words[i] = words[i].replace(".", "")


	return words[randi() % words.size()]
	
	
func animates_animal() :
	
	if chosen_dir.x > 0 :
		if sprite_direction == "left" and change_direction_counter >= 20 :
			$AnimatedSprite.scale.x = -creature_size
			sprite_direction = "right"
			change_direction_counter = 0
		else :
			pass
			
	if chosen_dir.x <= 0 :
		if sprite_direction == "right" and change_direction_counter >= 20 :
			$AnimatedSprite.scale.x = creature_size
			sprite_direction = "left"
			change_direction_counter = 0
		else : 
			pass
	
	
	if chosen_dir != Vector2.ZERO and collision == null :
		# Play walk animation
		last_direction = direction
		$AnimatedSprite.play("side_walk")
		
	else:
		# Play idle animatio
		$AnimatedSprite.play("side_default")
		
	

func _physics_process(delta):
	
	if energy >= energy_max :
		energy = energy_max

	if happiness >= max_happiness :
		happiness = max_happiness

	if 1 in love :
		love_here = true
	else :
		love_here = false

	
	if 1 in danger :
		danger_here = true
		max_speed = run_speed
	else :
		danger_here = false
		max_speed = speed
		
	if 1 in something_interresting :
		something_here = true
	else :
		something_here = false
	
	if 1 in robot :
		robot_here = true
	else :
		robot_here = false
		
	if change_direction_counter <= 20 :
		change_direction_counter += 1
	
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	velocity = velocity.linear_interpolate(desired_velocity, steer_force)
	rotation = 0
	
	movement = velocity * delta
	
	#set collision
	collision = move_and_collide(movement)
	
	var sleep = get_tree().root.get_node("Game/game_start/end_of_day").get_time_left()

	if sleep < sleep_hour or sleep > wake_hour  and hurt == false :
		set_sleep()
		if sleeping == false :
			var sleep_popup = sleep_bubble.instance()
			self.add_child(sleep_popup)
			sleep_popup.position = popup_position
			sleeping = true

		
	elif not other_animation_playing :
		animates_animal()
		set_interest()
		choose_direction()
		if sleeping == true :
			for node in get_children() :
				if node.is_in_group("sleep_popup") :
					node.queue_free()
			sleeping = false
	
	else :
		movement = 0
		max_speed = 0
		chosen_dir = Vector2.ZERO
	
	if health <= 0 :
		death()

func set_interest():

	var space_state = get_world_2d().direct_space_state
	if collision == null :
		for i in num_rays:
			
			var result = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead, [self])
		
			if result :
				
				var relative_position = result["collider"].position - self.position
				var target = result["collider"]
				var distance = relative_position.length()

						
				if target.is_in_group("predator") and target.size >= self.size :
				
					if danger_here == false :
						var surprise_popup = surprise_bubble.instance()
						self.add_child(surprise_popup)
						surprise_popup.position = popup_position
						

					danger[i] = 10 + 2 * ((look_ahead+100 - distance)/(look_ahead+100))
					
				
				elif in_love == true and self.pregnant == false and energy > 0 and target.is_in_group(specie) and not target.is_in_group("baby") and target.gender == opposite_gender and target.pregnant == false and target.in_love == true and not danger_here :
					interest[i] = 1.0 + 5.0 * ((look_ahead+100 - distance)/(look_ahead+100))
					love[i] = 1.0
					if distance <= (attack_distance * 2) :
						
						if self.gender == "male" :
							mate(target)
						var love_popup = love_bubble.instance()
						self.add_child(love_popup)
						love_popup.position = popup_position
						love[i] = 0.0
						need_friend = false
						

				elif energy <= hunger and target.is_in_group("herb") and not danger_here and not love_here and target.eatable == true  :
						
					interest[i] = 0.1 + (randi()*1.0 + 0.1 + 2.0) * ((look_ahead+100 - distance)/(look_ahead+100))
					something_interresting[i] = 1.0
					if distance < attack_distance :
						eat(target)
						something_interresting[i] = 0.0
						
				elif target.is_in_group(specie) and target.sleeping == false and energy > hunger and not danger_here and not love_here and need_friend == true :
					
					interest[i] = 0.1 + (randi()*1.0 + 0.1 + 2.0) * ((look_ahead+100 - distance)/(look_ahead+100))
					something_interresting[i] = 1.0
					var friend_distance = 3 * attack_distance
					if distance < friend_distance :
						var happy_popup = happy_bubble.instance()
						self.add_child(happy_popup)
						happy_popup.position = popup_position
						happiness += 5
						need_friend = false
					
				elif target.is_in_group("robot") and pet == false and not danger_here and not love_here and not something_here and robot_seen == false :
					robot_seen = true
					if self.get_global_position().distance_to(target.get_global_position()) <= look_ahead/2 :
						interest[i] = 0.1 + (randi()*1.0 + 0.1 + 2.0) * ((look_ahead+100 - distance)/(look_ahead+100))
						robot[i] = 1.0
						question()
						robot[i] = 0.0
						#robot[i] = 0.0
							
					
						
				#herd movement, for herbivores, increase reproduction chances
				#elif target.is_in_group(specie) and not something_here and not love_here and not predator_here   :
					#interest[i] = 0.1 + ((look_ahead+100 - distance)/(look_ahead+100))
					#friend[i] = 1.0
					#if distance < attack_distance*2 :
					#	interest[i] = 0.0
					#	friend[i] = 0.0
				else :
					interest[i] = 0.0
					danger[i] = 0.0
					something_interresting[i] = 0.0
					love[i] = 0.0
					robot[i] = 0.0

			else :
				interest[i] = 0.0
				danger[i] = 0.0
				something_interresting[i] = 0.0
				love[i] = 0.0
				robot[i] = 0.0
				
	if collision != null :
		set_default_interest()
		
	if not something_here and not love_here and not danger_here and not robot_here:
		
		set_default_interest()
		

			
			

func set_default_interest():
	# Default to moving forward
	var last_directionX = directionX
	var last_directionY = directionY
	
	max_speed = speed
	
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(Vector2(directionX ,  directionY))
		interest[i] = max(0, d)
					
	now = OS.get_ticks_msec()
	if now - last_time > 3000:
		
		rngx.randomize()
		rngy.randomize()
		
		if collision != null :

			directionX =  -directionX + rngx.randf_range(-1, 1)
			directionY = -directionY + rngy.randf_range(-1, 1)
				
		else :
			
			var random_movement = randi()%100 + 1
			if energy <= 0 :
				
				if random_movement <= 30 :
					directionX = 0
					directionY = 0
					
				elif random_movement <= 50 :
					directionX = directionX
					directionY = directionY
				
				else :	
					directionX = last_directionX + rngx.randf_range(-0.1, 0.1)
					directionY = last_directionY + rngy.randf_range(-0.1, 0.1)
			
			if energy > 0 :
				
				if random_movement <= 70 :
					directionX = 0
					directionY = 0
					
				elif random_movement <= 80 :
					directionX = directionX
					directionY = directionY
				
				else :	
					directionX = last_directionX + rngx.randf_range(-0.1, 0.1)
					directionY = last_directionY + rngy.randf_range(-0.1, 0.1)
			
		last_directionX = directionX
		last_directionY = directionY
		
		last_time = now
		
			
func set_sleep():

	movement = 0
	other_animation_playing = true
	var animation = "side_sleep"
	$AnimatedSprite.play(animation)
	chosen_dir = Vector2.ZERO
	

func choose_direction():
	
	# Eliminate interest in slots with danger

	for i in num_rays:
		if danger[i] > 0.0 :
			interest[i] -=  danger[i]

		else :
			interest[i] = interest[i] 
	
			
	# Choose direction based on remaining interest

	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	
	update()
	chosen_dir = chosen_dir.normalized()


func mate(target) :
	
	if target.pregnant == false and target.gender == "female" :
		target.pregnant = true
		target.pregnancy_true()
	
	happiness += 10
		

func eat(target) :

	max_speed = 0
	movement = 0
	other_animation_playing = true
	var animation = "side_attack"
	$AnimatedSprite.play(animation)
	
	health += target.health
	if health > health_max  :		
		health = health_max
	emit_signal("ai_stats_changed", self)
		
	energy += target.energy
	if energy > energy_max :
		energy = energy_max
	emit_signal("ai_stats_changed", self)
		
	target.energy = 0
	target.health = 0
		
	food_eaten = true
		
	var happy_popup = happy_bubble.instance()
	self.add_child(happy_popup)
	happy_popup.position = popup_position
	
	max_speed = speed
	
	happiness += target.happiness


func question():

	var curious_popup = curious_bubble.instance()
	self.add_child(curious_popup)
	curious_popup.position = popup_position
	#max_speed = 0
	#movement = 0
	other_animation_playing = true
	var animation = "side_default"
	$AnimatedSprite.play(animation)
	max_speed = speed

	
	

func produce_meat() :
	
	for i in meat_number :
		var meat = meat_scene.instance()
		get_tree().root.get_node("Game//game_start/YSort").add_child(meat)

		meat.position.x = self.position.x + rng.randf_range(0, spawn_area.size.x)
		meat.position.y = self.position.y + rng.randf_range(0, spawn_area.size.y)

func pregnancy_true() :
	var love_popup = love_bubble.instance()
	self.add_child(love_popup)
	
	love_popup.position = popup_position
	
	emit_signal("gender",self)


func pregnancy_end():
	
	for i in egg_number :
		
		var egg = egg_scene.instance()
		get_tree().root.get_node("Game//game_start/YSort").add_child(egg)
		
		if sprite_direction == "right" :
			egg.position.x = self.position.x - 50
			egg.position.y = self.position.y + randi () % -50 + 50
			
		if sprite_direction == "left" :
			egg.position.x = self.position.x + 50
			egg.position.y = self.position.y + randi () % -50 + 50


func poop() :
	var poop = poop_scene.instance()
	get_tree().root.get_node("Game/game_start/YSort").add_child(poop)
		
	if sprite_direction == "right" :
		poop.position.x = self.position.x - 70
		poop.position.y = self.position.y - 15
		
	if sprite_direction == "left" :
			poop.position.x = self.position.x + 70
			poop.position.y = self.position.y - 15



func death():
	$energyandlife.stop()
	chosen_dir = Vector2.ZERO
	set_process(false)
	dead = true
	if meat_produced == false :
		produce_meat()
		meat_produced = true
		
func _on_AnimatedSprite_animation_finished():
	other_animation_playing = false
	
	if dead == true :
		get_tree().queue_delete(self)
		emit_signal("fluffilus_death")


func _on_energyandlife_timeout():
	if food_eaten == true :
		poop_time += 1
		if poop_time >= 60 :
			poop()
			poop_time = 0
			food_eaten = false
		
	if pregnant == true :
		pregnancy_time += 1
		if pregnancy_time >= baby_incubation :
			pregnancy_end()
			pregnancy_time = 0
			pregnant = false

	
	if happiness >= max_happiness :
		happiness = max_happiness
	
	if happiness >= baby_happiness and in_love == false :
		in_love = true
		
	elif happiness < baby_happiness and in_love == true  :
		in_love = false

	
	if energy <= 0 and hungry == false :
		hungry = true
		var hunger_popup = hunger_bubble.instance()
		self.add_child(hunger_popup)
		hunger_popup.position = popup_position

				
	elif energy >= 1 and hungry == true :
		for node in get_children() :
			if node.is_in_group("hunger_popup") :
				node.queue_free()
		if 	 energy >= energy_max :
				hungry = false
		
	if hurt == true and healed < 10 :
		happiness -= 1
		healed += 1
	
	if hurt == true and healed >= 10 :
		healed = 0
		hurt = false
		
	if pet == true :
		pet_time += 1
		if pet_time >= 60 :
			pet = false
			pet_time = 0
			
	if robot_seen == true :
		memory_of_robot += 1
		if memory_of_robot >= 5 :
			robot_seen = false
			memory_of_robot = 0
	
	if need_friend == false :
		time_to_meet_friend += 1
		if time_to_meet_friend >= 60 :
			need_friend = true
			time_to_meet_friend = 0
		
	
	time += 1
	if time >= 60 :
		age += 1
		time = 0
		
		if energy > 0 :
			energy -= 1
			happiness -= 1
		else : 
			health -= 1

func _on_info_button_pressed():
	var info_panel_scene = preload ("res://GUI/info_panel/info_panel.tscn")
	var info_panel = info_panel_scene.instance()
	
	info_panel.specie_text = specie
	info_panel.gender_text = gender
	info_panel.pv_text = str (health, "/", health_max)
	info_panel.pv = health
	info_panel.pv_max = health_max
	info_panel.energy = energy
	info_panel.energy_max = energy_max
	info_panel.energy_text = str (energy, "/", energy_max)
	info_panel.name_text = creature_name
	info_panel.happiness = happiness
	info_panel.max_happiness = max_happiness
	info_panel.love_happiness = love_happiness
	info_panel.pregnancy = pregnant
	info_panel.id = id
	info_panel.evolution_1 = evolution_1
	info_panel.evolution_2 = evolution_2
	info_panel.evolution_3 = evolution_3
	info_panel.evolution_1_text = evolution_1_text	
	info_panel.evolution_2_text = evolution_2_text
	info_panel.evolution_3_text = evolution_3_text
	info_panel.cost_text_1 = cost_text_1
	info_panel.cost_text_2 = cost_text_2
	info_panel.cost_text_3 = cost_text_3
	info_panel.produce_1 = produce_1
	info_panel.produce_2 = produce_2
	info_panel.eat_1 = eat_1
	info_panel.eat_2 = eat_2
	info_panel.age = age

	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(info_panel)
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value,
		"gender" : gender,
		"opposite_gender" : opposite_gender,
		"health" : health,
		"energy" : energy,
		"creature_name" : creature_name,
		"creature_size" : creature_size,
		"pregnant" : pregnant,
		"healed" : healed,
		"poop_time" : poop_time,
		"pregnancy_time" : pregnancy_time,
		"sleep_time" : sleep_time,
		"food_eaten" :  food_eaten,
		"attack_cooldown_time" : attack_cooldown_time,
		"happiness" : happiness,
		"sleep_hour" : sleep_hour,
		"wake_hour" : wake_hour,
		"age" : age,
		"pet" : pet,
		"pet_time" : pet_time,
		"robot_seen" : robot_seen,
		"memory_of_robot" : memory_of_robot,
		"hungry" : hungry,
		"sleeping" : sleeping,
		"in_love" : in_love,
		"need_friend" : need_friend,
		"time_to_meet_friend" : time_to_meet_friend

	}
	return save
	
#func _draw():
#	for i in num_rays:
#		draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i] * look_ahead, Color(255, 255, 0), 5)
#		draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i]  * look_ahead * interest[i], Color(255, 0, 0), 5)
#		draw_line(Vector2(0,0), Vector2(0,0) + chosen_dir * look_ahead, Color(0, 255, 0), 5)
		
