extends Label

func _on_game_start_day_number(Game):
	self.text = str(Game.day_count)
