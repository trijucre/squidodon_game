extends StaticBody2D


var save_value = "Persist_child"
var specie = "poop"

var health = 1
var quality = 2
var eatable = false 
var in_box = false

func _ready():
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	add_to_group("poop", true)

func _process(_delta):
	if health <= 0 :
		self.queue_free()
	
func _on_Timer_timeout():
	if in_box == false :
		eatable = true # Replace with function body.

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



