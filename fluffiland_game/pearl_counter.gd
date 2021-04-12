extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pearl_counter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Game_number_of_pearls(Game):
	pearl_counter = Game.pearl_count
	
func _physics_process(_delta):
	self.text =str(pearl_counter )
