extends "res://food/tree_produced_script_base.gd"


func _init():
	energy = 1
	health = 1
	happiness = 1
	specie = "medicine"
	type_1 = ""
	type_2 = ""
	
func _ready():
	add_to_group("medicine", true)


func _on_Timer_timeout():
	if in_box == false :
		eatable = true # Rep
