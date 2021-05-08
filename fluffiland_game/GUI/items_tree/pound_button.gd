extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var environment_texture_unclicked = preload ("res://GUI/items_tree/environment_tree/environment_tree_buttons/pond/pond_unclicked.png")
var environment_texture_clicked = preload ("res://GUI/items_tree/environment_tree/environment_tree_buttons/pond/pond_clicked.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("environment_button")


	if get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter").animal_diversity >= 1 :
		self.set_normal_texture(environment_texture_unclicked)
		self.set_pressed_texture(environment_texture_clicked)
		self.set_disabled_texture(environment_texture_clicked)
	
	else :
		self.set_disabled(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
