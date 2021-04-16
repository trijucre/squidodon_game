extends TextureButton

var counter_created = false

onready var counter_text_1 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box1/animal_counter_text_1")
onready var counter_text_2 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box2/animal_counter_text_2")
onready var counter_text_3 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box3/animal_counter_text_3")
onready var counter_text_4 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box4/animal_counter_text_4")
onready var counter_text_5 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box5/animal_counter_text_5")
onready var counter_text_6 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box6/animal_counter_text_6")

onready var counter_picture_1 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box1/animal_counter_picture_1")
onready var counter_picture_2 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box2/animal_counter_picture_2")
onready var counter_picture_3 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box3/animal_counter_picture_3")
onready var counter_picture_4 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box4/animal_counter_picture_4")
onready var counter_picture_5 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box5/animal_counter_picture_5")
onready var counter_picture_6 = get_tree().root.get_node("Game/game_start/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box6/animal_counter_picture_6")

onready var texture = load("res://items_selected/ancistrus_item/ancistrus_item_texture.png")

signal instance_ancistrus

func _ready() :

	self.connect("instance_ancistrus", get_tree().root.get_node("Game/game_start"), "_on_ancistrus_item_pressed")


func _process(_delta):
	
	var mouse_position = get_global_mouse_position() 
	self.set_position(mouse_position + Vector2(-50, -50))
	
	if self.pressed == true :
		emit_signal("instance_ancistrus")
		
		if counter_created == false :
			create_counter()
			counter_created = true
			
		self.queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func create_counter() :
	if counter_text_1.item == null or counter_text_1.item == "ancistrus"  :
		counter_text_1.item = "ancistrus"
		
	elif counter_text_2.item == null or counter_text_2.item == "ancistrus"  :
		counter_text_2.item = "ancistrus"
		
	elif counter_text_3.item == null or counter_text_3.item == "ancistrus"  :
		counter_text_3.item = "ancistrus"
				
	elif counter_text_4.item == null or counter_text_4.item == "ancistrus"  :
		counter_text_4.item = "ancistrus"
		
	elif counter_text_5.item == null or counter_text_5.item == "ancistrus"  :
		counter_text_5.item = "ancistrus"
		
	elif counter_text_6.item == null or counter_text_6.item == "ancistrus"  :
		counter_text_6.item = "ancistrus"

