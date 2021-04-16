extends Control

var new_game_scene = preload("res://GUI/new_game_menu/new_game_menu.tscn")

func _on_continue_pressed():
	pass # Replace with function body.


func _on_new_game_pressed():
	var new_game = new_game_scene.instance()
	get_tree().root.get_node("Game").add_child(new_game)
	self.queue_free()
func _on_option_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	pass
