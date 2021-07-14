extends Control

signal destroy_robot
signal go_to_robot

var id
var type
var robot_nodepath

onready var button = $button
onready var energy_bar = $energy_bar

# var a = 2
# var b = "text"
onready var sprite_hug = preload ("res://GUI/user_interface/robot_button/sprites/robot_button_hug_logo.png")
onready var sprite_take = preload ("res://GUI/user_interface/robot_button/sprites/robot_button_take_logo.png")
onready var sprite_cook = preload ("res://GUI/user_interface/robot_button/sprites/robot_button_cook_logo.png")
# Called when the node enters the scene tree for the first time.
func _ready():

	self.connect("destroy_robot", get_tree().root.get_node(robot_nodepath), "_on_destroy_robot_pressed")
	self.connect("go_to_robot", get_tree().root.get_node(robot_nodepath), "_on_go_to_robot_pressed")
	
	if type == "hug" :
		button.set_normal_texture(sprite_hug)
	elif type == "take" :
		button.set_normal_texture(sprite_take)
	elif type == "cook" :
		button.set_normal_texture(sprite_cook)
	
func _on_stats_changed(energy, energy_max):
	energy_bar.set_value(float(energy*33))
	print ("energy bar value :", 	energy_bar.get_value())
	

func _on_close_button_pressed():
	emit_signal("destroy_robot")
	self.queue_free()

func _on_button_pressed():
	print ("robot selected")
	emit_signal("go_to_robot")
