extends KinematicBody2D

signal ai_stats_changed
signal fluffilus_birth
signal fluffilus_death
signal gender

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
var predator = []
var something_interresting = []
var friend = []
var obstacle_detected = []

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
var random_noun
var random_adjective
var creature_name 
#animal state
var specie = "fluffilus"
var gender 
var opposite_gender
var pregnant = false
var size = 1
var cost = 3
var resistance = 2
var health = 65
var health_max = 65
var energy = 70
var energy_max = 70
var attack_distance = 50
var sleeping = false

#hunger
var hunger = 35

#meat produced variable (produce meat whaen dying
var meat_produced = false

#variable to know if the creature is wounded, the variable healed will change during the time until it rechaes 10
#It means then that hurt = false.
var hurt = false
var healed = 0
# happiness
var happiness = 500
var max_happiness = 1000
var relative_happiness = float(happiness)/float(max_happiness)
var love_happiness = 0.8
#attack variables
var attack_cooldown_time = 200
var next_attack_time = 0
var attack_damage = 50

#variables death
export var spawn_area : Rect2 = Rect2(self.position.x, self.position.y, 50, 50)
onready var meat_scene = load("res://food/meat/Squid_meat/squid_meat.tscn")
onready var pregnancy = $pregnancy
export var meat_number = 1
var dead = false

#variable childbirth
var egg_scene = preload("res://entities/fluffilus/fluffilus_egg/fluffilus_egg.tscn")
var egg_number = 1

#variables poop
var food_eaten = false
onready var poop_scene = load("res://food/poop/medium_poop/poop.tscn")

#variable popup
var love_bubble = preload("res://popup/love_bubble.tscn")
var hunger_bubble = preload("res://popup/hunger_bubble.tscn")
var happy_bubble = preload("res://popup/happy_bubble.tscn")
var surprise_bubble = preload("res://popup/surprise_bubble.tscn")
var sleep_bubble = preload("res://popup/sleep_bubble.tscn")
onready var popup_position = Vector2(0, -200)
# var for bubble per second
var alert = 0
var sleep_time = 0
# when the aniaml goes to sleep, random, it's set in the _ready function
var sleep_hour

var directionX 
var directionY 
var movement

var time = 0

var love_here = false
var obstacle_here = false
var danger_here = false
var something_here = false
var predator_here = false
var friend_here = false

var food_found = false

var creature_size_choose = randi()% 100 + 1
var creature_size

