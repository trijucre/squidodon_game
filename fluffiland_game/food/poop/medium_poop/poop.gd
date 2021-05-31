extends StaticBody2D


var save_value = "Persist_child"

var energy =1
var health = 1
var quality = 1

func _ready():
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	add_to_group("poop")

func _process(_delta):
	if health <= 0 :
		self.queue_free()
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),

	}
	return save
