extends TextureButton




# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal load_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.connect("load_pressed", get_tree().root.get_node("Game"), "_on_load_pressed")


func _on_load_button_test_a_effacer2_pressed():
	emit_signal("load_pressed")
