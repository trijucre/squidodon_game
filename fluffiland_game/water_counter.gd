extends Label



func _on_Game_number_of_water(Game):
	self.text = str(Game.water_count)
	