func _ready():
	

	randomize()
	#size of the creature
	if creature_size_choose < 23 :
		creature_size = 0.9

	elif creature_size_choose >= 76 :
		creature_size = 1.2
	
	else :
		creature_size = 1
		
	$CollisionShape2D.scale = Vector2(creature_size, creature_size)
	$AnimatedSprite.scale = Vector2(creature_size, creature_size)
	
	#when creature goes to sleep
	sleep_hour = 0.7 + (randf() * 0.2 + 0.05)
	
	#name of the creature
	random_noun = str(get_random_word_from_file("res://other/nounlist.txt"))
	random_adjective = get_random_word_from_file("res://other/adjectiveslist.txt")
	creature_name = str(random_adjective," ", random_noun)
	
	var gender_choice = randi()%100 + 1
	if gender_choice > 33 :
		gender = "female"
		opposite_gender = "male"
	else :
		gender = "male"
		opposite_gender = "female"

	emit_signal("gender",self)
	
	add_to_group("animal", true)
	add_to_group(specie, true)
	
	self.connect("fluffilus_birth", get_tree().root.get_node("Game"), "_on_fluffilus_fluffilus_birth")
	self.connect("fluffilus_death", get_tree().root.get_node("Game"), "_on_fluffilus_fluffilus_death")
	
	
	
	emit_signal("fluffilus_birth")
	
	# emi to show health bar for test, delete this code after test
	emit_signal("ai_stats_changed", self)
	
	
	
	rng.randomize()
	rng.randomize()
	rngx.randomize()
	rngy.randomize()
	
	directionY = 0
	directionX = 0

	
	love.resize(num_rays)
	interest.resize(num_rays)
	danger.resize(num_rays)
	friend.resize(num_rays)
	predator.resize(num_rays)
	something_interresting.resize(num_rays)
	ray_directions.resize(num_rays)
	obstacle_detected.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
		interest[i] = 0.0
		danger [i] = 0.0
		predator[i] = 0.0
		love[i] = 0.0
		friend[i]= 0.0

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


	if 1 in love :
		love_here = true
	else :
		love_here = false
	
	if 1 in obstacle_detected :
		obstacle_here = false

	if 1 in predator :
		predator_here = true
		max_speed = run_speed
	else :
		predator_here = false
		max_speed = speed
	
	if 1 in danger :
		danger_here = true
	else :
		danger_here = false
		
	if 1 in something_interresting :
		something_here = true
	else :
		something_here = false
		
	if 1 in friend :
		friend_here = true
	else :
		friend_here = false
		
	if change_direction_counter <= 20 :
		change_direction_counter += 1
	
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	velocity = velocity.linear_interpolate(desired_velocity, steer_force)
	rotation = 0
	
	movement = velocity * delta
	
	#set collision
	collision = move_and_collide(movement)
	
	var sleep = get_tree().root.get_node("Game/daylight").get_color().r
	

	if sleep < sleep_hour  and hurt == false :
		set_sleep()
		sleeping = true
		
	elif not other_animation_playing :
		animates_animal()
		set_interest()
		choose_direction()
		sleeping = false
	
	else :
		movement = 0
		max_speed = 0
		chosen_dir = Vector2.ZERO
	
	if health <= 0 :
		death()

func set_interest():

	var space_state = get_world_2d().direct_space_state
	
	for i in num_rays:
		
		var result = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead, [self])
		
		if result :
			
			var relative_position = result["collider"].position - self.position
			var target = result["collider"]
			var distance = relative_position.length()

			if target.is_in_group("predator") and target.size >= self.size :
				
				if predator_here == false :
					var surprise_popup = surprise_bubble.instance()
					self.add_child(surprise_popup)
					surprise_popup.position = popup_position
					
				predator[i] = 1.0
				danger[i] = 10 + 2 * ((look_ahead+100 - distance)/(look_ahead+100))
				

			elif self.relative_happiness >= love_happiness and self.pregnant == false and energy > 0 and target.is_in_group(specie) and not target.is_in_group("baby") and target.gender == opposite_gender and target.pregnant == false and target.relative_happiness >= target.love_happiness :

				interest[i] = 1.0 + 5.0 * ((look_ahead+100 - distance)/(look_ahead+100))
				love[i] = 1.0
				
				if distance <= (attack_distance * 3) :
					
					if self.gender == "male" :
						mate(target)
					love[i] = 0.0
					

			elif energy < hunger and target.is_in_group("clover") and not predator_here and not love_here :
					
				interest[i] = 0.1 + (randi()*1.0 + 0.1 + 2.0) * ((look_ahead+100 - distance)/(look_ahead+100))
				something_interresting[i] = 1.0
				if distance < attack_distance :
					eat(target)
					something_interresting[i] = 0.0
					
			#herd movement, for herbivores, increase reproduction chances
			#elif target.is_in_group(specie) and not something_here and not love_here and not predator_here   :
				#interest[i] = 0.1 + ((look_ahead+100 - distance)/(look_ahead+100))
				#friend[i] = 1.0
				#if distance < attack_distance*2 :
				#	interest[i] = 0.0
				#	friend[i] = 0.0
			else :
				interest[i] = 0.0
				predator[i] = 0.0
				danger[i] = 0.0
				something_interresting[i] = 0.0
				love[i] = 0.0
				friend[i] = 0.0

		else :
			predator[i] = 0.0
			interest[i] = 0.0
			danger[i] = 0.0
			something_interresting[i] = 0.0
			love[i] = 0.0
			friend[i] = 0.0

		
	if not something_here and not love_here and not predator_here and not friend_here :
		
		set_default_interest()
		

			
			

