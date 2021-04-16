extends KinematicBody2D

signal aiherbivore_stats_changed
signal cuttledog_birth
signal cuttledog_death

#animation variables
var other_animation_playing = false

#animal state
var cost = 6
var resistance = 2
var health = 100
var health_max = 100
var energy = 100
var energy_max = 100
var hunger = 50

# attack, run and cooldown
var run_cooldown_time = 20
var run_duration = 10000
var next_run_time = 0

#variables death
export var spawn_area : Rect2 = Rect2(self.position.x, self.position.y, 50, 50)
onready var meat_scene = load("res://food/meat/Squid_meat/squid_meat.tscn")
export var meat_number = 2
var meat_count = 0
var dead = false

#variable childbirth
var child_scene = preload("res://entities/cuttledog/cuttledog_baby/cuttledog_baby.tscn")

#variables poop
var food_eaten = false
onready var poop_scene = load("res://food/poop/medium_poop/poop.tscn")


export var speed = 25
export var walk_speed = 25
export var run_speed = 200
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

var ennemy_position

var rng = RandomNumberGenerator.new()

var someone_is_here = false

export (int) var detect_radius

	

func _ready() :
	
	add_to_group("class_2", true)
	add_to_group("animal", true)
	add_to_group("cuttledog", true)
	
	self.connect("cuttledog_birth", get_tree().root.get_node("Game/game_start"), "_on_cuttledog_cuttledog_birth")
	self.connect("cuttledog_death", get_tree().root.get_node("Game/game_start"), "_on_cuttledog_cuttledog_death")
	
	emit_signal("cuttledog_birth")
	
	# emi to show health bar for test, delete this code after test
	emit_signal("aiherbivore_stats_changed", self)
	
	#class 3 : animaux de petite taille
	add_to_group("class_3")
	
	
	rng.randomize()
	
	
func animates_animal(direction) :
	
	if last_direction.x < 0 :
			$AnimatedSprite.scale.x = -1
			
	if last_direction.x >= 0 :
			$AnimatedSprite.scale.x = 1
	
	
	if direction != Vector2.ZERO:
		# Play walk animation
		last_direction = direction
		if speed == run_speed :	
			var animation = get_animation_direction(last_direction) + "_run"
			$AnimatedSprite.play(animation)
		if speed == walk_speed :
			var animation = get_animation_direction(last_direction) + "_walk"
			$AnimatedSprite.play(animation)
		
	else:
		# Play idle animation
		var animation = get_animation_direction(last_direction) + "_default"
		$AnimatedSprite.play(animation)


func get_animation_direction(_direction):
	#WIPanimation direction
	
	
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "front"
	elif norm_direction.y <= -0.707:
		return "back"
	elif norm_direction.x <= -0.707:
		return "side"
	elif norm_direction.x >= 0.707:
		return "side"
	return "front"
	
	#*********
	
	
func _physics_process(delta) :
	
	
	
	# set movement
	var movement = direction * speed * delta
	#set collision
	var collision = move_and_collide(movement)
	
	
	# the animal get another direction if blocked by another object than food
	if collision != null : #and not collision.collider.is_in_group("bush") :
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
	
	if someone_is_here :# and collision == null  :
		#run for its life if ennemy detected
		var run_direction = ennemy_position - self.position
		direction = - (run_direction * rng.randf() * PI/4).normalized()
		
		if energy > 0 :
			speed = run_speed
	else :
		speed = walk_speed
		#check if the rycast hit food in the bush group
		var target = $RayCast2D.get_collider()
		if bounce_countdown == 0:
			if target != null and target.is_in_group("bush") and energy < hunger  :
				# if food found, move toward it
				var relative_direction = target.position - self.position
				direction = relative_direction.normalized()
				
				if relative_direction.length() <= 100 :
					direction = Vector2.ZERO
					eat(target)
					# set food_eaten to true, so the animal can poop
					food_eaten = true 
					
		#raycast direction change when animal direction change.
		if direction != Vector2.ZERO:
			$RayCast2D.cast_to = direction.normalized() * 300
		
		$RayCast2D.force_raycast_update()
	
	if not other_animation_playing:
		animates_animal(direction)
		
	if health <= 0 :
		
		#avoid bug with timer and movement, and emit a signal that can be used to count death.
		$Timer.stop()
		direction = Vector2.ZERO
		set_process(false)
		dead = true
		
		if meat_count <= meat_number :
			produce_meat()
		

		
func hit(attack_damage) :
	
	var animation = get_animation_direction(last_direction) + "_hurt"
	$AnimatedSprite.play(animation)
	var new_health
	if attack_damage <= resistance :
		new_health = health - 1
		health = new_health
	else :
		new_health = health - (attack_damage - resistance)
		health = new_health
		
func eat(target) :
	
	var new_health = target.health + health
	health = new_health
	if health > health_max :
			health = health_max
	emit_signal("aiherbivore_stats_changed", self)
	
	var new_energy = target.energy + energy
	energy = new_energy
	if energy > energy_max :
			energy = energy_max
	emit_signal("aiherbivore_stats_changed", self)
	
	target.energy = 0
	target.health = 0
	
	

func _on_close_vision_body_entered(body):
	if body.is_in_group("class_5") or body.is_in_group("class_1"):
		someone_is_here = true
		ennemy_position = body.position
		
func _on_far_vision_body_exited(_body):
	if someone_is_here == true :
		someone_is_here = false

#func _on_AnimatedSprite_animation_finished():
	#if emit_signal ("herbivore_death") == true :
		#get_tree().queue_delete(self)

func produce_meat() :
	
	var meat = meat_scene.instance()
	get_tree().root.get_node("Game/YSort").add_child(meat)
	
	
	meat.position.x = self.position.x + rng.randf_range(0, spawn_area.size.x)
	meat.position.y = self.position.y + rng.randf_range(0, spawn_area.size.y)
	meat_count += 1
	
func _on_Timer_timeout():
	
	#add_to_group("class_3")
	rng.randomize()
		# animal moves randomly when timer goes to 0
	var random_number = rng.randf()
	if random_number < 0.05:
			direction = Vector2.ZERO
	elif random_number < 0.5:
		#change the numbers befor PI to change the randomness of direction
		if energy > 0 :
			direction = last_direction.rotated(rng.randf() * 2 * PI)
		if energy <= 0 :
			direction = last_direction.rotated(rng.randf()  * PI/4)
	
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
		
	if energy > 0 :
		var new_energy = energy - 1
		energy = new_energy
		emit_signal("aiherbivore_stats_changed", self)
		
	if energy <= 0 :
		var new_health = health - 1
		health = new_health
		emit_signal("aiherbivore_stats_changed", self)
	

func _on_AnimatedSprite_animation_finished():
	if dead == true :
		emit_signal("cuttledog_death")
		get_tree().queue_delete(self)
		


func _on_childbirth_timeout():
	var child = child_scene.instance()
	get_tree().root.get_node("Game/game_start/YSort").add_child(child)

	child.position.x = self.position.x 
	child.position.y = self.position.y 
	


func _on_poop_timeout():
	if food_eaten == true :
		var poop = poop_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(poop)

		poop.position.x = self.position.x - 50
		poop.position.y = self.position.y
		food_eaten = false
	else :
		pass
	
