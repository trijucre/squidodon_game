extends KinematicBody2D

var save_value = "Persist_child"

var energy = 1
var health = 1
var id
var happiness = 1
var specie = "bush"
var eatable = true 

func _ready():
	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	
	add_to_group("bush", true)
	add_to_group("vegetals", true)
	add_to_group("produced",true)
	
	add_to_group(id)
	
	
	#emit_signal("bush_produced")
		
func _process(_delta):
	
	if energy <= 0 and health <= 0 :
		get_tree().queue_delete(self)
		#emit_signal("bush_deleted")

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"id" : id,
		"save_value" : save_value
	}
	return save
