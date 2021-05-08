extends TextureButton



var vegetal_texture_unclicked = preload ("res://GUI/items_tree/vegetal_tree/button/berry_bush_button/berry_bush_unclicked.png")
var vegetal_texture_clicked = preload ("res://GUI/items_tree/vegetal_tree/button/berry_bush_button/berry_bush_clicked.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vegetal_button")
	add_to_group("berry_bush")
	

	if get_tree().root.get_node("Game/game_start").diversity_level_1 > 0 :
		self.set_normal_texture(vegetal_texture_unclicked)
		self.set_pressed_texture(vegetal_texture_clicked)
		self.set_disabled_texture(vegetal_texture_clicked)
	
	else :
		self.set_disabled(true)

