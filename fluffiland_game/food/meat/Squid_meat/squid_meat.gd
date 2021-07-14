extends StaticBody2D

var save_value = "Persist_child"

var energy = 10
var health = 10
var quality = 10
var happiness = 10
var specie = "squid_meat"
var type_1 = "meat"

var eatable = true
var in_box = false

onready var sprite = $Sprite
var orientation_choice

func _ready():
	if orientation_choice == null :
		orientation_choice = randi()% 100 + 1
	if orientation_choice > 50 :
		sprite.scale.x = -1
		
	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	
	add_to_group(specie, true)
	add_to_group(type_1, true)
	add_to_group("meat", true)
	add_to_group("produced",true)
	
	
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
		"save_value" : save_value,
		"orientation_choice" : orientation_choice
	}
	return save




