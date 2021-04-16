extends KinematicBody2D

var child_scene = preload("res://entities/ancistrus/ancistrus_baby/ancistrus_baby.tscn")# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_hatching_timeout():
	
	var child = child_scene.instance()
	get_tree().root.get_node("Game/game_start/YSort").add_child(child)
	
	child.position.x = self.position.x
	child.position.y = self.position.y
		
	self.queue_free()
