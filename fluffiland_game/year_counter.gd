extends Label


func _on_game_start_year(Game):
	self.text = str(Game.year)
