extends StaticBody2D

var save_value = "Persist_child"

var quality = 3
var health = 1
var eatable = false
var in_box = false
var specie = "fertilizer"

func _ready():
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	add_to_group("fertilizer", true)
	add_to_group("poop", true)


	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value,
		"eatable" : eatable

	}
	return save

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if in_box == false :
		eatable = true # Rep
