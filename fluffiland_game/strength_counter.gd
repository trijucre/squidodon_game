extends Label

func _on_game_start_number_of_strength(Game):
		self.text = str(Game.strength_count)
