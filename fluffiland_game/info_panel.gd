extends Node2D


onready var info_name = $info_panel_text/VBoxContainer/name
onready var info_pregnant = $info_panel_text/VBoxContainer/pregnant
onready var age_text = $info_panel_text/VBoxContainer/age
onready var produce_text = $info_panel_text/VBoxContainer/produce
onready var id
onready var evolution_panel_scene = preload("res://GUI/evolution_panel/evolution_panel.tscn")
onready var happiness_text = $info_panel_text/VBoxContainer/happy


onready var energy_container = $info_panel_text/VBoxContainer/stats_container/energy_container
onready var happiness_container = $info_panel_text/VBoxContainer/stats_container/happiness_container
onready var health_container = $info_panel_text/VBoxContainer/stats_container/pv_container


onready var eat_1
onready var eat_2
onready var produce_1
onready var produce_2

#onready var evolution_1
#onready var evolution_2
#onready var evolution_3
#onready var evolution_1_text
#onready var evolution_2_text
#onready var evolution_3_text
#onready var cost_text_1 
#onready var cost_text_2 
#onready var cost_text_3

var name_text 
var specie_text 
var pv 
var pv_max
var energy
var energy_max
var gender_text 
var pregnancy
var age
var happiness
var max_happiness

onready var stat_bit_scene = preload ("res://GUI/info_panel/stat_bit.tscn")
onready var stat_bit_empty_scene = preload ("res://GUI/info_panel/stat_bit_empty.tscn")




# Called when the node enters the scene tree for the first time.
func _ready():
	
	for node in get_tree().get_nodes_in_group("info_panel") :
		node.queue_free()
		
	add_to_group("info_panel")
	self.position = get_global_mouse_position()
	info_name.bbcode_text = "Name : " + str(name_text) + "\nSpecie : " + str(specie_text) + "\nGender : " + str(gender_text) + "\nAge :" + str(age) + " days old"
	if gender_text == "female" and pregnancy == true :
			info_pregnant.text = "pregnant"
	else :
		info_pregnant.queue_free()
	
	if eat_1 == null :
		age_text.text =	"eat nothing"
	elif eat_2 == null :
		age_text.text = "eat " + str(eat_1) 
	else :
		age_text.text = "eat " + str(eat_1) +" and " + str(eat_2)

	if produce_1 == null :
		produce_text.text = "doesn't produce anything"
	elif produce_2 == null :
		produce_text.text = "produce " + str(produce_1) 
	else :
		produce_text.text = "produce " + str(produce_1) + "and" + str(produce_2)

	for number in energy :
		add_bit(energy_container)
	
	for number in pv :
		add_bit(health_container)
		
	var lost_energy = energy_max - energy

	for number in lost_energy :
		add_bit_empty(energy_container)
	
	var lost_pv = pv_max - pv
	for number in lost_pv :
		add_bit_empty(health_container)

	var relative_happines = float(happiness) / float(max_happiness)

	if relative_happines >= 0.8 :
		happiness_text.text = str(name + " is very happy !")
	
	elif relative_happines >= 0.5 :
		happiness_text.text = str(name + " is quite happy .")
		
	elif  relative_happines >= 0.25 :
		happiness_text.text = str(name + " feels okay")
	
	else :
		happiness_text.text = str(name + " isn't really happy")

func _on_close_button_pressed():
	
	self.queue_free()

func add_bit(container):
	var stat_bit = stat_bit_scene.instance()
	container.add_child(stat_bit)

func add_bit_empty(container):
	var stat_bit_empty = stat_bit_empty_scene.instance()
	container.add_child(stat_bit_empty)
	
#func _on_evolution_button_pressed():
#	var evolution_panel = evolution_panel_scene.instance()
#	evolution_panel.id = id
#	evolution_panel.evolution_1 = evolution_1
#	evolution_panel.evolution_2 = evolution_2
#	evolution_panel.evolution_3 = evolution_3
#	evolution_panel.evolution_1_text = evolution_1_text
#	evolution_panel.evolution_2_text = evolution_2_text
#	evolution_panel.evolution_3_text = evolution_3_text	
##	evolution_panel.cost_text_2 = cost_text_2
#	evolution_panel.cost_text_3 = cost_text_3
		
#	get_tree().root.get_node("Game//game_start/CanvasLayer").add_child(evolution_panel)
#	evolution_panel.position = self.position
	
	#evolution_panel.position.y = self.position.y 
