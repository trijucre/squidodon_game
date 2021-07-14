extends Node2D

signal move_pressed
signal hug_pressed
signal take_pressed
signal recolt_pressed
signal refill_pressed
signal depose_pressed
signal water_pressed
signal cook_pressed
signal short_move_pressed
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var node

onready var move_button = $move
onready var hug_button = $hug
onready var take_button = $take
onready var recolt_button = $recolt
onready var refill_button = $refill
onready var depose_button = $depose
onready var water_button = $water
onready var cook_button = $cook

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var type = (get_node("../../").type)
	var container = (get_node("../../").container)
	var energy = (get_node("../../").energy)
	
	if type == "take" :
		hug_button.queue_free()
		cook_button.queue_free()
		
		if container == null :
			water_button.queue_free()
			recolt_button.queue_free()
			refill_button.queue_free()
			depose_button.queue_free()
		
		elif container != null :
			take_button.queue_free()

			if container == "water" :
				print ("container robot = water")
				recolt_button.queue_free()
				refill_button.queue_free()
				depose_button.queue_free()
				
			else :
				water_button.queue_free()
				
			if energy <= 0 :
				depose_button.queue_free()
				recolt_button.queue_free()
			

		
	elif type == "cook" :
		var spot_1_empty = (get_node("../../").spot_1_empty)
		var spot_2_empty = (get_node("../../").spot_2_empty)
		var spot_3_empty = (get_node("../../").spot_3_empty)
		
		water_button.queue_free()
		recolt_button.queue_free()
		refill_button.queue_free()
		hug_button.queue_free()
		
		if (spot_1_empty == true and spot_2_empty == true and spot_3_empty == true ) :
			cook_button.queue_free()
		
		elif spot_1_empty != true and spot_2_empty != true and spot_3_empty != true :
			take_button.queue_free()
			
		if container != null :
			cook_button.queue_free()
			take_button.queue_free()
		
		elif container == null :
			depose_button.queue_free()

		
	elif type == "hug" :
		take_button.queue_free()
		recolt_button.queue_free()
		refill_button.queue_free()
		depose_button.queue_free()
		water_button.queue_free()
		cook_button.queue_free()
		
		if energy <= 0 :
			hug_button.queue_free()
	
	
	for node in get_tree().get_nodes_in_group("robot_action") :
		node.queue_free()
		
	
	self.connect("move_pressed", get_node("../../"), "_on_move_pressed")
	self.connect("short_move_pressed", get_node("../../"), "_on_short_move_pressed")
	self.connect("hug_pressed", get_node("../../"), "_on_hug_pressed")
	self.connect("take_pressed", get_node("../../"), "_on_take_pressed")
	self.connect("recolt_pressed", get_node("../../"), "_on_recolt_pressed")
	self.connect("refill_pressed", get_node("../../"), "_on_refill_pressed")
	self.connect("depose_pressed", get_node("../../"), "_on_depose_pressed")
	self.connect("water_pressed", get_node("../../"), "_on_water_pressed")	
	self.connect("cook_pressed", get_node("../../"), "_on_cook_pressed")	
	add_to_group("robot_action")
	

func _process(_delta):

	self.position = get_node("../../").get_global_transform_with_canvas().origin#node.get_global_transform_with_canvas().origin
	
	if Input.is_action_pressed("right_click"):
		emit_signal ("short_move_pressed")
		self.queue_free()
	
func _on_move_pressed():
	emit_signal("move_pressed")
	self.queue_free()

func _on_hug_pressed():
	emit_signal("hug_pressed")
	self.queue_free()

func _on_take_pressed():
	emit_signal("take_pressed")
	self.queue_free()

func _on_recolt_pressed():
	emit_signal("recolt_pressed")
	self.queue_free()

func _on_refill_pressed():
	emit_signal("refill_pressed")
	self.queue_free()

func _on_depose_pressed():
	emit_signal("depose_pressed")
	self.queue_free()
	
func _on_water_pressed():
	emit_signal("water_pressed")
	self.queue_free() 

func _on_cook_pressed():
	emit_signal("cook_pressed")
	self.queue_free() 

func _on_quit_pressed():
	self.queue_free()






