extends Node2D

signal evolution_selected

onready var id
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var evolution_text_1 = $VBoxContainer/evolution_1_bg/evolution_1_container/evolution_1
onready var evolution_text_2 = $VBoxContainer/evolution_2_bg/evolution_2_container/evolution_2
onready var evolution_text_3 = $VBoxContainer/evolution_3_bg/evolution_3_container/evolution_3

onready var evolution_cost_1 = $VBoxContainer/evolution_1_bg/evolution_1_container/cost_bg/cost
onready var evolution_cost_2 = $VBoxContainer/evolution_2_bg/evolution_2_container/cost2_bg/cost
onready var evolution_cost_3 = $VBoxContainer/evolution_3_bg/evolution_3_container/cost3_bg/cost

onready var evolution_1
onready var evolution_2
onready var evolution_3

onready var evolution_1_text
onready var evolution_2_text
onready var evolution_3_text

onready var cost_text_1
onready var cost_text_2
onready var cost_text_3

# Called when the node enters the scene tree for the first time.
func _ready():
	print ("evolution panel here")
	self.position = Vector2(0, 0)
	for node in get_tree().get_nodes_in_group("evolution_panel") :
		node.queue_free()
		
	add_to_group("evolution_panel")
	
	if evolution_1 == "null" :
		$text/button/buy_1.set_disabled(true)
	
	if evolution_2 == "null" :
		$text/button/buy_2.set_disabled(true)

	if evolution_3 == "null" :
		$text/button/buy_3.set_disabled(true)
		
	self.connect("evolution_selected", get_tree().root.get_node("Game/game_start"), "_on_evolution_selected")

	evolution_text_1.text = evolution_1_text
	evolution_text_2.text = evolution_2_text
	evolution_text_3.text = evolution_3_text
	
	evolution_cost_1.text = str(cost_text_1)
	evolution_cost_2.text = str(cost_text_2)
	evolution_cost_3.text = str(cost_text_3)
	print ("evolution_panel_here !")


func _on_TextureButton_pressed():
	self.queue_free()


func _on_buy_1_pressed():
	emit_signal("evolution_selected", evolution_1, id, cost_text_1)
	self.queue_free()

func _on_buy_2_pressed():
	emit_signal("evolution_selected", evolution_2, id, cost_text_2)
	self.queue_free()

func _on_buy_3_pressed():	
	emit_signal("evolution_selected", evolution_3, id, cost_text_3)
	self.queue_free()
