extends TextureButton

var environment_texture_unclicked = preload ("res://GUI/items_tree/vegetal_tree/button/tree_button/tree_unclicked.png")
var environment_texture_clicked = preload ("res://GUI/items_tree/vegetal_tree/button/tree_button/tree_clicked.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("environment_button")


	if get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter").animal_diversity > 0 :
		self.set_normal_texture(environment_texture_unclicked)
		self.set_pressed_texture(environment_texture_clicked)
		self.set_disabled_texture(environment_texture_clicked)
	
	else :
		self.set_disabled(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
