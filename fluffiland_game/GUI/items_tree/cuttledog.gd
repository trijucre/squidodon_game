extends TextureButton

signal unmasked

var animal_texture_unclicked = preload("res://GUI/items_tree/animal_tree/button/cuttledog/cuttledog_uncliked.png")
var animal_texture_clicked = preload("res://GUI/items_tree/animal_tree/button/cuttledog/cuttledog_clicked.png")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("animals_button")
	add_to_group("cuttledog")
	
func _process(_delta):
	if get_tree().root.get_node("Game/CanvasLayer/animal_counter").animal_diversity >= 3 :

		self.set_normal_texture(animal_texture_clicked)
		self.set_normal_texture(animal_texture_unclicked)
		self.set_disabled_texture(animal_texture_clicked)
		emit_signal("unmasked")
	
	if self.pressed :
		self.set_disabled(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
