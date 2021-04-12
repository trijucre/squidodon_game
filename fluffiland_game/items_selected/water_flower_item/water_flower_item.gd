extends StaticBody2D

signal instance_water_flower

onready var area = $Area2D

func _ready() :

	self.connect("instance_water_flower", get_tree().root.get_node("Game"), "_on_water_flower_item_pressed")
	

func _process(delta):
	var mouse_position = get_global_mouse_position() 
	self.set_position(mouse_position)

func _on_TextureButton_pressed():
	if area.get_overlapping_areas() == []:
		emit_signal("instance_water_flower")
		self.queue_free()
	else : 
		pass
	print ("button_clicked")
