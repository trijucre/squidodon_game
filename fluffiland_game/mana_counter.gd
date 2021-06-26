extends Label

func _on_game_start_number_of_mana(Game):
		self.text = str(Game.mana_count)
