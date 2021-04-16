extends TextureButton

signal instance_coral_ocelot

func _ready() :

	self.connect("instance_berry_bush", get_tree().root.get_node("Game/game_start"), "_on_berry_bush_item_pressed")


func _process(delta):
	
	var mouse_position = get_global_mouse_position() 
	self.set_position(mouse_position + Vector2(-50, -50))
	
	if self.pressed == true :
		emit_signal("instance_berry_bush")
		self.queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
