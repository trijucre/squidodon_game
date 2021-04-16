extends Node2D

var start_screen = preload("res://GUI/start_game/start_game.tscn") 

func _ready():
	var start = start_screen.instance()
	
	self.add_child(start)
	
func _on_quit_to_title_screen():
	var start = start_screen.instance()
	
	self.add_child(start)
