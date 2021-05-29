extends KinematicBody2D

var save_value = "Persist_child"

var cost = 1
var energy = 100
var health = 5
var id
var nutrient = 1
var happiness = 1

var specie = "bush"

func _ready():
	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	
	add_to_group("bush", true)
	add_to_group("vegetals", true)
	add_to_group(id)
	
	
	#emit_signal("bush_produced")
		
func _process(_delta):
	
	if energy <= 0 or health <= 0 or nutrient <= 0:
		get_tree().queue_delete(self)
		#emit_signal("bush_deleted")

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"nutrient" : nutrient,
		"id" : id
	}
	return save
