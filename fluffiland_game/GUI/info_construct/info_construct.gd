extends Node2D

signal water_spend
signal strength_spend
signal strength_earned
signal water_earned
signal fluffisprout_created
signal energize

var ressource_given_count_max = 0
var ressource_obtained_count_max = 0
var ressource_given_count = 0
var ressource_obtained_count = 0

var id
var ressource_given
var ressource_transferred

var energize_cost = 100
#var ressource_obtained

onready var obtained_sprite = $background/obtained_sprite
onready var given_sprite = $background/given_sprite
onready var energize_sprite = $background_3/energize_ressource

onready var obtained_text = $background/ressource_obtained_number
onready var given_text = $background/ressource_given_number

onready var fluffisprout_cost_text = $background_2/fluffisprout_cost
var fluffisprout_cost

onready var water_texture = preload ("res://GUI/water_logo.png")
onready var strength_texture = preload ("res://GUI/strength_logo.png")

func _ready():
	
	for node in get_tree().get_nodes_in_group("info_panel") :
		node.queue_free()
	
	self.connect("water_spend", get_tree().root.get_node("Game/game_start"), "_on_water_spend")
	self.connect("strength_spend", get_tree().root.get_node("Game/game_start"), "_on_strength_spend")
	self.connect("water_earned", get_tree().root.get_node("Game/game_start"), "_on_water_earned")
	self.connect("strength_earned", get_tree().root.get_node("Game/game_start"), "_on_strength_earned")
	
	self.connect("fluffisprout_created", get_tree().root.get_node("Game/game_start"), "_on_fluffisprout_created")
	self.connect("energize", get_tree().root.get_node("Game/game_start"), "_on_construct_energized")
		
	add_to_group("info_panel")
	
	ressource_given_count = ressource_given_count_max
	
	if ressource_given == "water" :
		given_sprite.set_texture(water_texture)
		obtained_sprite.set_texture(strength_texture)
		energize_sprite.set_texture(water_texture)
	
	elif ressource_given == "strength" :
		given_sprite.set_texture(strength_texture)
		obtained_sprite.set_texture(water_texture)
		energize_sprite.set_texture(water_texture)
		
	given_text.text = str(ressource_given_count)
	obtained_text.text = "0"
	
	fluffisprout_cost = 10 + 10 * get_tree().get_nodes_in_group("creature").size()
	fluffisprout_cost_text.text = str(fluffisprout_cost)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_retire_button_pressed():
	if ressource_given_count > 0 :
		ressource_given_count -= 1
		given_text.text = str(ressource_given_count)
		
func _on_add_button_pressed():
	if ressource_given_count < ressource_given_count_max :
		ressource_given_count += 1
		given_text.text = str(ressource_given_count)

func _on_transform_button_pressed():
	if	ressource_transferred == false :
		ressource_obtained_count = ressource_given_count
		ressource_given_count = 0
		ressource_given_count_max = 0
		given_text.text = str(ressource_given_count)
		obtained_text.text = str(ressource_obtained_count)
		if ressource_given == "water" :
			emit_signal("water_spend", ressource_obtained_count)
			emit_signal("strength_earned", ressource_obtained_count)
		
		elif ressource_given == "strength" :
			emit_signal("strength_spend", ressource_obtained_count)
			emit_signal("water_earned", ressource_obtained_count)
			
		ressource_transferred = true
		for node in get_tree().get_nodes_in_group(id) :
			node.ressource_transferred = true
		
	else : pass

func _on_close_button_pressed():
	self.queue_free()


func _on_create_fluffisprout_pressed():
	emit_signal("fluffisprout_created", 1, fluffisprout_cost )

func _on_energize_pressed():
	if ressource_given == "water" :
		emit_signal("energize", "water", energize_cost)
	elif ressource_given == "strength" :
		emit_signal("energize", "strength", energize_cost)
	for node in get_tree().get_nodes_in_group(id) :
		node.queue_free()
	self.queue_free()
	
