extends KinematicBody2D

var speed = 25

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


func _ready() :
	
	add_to_group("class_3")
	add_to_group("fluffilus")
	
	rng.randomize()
	
func animates_animal(direction) :
	
	if last_direction.x < 0 :
			$AnimatedSprite.scale.x = -1
			
	if last_direction.x >= 0 :
			$AnimatedSprite.scale.x = 1
	
	
	if direction != Vector2.ZERO:
		# Play walk animation
		last_direction = direction
		var animation = get_animation_direction(last_direction) + "_walk"
		$AnimatedSprite.play(animation)
		
	else:
		# Play idle animation
		var animation = get_animation_direction(last_direction) + "_default"
		$AnimatedSprite.play(animation)


func get_animation_direction(direction):
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
	
	var animation = get_animation_direction(last_direction) + "_hurt"
	$AnimatedSprite.play(animation)
	var new_health
	if attack_damage <= resistance :
		new_health = health - 1
		health = new_health
	else :
		new_health = health - (attack_damage - resistance)
		health = new_health

func produce_meat() :
	
	var meat = meat_scene.instance()
	get_tree().root.add_child(meat)
	
	
	meat.position.x = self.position.x + rng.randf_range(0, spawn_area.size.x)
	meat.position.y = self.position.y + rng.randf_range(0, spawn_area.size.y)
	var new_meat_count = meat_count + 1
	meat_count = new_meat_count

func _on_close_vision_body_entered(body):
	if body.is_in_group("class_5") or body.is_in_group("class_1"):
		someone_is_here = true
		ennemy_position = body.position


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
	
	


func _on_AnimatedSprite_animation_finished():
	#$Timer.stop()
	#direction = Vector2.ZERO
	#set_process(false)
	#get_tree().queue_delete(self)
	pass

func _on_Adulthood_timeout():
		
	
	var adult_scene = load("res://entities/fluffilus/fluffilus_adult/fluffilus.tscn")
	var adult = adult_scene.instance()
	get_tree().root.get_node("Game/YSort").add_child(adult)

	adult.position.x = self.position.x 
	adult.position.y = self.position.y 
	
	$Timer.stop()
	direction = Vector2.ZERO
	set_process(false)
	get_tree().queue_delete(self)
