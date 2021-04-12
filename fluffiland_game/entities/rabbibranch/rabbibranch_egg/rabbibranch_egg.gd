extends KinematicBody2D


var child_scene = preload("res://entities/rabbibranch/rabbibranch_baby/rabbibranch_baby.tscn")# Declare member variables here. Examples:


func _ready():
	pass # Replace with function body.
 

func _on_hatching_timeout():
	
	var child = child_scene.instance()
	get_tree().root.get_node("Game/YSort").add_child(child)
	
	child.position.x = self.position.x
	child.position.y = self.position.y
		
	self.queue_free()
