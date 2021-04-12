extends Label

func _on_Game_number_of_strength(Game):
	self.text = str(Game.strength_count)
