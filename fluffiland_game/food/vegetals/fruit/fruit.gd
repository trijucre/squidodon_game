extends StaticBody2D

var save_value = "Persist_child"

var cost = 1
var energy = 100
var health = 5
var specie = "clover"
var nutrient = 1

func _ready():
	add_to_group("clover", true)
	add_to_group("Persist", true)
	add_to_group("persist_child", true)

func _process(_delta):
	
	if energy <= 0 or health <= 0:
		get_tree().queue_delete(self)
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		
	}
	return save
