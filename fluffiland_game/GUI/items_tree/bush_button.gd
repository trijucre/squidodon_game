extends TextureButton

var masked = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vegetals_button")
	add_to_group ("bush")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
