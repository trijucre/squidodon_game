extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal save_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.connect("save_pressed", get_tree().root.get_node("Game"), "_on_save_pressed")

func _on_save_button_test_a_effacer_pressed():
	emit_signal("save_pressed")
