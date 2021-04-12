extends KinematicBody2D

var cost = 1
var energy = 100
var health = 5
var id

func _ready():
	add_to_group("bush", true)
	add_to_group("vegetals", true)
	add_to_group(id)
	
	#emit_signal("bush_produced")
		
func _process(_delta):
	
	if energy <= 0 or health <= 0:
		get_tree().queue_delete(self)
		#emit_signal("bush_deleted")
