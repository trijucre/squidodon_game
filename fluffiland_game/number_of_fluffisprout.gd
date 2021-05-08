extends Label


var pearl_counter

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text =str(pearl_counter)


func _on_game_start_number_of_pearls(Game):
	pearl_counter = Game.pearl_count
