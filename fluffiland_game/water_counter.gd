extends Label


func _on_game_start_number_of_water(Game):
		self.text = str(Game.water_count)
