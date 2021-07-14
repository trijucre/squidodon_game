extends StaticBody2D

var save_value = "Persist_child"

var energy = 0
var health = 0
var id
var happiness = 0
var specie 
var type_1 
var type_2 
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
	if type_2 != null :
		add_to_group(type_2, true)
	add_to_group("vegetals", true)
	add_to_group("produced",true)
	
	if id != null :
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
		"save_value" : save_value,
		"orientation_choice" : orientation_choice
	}
	return save




