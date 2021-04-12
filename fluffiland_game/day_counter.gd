extends Label
	
func _on_Game_day_number(Game):
	self.text = str(Game.day_count)
	
