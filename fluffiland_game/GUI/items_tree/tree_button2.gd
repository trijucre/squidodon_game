extends TextureButton


signal unmasked
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vegetal_texture_unclicked = preload ("res://GUI/items_tree/vegetal_tree/button/big_tree_button/big_tree_unclicked.png")
var vegetal_texture_clicked = preload ("res://GUI/items_tree/vegetal_tree/button/big_tree_button/big_tree_clicked.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vegetal_button")
	add_to_group("big_tree")
	
func _process(delta):
	if get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter").animal_diversity >= 4 :
		self.set_normal_texture(vegetal_texture_unclicked)
		self.set_pressed_texture(vegetal_texture_clicked)
		self.set_disabled_texture(vegetal_texture_clicked)
		
		emit_signal("unmasked")
