extends StaticBody2D

var water = 10
var strength = 10
var fuel = 0

var save_value = "Persist_child"

func _ready():
	add_to_group("meteor")
	add_to_group("Persist")
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value
	}
	return save
	
#func _draw():
