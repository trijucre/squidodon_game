extends TextureButton


#signal unmasked
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var vegetal_texture_unclicked = preload ("res://GUI/items_tree/vegetal_tree/button/pearl_flower/pearl_flower_clicked.png")
#var vegetal_texture_clicked = preload ("res://GUI/items_tree/vegetal_tree/button/pearl_flower/pearl_flower_unclicked.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vegetal_button")
	add_to_group("pearl_flower")
	
#func _process(delta):
#	if get_tree().root.get_node("Game/CanvasLayer/animal_counter").animal_diversity >= 0 :
#		self.set_normal_texture(vegetal_texture_unclicked)
#		self.set_pressed_texture(vegetal_texture_clicked)
#		self.set_disabled_texture(vegetal_texture_clicked)
		
#		emit_signal("unmasked")
