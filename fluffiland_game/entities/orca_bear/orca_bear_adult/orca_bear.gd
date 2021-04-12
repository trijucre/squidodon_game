extends KinematicBody2D

#variables finite state machine
enum states {DEFAULT, HUNT, EAT, FLEE, ATTACK, DEAD}
var state = states.DEFAULT
var relative_direction


signal aicarnivore_stats_changed

# animation variables
var other_animation_playing = false

#animal state
var resistance = 10
var health = 300
var health_max = 300
var energy = 10
var energy_max = 100
#variable pour l'energie mini à laquelle l'animal chasse
var hunger = 25
var target
var food_needed_birth = 50
var food_needed_birth_base = 50
var number_of_food_eaten = 0

#attack variables
var attack_cooldown_time = 2000
var next_attack_time = 0
var attack_damage = 15

#variables death
export var spawn_area : Rect2 = Rect2(self.position.x, self.position.y, 50, 50)
onready var meat_scene = load("res://food/meat/Squid_meat/squid_meat.tscn")
export var meat_number = 3
var meat_count = 0
var dead = false

#variable childbirth
var child_scene = preload("res://entities/orca_bear/orca_bear_baby/orca_bear_baby.tscn")

#variables poop
var food_eaten = false
onready var poop_scene = load("res://food/poop/medium_poop/poop.tscn")


export var speed = 40
export var walk_speed = 40
export var run_speed = 80
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0


var rng = RandomNumberGenerator.new()





func _ready() :
	
	add_to_group("class_5", true)
	add_to_group("animal", true)
	add_to_group("predator", true)
	add_to_group("orca_bear", true)
	
	self.connect("orca_bear_birth", get_tree().root.get_node("Game"), "_on_orca_bear_orca_bear_birth")
	self.connect("orca_bear_death", get_tree().root.get_node("Game"), "_orca_bear_orca_bear_death")
	
	emit_signal("orca_bear_birth")
	#set the energy and health bar to the right size
	emit_signal("aicarnivore_stats_changed", self)
	
	
	
	#class 3 : animaux de petite taille
	rng.randomize()

func animates_animal() :
	
	if last_direction.x < 0 :
			$AnimatedSprite.scale.x = -1
			
	if last_direction.x >= 0 :
			$AnimatedSprite.scale.x = 1
	
	if direction != Vector2.ZERO:
		# Play walk animation
		last_direction = direction
		$AnimatedSprite.play("side_walk")
		
	if speed == run_speed :	
		$AnimatedSprite.play("side_run")
		
	else:

		$AnimatedSprite.play("side_default")
		
	
func _physics_process(delta) :

	# set movement
	var movement = direction * speed * delta
	#set collision
	var collision = move_and_collide(movement)
	
	match state :
		
		states.DEFAULT :
			
			print ("defaultorca")
			# the animal get another direction if blocked by another object than food
			if collision != null :#and not collision.collider.is_in_group("class_3") :
				direction = direction.rotated(rng.randf_range(PI/4, PI/2))
				bounce_countdown = rng.randi_range(2, 5)
				
		states.ATTACK :
			
			attack()
			print ("attack")
			
		states.FLEE :
			flee()
			
		states.EAT :
			
			eat()
			print ("eat")
			
		states.HUNT :
			
			speed = run_speed
			hunt()
			print ("hunt")
		
		states.DEAD :
			#avoid bug with timer and movement, and emit a signal that can be used to count death.
			$Timer.stop()
			direction = Vector2.ZERO
			set_process(false)
			dead = true
		
			if meat_count < meat_number :
				produce_meat()
	
	if energy <= 0 :
		$fare_vision.set_collision_mask_bit ( 0, 1 )

	if not other_animation_playing:
		animates_animal()
		
	if number_of_food_eaten >= food_needed_birth :
		childbirth()
		food_needed_birth += food_needed_birth_base

		
	if health <= 0 :
		state = states.DEAD
		

func hunt() :

	if energy > 0 :
		speed = run_speed
	if energy <= 0 :
		speed = walk_speed
	relative_direction = target.position - self.position
	direction = relative_direction.normalized()
	#attack if close enough
	
func attack() :
	speed = 0
	other_animation_playing = true
	var now = OS.get_ticks_msec()
	if now >= next_attack_time and target.health > 0 :
		var animation = "side_attack"
		$AnimatedSprite.play(animation)
		target.hit(attack_damage) 
		print ("frappé")
		next_attack_time = now + attack_cooldown_time
	
