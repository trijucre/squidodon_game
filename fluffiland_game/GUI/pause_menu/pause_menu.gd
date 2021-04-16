extends Control


#onready var title_scene = preload("res://GUI/start_game/start_game.tscn")
signal quit_to_title

func _ready():
	self.connect("quit_to_title", get_tree().root.get_node("Game"), "_on_quit_to_title_screen")
	get_tree().paused = true

func _on_return_pressed():
	
	get_tree().paused = false
	self.queue_free()

func _on_quit_pressed():


	#var title = title_scene.instance()
	
	get_tree().paused = false
	get_tree().root.get_node("Game/game_start").queue_free()
	emit_signal("quit_to_title")
	#get_tree().root.get_node("Game").add_child(title)
	self.queue_free()

	

	

