extends TextureButton

signal instance_big_tree

func _ready() :

	self.connect("instance_big_tree", get_tree().root.get_node("Game/game_start"), "_on_big_tree_item_pressed")


func _process(delta):
	
	var mouse_position = get_viewport().get_mouse_position()
	self.set_position(mouse_position)
	
	if self.pressed == true :
		emit_signal("instance_big_tree")
		self.queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