func hit(attack_damage) :
	
	other_animation_playing = true
	#var animation = get_animation_direction(last_direction) + "_hurt"
	var animation = "side_hurt"
	print ("ouille")
	$AnimatedSprite.play(animation)
	var new_health
	if attack_damage <= resistance :
		new_health = health - 1
		health = new_health
		emit_signal("aicarnivore_stats_changed", self)
	else :
		new_health = health - (attack_damage - resistance)
		health = new_health
		emit_signal("aicarnivore_stats_changed", self)
		

func eat() :
	
	speed = 0
	other_animation_playing = true
	var animation = "side_attack"
	$AnimatedSprite.play(animation)
	
	var new_health = target.health + health
	health = new_health
	if health > health_max :
			health = health_max
	emit_signal("aicarnivore_stats_changed", self)
	
	var new_energy = target.energy + energy
	energy = new_energy
	if energy > energy_max :
			energy = energy_max
	emit_signal("aicarnivore_stats_changed", self)
	
	target.energy = 0
	target.health = 0
	
	food_eaten = true
	number_of_food_eaten += 1
	
func flee() :
	if energy > 0 :
		speed = run_speed
		
	relative_direction = target.position - self.position
	direction = -relative_direction.normalized()
	
#detect when a body enter to start running
func _on_AnimatedSprite_animation_finished():
	other_animation_playing = false
	
	if dead == true :
		get_tree().queue_delete(self)
		emit_signal("orca_bear_death")


func produce_meat() :
	
	var meat = meat_scene.instance()
	get_tree().root.add_child(meat)
	
	
	meat.position.x = self.position.x + rng.randf_range(0, spawn_area.size.x)
	meat.position.y = self.position.y + rng.randf_range(0, spawn_area.size.y)
	meat_count += 1
						
	
func _on_Timer_timeout():
	
	rng.randomize()
	print ("timer_ok")
	speed = walk_speed
		# animal moves randomly when timer goes to 0
	var random_number = rng.randf()
	if random_number < 0.05:
			direction = Vector2.ZERO
			#rise the number to have th ai change direction more frequently
	elif random_number < 0.5:
		if energy > 0 :
		#change the numbers befor PI to change the randomness of direction
			direction = last_direction.rotated(rng.randf() * 2 * PI)
			
		if energy <= 0 :
			direction = last_direction.rotated(rng.randf()  * PI/6)
	
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
		
	if energy > 0 :
		var new_energy = energy - 1
		energy = new_energy
		emit_signal("aicarnivore_stats_changed", self)
		
	if energy <= 0 :
		var new_health = health - 1
		health = new_health
		emit_signal("aicarnivore_stats_changed", self)
	
	


func childbirth():
	
	var child = child_scene.instance()
	get_tree().root.get_node("Game/YSort").add_child(child)

	child.position.x = self.position.x 
	child.position.y = self.position.y 
	


func _on_poop_timeout():
	
	if food_eaten == true :
		var poop = poop_scene.instance()
		get_tree().root.get_node("Game/YSort").add_child(poop)

		poop.position.x = self.position.x - 50
		poop.position.y = self.position.y
		food_eaten = false


func _on_fare_vision_body_entered(body):
	if  not body.is_in_group("orca_bear") :
		if energy <= hunger :
			state = states.HUNT
			target = body
		
func _on_fare_vision_body_exited(_body):
	state = states.DEFAULT
	target = null
	
func _on_close_vision_body_entered(body):
	if  not body.is_in_group("orca_bear") :
		if energy <= hunger :
			state = states.ATTACK
			target = body
	
func _on_close_vision_body_exited(_body):
	#if energy <= hunger :
		#state = states.HUNT
		#target = body
	#else :
	state = states.DEFAULT
	target = null

func _on_close_smell_body_entered(body):
	if  not body.is_in_group("orca_bear") :
		if energy <= hunger :
			state = states.EAT
			target = body


func _on_close_smell_body_exited(_body):
	state = states.DEFAULT
	
	
func _on_flee_area_tiny_body_entered(body):
	if not body.is_in_group("orca_bear") and body.is_in_group("predator"):
		state = states.DEFAULT
		target = body

func _on_flee_area_body_exited(_body):
	state = states.DEFAULT


