extends KinematicBody2D

var save_value = "Persist_child"
var child_scene = preload("res://entities/cuttledog/cuttledog_baby/cuttledog_baby.tscn")# Declare member variables here. Examples:
var hatching_time = 0
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	add_to_group("egg", true)
	
	
func _on_hatching_timeout():
	hatching_time += 1
	if hatching_time >= 320 :
		var child = child_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(child)
		
		child.position.x = self.position.x
		child.position.y = self.position.y
			
		self.queue_free()

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"hatching_time" : hatching_time
	}
	return save
#func _draw():
	#for in num_ray
