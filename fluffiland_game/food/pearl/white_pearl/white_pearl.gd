extends KinematicBody2D

signal pearl_earned

func _ready():
	self.connect("pearl_earned", get_tree().root.get_node("Game/game_start"), "_on_pearl_earned")

func _on_TextureButton_pressed():
	
	emit_signal("pearl_earned")
	self.queue_free()
