extends TextureButton

var animal_texture_unclicked = preload ("res://GUI/items_tree/animal_tree/button/catshark_button/catshark_button_unclicked.png")
var animal_texture_clicked = preload ("res://GUI/items_tree/animal_tree/button/catshark_button/catshark_button_clicked.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("animals_button")
	add_to_group("ancistrus")
	
	if get_tree().root.get_node("Game/game_start").diversity_level_1 > 0 :
		self.set_normal_texture(animal_texture_unclicked)
		self.set_pressed_texture(animal_texture_clicked)
		self.set_disabled_texture(animal_texture_clicked)
	
	else :
		self.set_disabled(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
