extends StaticBody2D

signal instance_tree
signal show_area
signal hide_area

onready var area = $Area2D

func _ready() :

	self.connect("instance_tree", get_tree().root.get_node("Game"), "_on_tree_item_pressed")
	self.connect("show_area", get_tree().root.get_node("Game/areas"), "_on_show_areas")
	self.connect("hide_area", get_tree().root.get_node("Game/areas"), "_on_hide_areas")
	emit_signal("show_area")
	
func _process(delta):
	var mouse_position = get_global_mouse_position() 
	self.set_position(mouse_position)

func _on_TextureButton_pressed():
	if area.get_overlapping_areas() == []:
		emit_signal("instance_tree")
		emit_signal("hide_area")
		self.queue_free()
	else : 
		pass
	print ("button_clicked")
