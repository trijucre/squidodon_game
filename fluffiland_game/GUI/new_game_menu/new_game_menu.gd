extends CanvasLayer

onready var game_scene = preload("res://game_start.tscn")

func _on_new_game_create_pressed():
	var game = game_scene.instance()
	
	get_tree().root.get_node("Game").add_child(game)
	self.queue_free()
