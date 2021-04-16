extends TextureButton

signal unmasked

var animal_texture_unclicked = preload("res://GUI/items_tree/animal_tree/button/coral_ocelot/coral_ocelot_unclicked.png")
var animal_texture_clicked = preload("res://GUI/items_tree/animal_tree/button/coral_ocelot/coral_ocelot_clicked.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("animals_button")
	add_to_group("coral_ocelot")
func _process(_delta):
	
	if get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter").animal_diversity >= 3 :

		self.set_normal_texture(animal_texture_clicked)
		self.set_normal_texture(animal_texture_unclicked)
		self.set_disabled_texture(animal_texture_clicked)
		
		emit_signal("unmasked")

