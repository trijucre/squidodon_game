extends KinematicBody2D

signal aicarnivore_stats_changed
signal sand_catshark_birth
signal sand_catshark_death

# animation variables
var other_animation_playing = false

#animal state
var size = 1
var cost = 6
var resistance = 2
var health = 65
var health_max = 65
var energy = 70
var energy_max = 70
#variable pour l'energie mini à laquelle l'animal chasse
var hunger = 35
var target
var food_needed_birth = 20
var food_needed_birth_base = 20
var number_of_food_eaten = 0

#attack variables
var attack_cooldown_time = 200
var next_attack_time = 0
var attack_damage = 50

#variables death
export var spawn_area : Rect2 = Rect2(self.position.x, self.position.y, 50, 50)
onready var meat_scene = load("res://food/meat/Squid_meat/squid_meat.tscn")
export var meat_number = 3
var meat_count = 0
var dead = false

#variable childbirth
var child_scene = preload("res://entities/sand_catshark/sand_catshark_baby/sand_catshark_baby.tscn")

#variables poop
var food_eaten = false
onready var poop_scene = load("res://food/poop/medium_poop/poop.tscn")


export var speed = 35
export var walk_speed = 35
export var run_speed = 100
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0
var relative_direction

var rng = RandomNumberGenerator.new()





func _ready() :
	
	add_to_group("little_size", true)
	add_to_group("animal", true)
	add_to_group("predator", true)
	add_to_group("sand_catshark", true)
	
	self.connect("sand_catshark_birth", get_tree().root.get_node("Game"), "_on_sand_catshark_sand_catshark_birth")
	self.connect("sand_catshark_death", get_tree().root.get_node("Game"), "_on_sand_catshark_death")
	
	emit_signal("sand_catshark_birth")
	#set the energy and health bar to the right size
	emit_signal("aicarnivore_stats_changed", self)
	
	
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
	
	
			
	# the animal get another direction if blocked by another object than food
	if collision != null :#and not collision.collider.is_in_group("class_3") :
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
				

	if health <= 0 :
		#avoid bug with timer and movement, and emit a signal that can be used to count death.
		$Timer.stop()
		direction = Vector2.ZERO
		set_process(false)
		dead = true
		
		if meat_count < meat_number :
			produce_meat()

	if not other_animation_playing:
		animates_animal()
		
	if number_of_food_eaten >= food_needed_birth :
		childbirth()
		food_needed_birth += food_needed_birth_base
		

func hunt(target) :

	if energy > 0 :
		speed = run_speed
	if energy <= 0 :
		speed = walk_speed
	relative_direction = target.position - self.position
	direction = relative_direction.normalized()
	#attack if close enough
	
func attack(target) :
	speed = 0
	other_animation_playing = true
	var now = OS.get_ticks_msec()
	if now >= next_attack_time and target.health > 0 :
		var animation = "side_attack"
		$AnimatedSprite.play(animation)
		hit(target)
		next_attack_time = now + attack_cooldown_time
	
func hit(target) :
	
	other_animation_playing = true
	#var animation = get_animation_direction(last_direction) + "_hurt"
	var animation = "side_hurt"
	
	$AnimatedSprite.play(animation)
	if attack_damage <= target.resistance :
		target.new_health -= 1
		
	else :
		target.health -= target.health - (attack_damage - target.resistance)
		

func eat(target) :
	
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
		emit_signal("sand_catshark_death")


func produce_meat() :
	
	var meat = meat_scene.instance()
	get_tree().root.add_child(meat)
	
	
	meat.position.x = self.position.x + rng.randf_range(0, spawn_area.size.x)
	meat.position.y = self.position.y + rng.randf_range(0, spawn_area.size.y)
	meat_count += 1
						
	
func _on_Timer_timeout():
	
	rng.randomize()
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
	if  not body.is_in_group("sand_catshark") and body.is_in_group("animal") :
		if energy <= hunger :
			hunt(body)
			target = body
			
		
func _on_fare_vision_body_exited(_body):
	target = null
	
func _on_close_vision_body_entered(body):
	if  not body.is_in_group("sand_catshark") :
		if energy <= hunger :
			if body.is_in_group("animal"):
				attack(body)
				target = body
			
			if  body.is_in_group("meat") :
				eat(body)
				target = body
		
		if body.is_in_group("middle size") or body.is_in_group("big size") or body.is_in_group("titan size")   and body.is_in_group("predator"):
			flee()
			target = body
	
func _on_close_vision_body_exited(body):
	
	if body == null :
		target = null

	if  not body.is_in_group("sand_catshark") and body != null :
		if energy <= hunger :
			hunt(target)
			target = body
			





