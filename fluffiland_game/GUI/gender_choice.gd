extends Node2D
signal gender_choice
var gender

func _ready():
	self.connect("gender_choice", get_tree().root.get_node("Game/game_start/"), "_on_gender_choice")

func _on_male_button_pressed():
	emit_signal("gender_choice", "male")
	self.queue_free()


func _on_female_button_pressed():
	emit_signal("gender_choice", "female")
	self.queue_free()
