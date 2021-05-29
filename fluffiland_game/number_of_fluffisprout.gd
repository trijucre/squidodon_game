extends Label


var pearl_counter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_game_start_number_of_pearls(Game):
	self.text = str (Game.pearl_count)
