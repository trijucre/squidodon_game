extends Control

signal mana_spend
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var price
var robot_scene
onready var label = $price
onready var camera =  get_tree().root.get_node("Game/game_start/Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(price)

	self.connect("mana_spend",get_tree().root.get_node("Game/game_start"), "_on_mana_spend")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_sprite_pressed():
	var mana = get_tree().root.get_node("Game/game_start").mana_count
	var number_of_robots = get_tree().root.get_node("Game/game_start/CanvasLayer/robot_button_node/GridContainer").get_child_count()
	print ("robot item mana : ",mana)
	if mana >= price and number_of_robots < 6 :
		emit_signal("mana_spend", price)
		import_robot()
	elif mana <= price :
		print ("not enough mana to buy robot")
	elif number_of_robots >= 6 :
		print ("too many robots on map")

func import_robot():
	var robot = robot_scene.instance()
	get_tree().root.get_node("Game/game_start/YSort").add_child(robot)
	robot.position = camera.position