func set_default_interest():
	# Default to moving forward
	var last_directionX = directionX
	var last_directionY = directionY

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
			
			if random_movement <= 30 :
				directionX = 0
				directionY = 0
				
			elif random_movement <= 50 :
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
	var love_popup = love_bubble.instance()
	self.add_child(love_popup)
	love_popup.position = popup_position
	
	if target.pregnant == false :
		target.pregnant = true
		target.pregnancy_true()
	
	happiness += 100
		

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
	
	happiness += 10



func produce_meat() :
	
	for i in meat_number :
		var meat = meat_scene.instance()
		get_tree().root.add_child(meat)

		meat.position.x = self.position.x + rng.randf_range(0, spawn_area.size.x)
		meat.position.y = self.position.y + rng.randf_range(0, spawn_area.size.y)

func pregnancy_true() :
	var love_popup = love_bubble.instance()
	self.add_child(love_popup)
	
	love_popup.position = popup_position
	
	emit_signal("gender",self)
	pregnancy.start()

func _on_pregnancy_timeout():
	for i in egg_number :
		
		var egg = egg_scene.instance()
		get_tree().root.get_node("Game/YSort").add_child(egg)
		
		if sprite_direction == "right" :
			egg.position.x = self.position.x - 50
			egg.position.y = self.position.y + randi () % -50 + 50
			
		if sprite_direction == "left" :
			egg.position.x = self.position.x + 50
			egg.position.y = self.position.y + randi () % -50 + 50

		pregnant = false
		emit_signal("gender",self) 

func _on_poop_timeout():
	if food_eaten == true :
		var poop = poop_scene.instance()
		get_tree().root.get_node("Game/YSort").add_child(poop)
		
		if sprite_direction == "right" :
			poop.position.x = self.position.x - 70
			poop.position.y = self.position.y - 15
		
		if sprite_direction == "left" :
				poop.position.x = self.position.x + 70
				poop.position.y = self.position.y - 15
		food_eaten = false
	else :
		pass

func death():
	$poop.stop()
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
	
	if sleeping == false :
		if energy > 0 :
			energy -= 1
		else : 
			health -= 1
	else :
		pass	

	
	#happiness per second :
	if energy > hunger :
		happiness += 1
		
	elif energy <= 0 :
		happiness -= 1
	
	elif energy < hunger :
		happiness += 0
	
	relative_happiness = float(happiness)/float(max_happiness)
	
	if happiness >= max_happiness :
		happiness = max_happiness
		
	emit_signal("ai_stats_changed", self)
	
		#var alert for surprise
	if alert < 4 :
		alert += 1

	
	if energy <= 0 and alert >= 4:
		var hunger_popup = hunger_bubble.instance()
		self.add_child(hunger_popup)
		hunger_popup.position = popup_position
		
		alert = 0
		
		#var for sleep
	if sleep_time < 2 :
		sleep_time += 1
	
	if sleeping == true and sleep_time >= 2 :
		var sleep_popup = sleep_bubble.instance()
		self.add_child(sleep_popup)
		sleep_popup.position = popup_position
		
		sleep_time = 0
		
	if hurt == true and healed < 10 :
		happiness -= 5
		healed += 1
	
	if hurt == true and healed >= 10 :
		healed = 0
		hurt = false
	


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
	info_panel.mood = relative_happiness
	info_panel.love_happiness = love_happiness
	info_panel.pregnancy = pregnant
	
	get_tree().root.get_node("Game/CanvasLayer").add_child(info_panel)
	

#func _draw():
	#for i in num_rays:
		#draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i] * look_ahead, Color(255, 255, 0), 5)
	#	draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i]  * look_ahead * interest[i], Color(255, 0, 0), 5)
		#draw_line(Vector2(0,0), Vector2(0,0) + chosen_dir * look_ahead, Color(0, 255, 0), 5)
		
