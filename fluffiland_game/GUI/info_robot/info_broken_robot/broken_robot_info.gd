extends Node2D

signal robot_repaired
signal strength_spend

var reparation_cost = 30
onready var text_cost = $cost/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("robot_repaired", get_tree().root.get_node("Game/game_start"), "_on_robot_repaired")
	self.connect("strength_spend", get_tree().root.get_node("Game/game_start"), "_on_strength_spend")
	
	text_cost.text = str(reparation_cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_TextureButton_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count >= reparation_cost :
		emit_signal("robot_repaired")
		emit_signal("strength_spend", reparation_cost)
		self.queue_free()
	else :
		print ("not enough money to repare the robot")


func _on_close_button_pressed():
	self.queue_free()
