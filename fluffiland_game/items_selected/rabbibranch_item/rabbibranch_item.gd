extends TextureButton

var counter_created = false
onready var counter_text_1 = get_tree().root.get_node("Game/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box1/animal_counter_text_1")
onready var counter_text_2 = get_tree().root.get_node("Game/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box2/animal_counter_text_2")

signal instance_rabbibranch

func _ready() :

	self.connect("instance_rabbibranch", get_tree().root.get_node("Game"), "_on_rabbibranch_item_pressed")
	
 

func _process(_delta):
	
	var mouse_position = get_global_mouse_position() 
	self.set_position(mouse_position + Vector2(-50, -50))
	
	if self.pressed == true :
		emit_signal("instance_rabbibranch")
		
		if counter_created == false :
			create_counter()
			counter_created = true
			
		self.queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func create_counter() :
	if counter_text_1.item == null or counter_text_1.item == "rabbibranch"  :
		counter_text_1.item = "rabbibranch"
	elif counter_text_2.item == null or counter_text_2.item == "rabbibranch"  :
		counter_text_2.item = "rabbibranch"
