extends KinematicBody2D

var speed = 25


var save_value = "Persist_child"
var gender = "none"
var health = 1
var energy = 1
var resistance = 0

var dead = false

var ennemy_position
var someone_is_here = false
var rng = RandomNumberGenerator.new()

export var spawn_area : Rect2 = Rect2(self.position.x, self.position.y, 50, 50)
export var meat_scene = preload("res://food/meat/Squid_meat/squid_meat.tscn")
export var meat_number = 1
var meat_count = 0

var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

var adulthood = 0

func _ready() :
	
	add_to_group("fluffilus")
	add_to_group("baby")
	
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	
	rng.randomize()
	
func animates_animal(direction) :
	
	if last_direction.x < 0 :
			$AnimatedSprite.scale.x = -1
			
	if last_direction.x >= 0 :
			$AnimatedSprite.scale.x = 1
	
	
	if direction != Vector2.ZERO:
		# Play walk animation
		last_direction = direction
		$AnimatedSprite.play("side_walk")
		
	else:
		# Play idle animation
		$AnimatedSprite.play("animationside_default")

	

func _process(delta):
	
	var movement = direction * speed * delta
	#set collision
	var collision = move_and_collide(movement)
	
	
	# the animal get another direction if blocked by another object than food
	if collision != null : #and not collision.collider.is_in_group("bush") :
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
	
	elif someone_is_here :
		#run for its life if ennemy detected
		var run_direction = ennemy_position - self.position
		direction = - (run_direction * rng.randf() * 2 * PI).normalized()
	
	if health <= 0 :
		
		#avoid bug with timer and movement, and emit a signal that can be used to count death.
		$Timer.stop()
		direction = Vector2.ZERO
		set_process(false)
		dead = true
		get_tree().queue_delete(self)
		
		if meat_count <= meat_number :
			produce_meat()
		
	#if dead == true :
		

func hit(attack_damage) :
	
	$AnimatedSprite.play("side_hurt")
	var new_health
	if attack_damage <= resistance :
		new_health = health - 1
		health = new_health
	else :
		new_health = health - (attack_damage - resistance)
		health = new_health

func produce_meat() :
	
	var meat = meat_scene.instance()
	get_tree().root.get_node("Game/game_start/YSort").add_child(meat)
	
	
	meat.position.x = self.position.x + rng.randf_range(0, spawn_area.size.x)
	meat.position.y = self.position.y + rng.randf_range(0, spawn_area.size.y)
	var new_meat_count = meat_count + 1
	meat_count = new_meat_count



func _on_Timer_timeout():
		#add_to_group("class_3")
	rng.randomize()
		# animal moves randomly when timer goes to 0
	var random_number = rng.randf()
	if random_number < 0.05:
			direction = Vector2.ZERO
	elif random_number < 0.5:
		#change the numbers befor PI to change the randomness of direction
			direction = last_direction.rotated(rng.randf() * 2 * PI)
	
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
	
	adulthood += 1
	if adulthood >= 420 :
		adulthood_time()


func _on_AnimatedSprite_animation_finished():
	#$Timer.stop()
	#direction = Vector2.ZERO
	#set_process(false)
	#get_tree().queue_delete(self)
	pass

func adulthood_time():
		
	
	var adult_scene = load("res://entities/fluffilus/fluffilus_adult/fluffilus.tscn")
	var adult = adult_scene.instance()
	get_tree().root.get_node("Game/game_start/YSort").add_child(adult)

	adult.position.x = self.position.x 
	adult.position.y = self.position.y 
	
	$Timer.stop()
	direction = Vector2.ZERO
	set_process(false)
	get_tree().queue_delete(self)
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"adulthood" : adulthood

	}
	return save
