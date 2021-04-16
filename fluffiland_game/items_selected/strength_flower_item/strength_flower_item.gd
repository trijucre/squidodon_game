extends StaticBody2D

signal instance_strength_flower

signal show_area
signal hide_area

onready var radius = $Area2D/CollisionShape2D.shape.radius
onready var red_circle
onready var circle_area = $Area2D


func _ready() :
	red_circle = 0
	self.connect("instance_strength_flower", get_tree().root.get_node("Game/game_start"), "_on_strength_flower_item_pressed")
	self.connect("show_area", get_tree().root.get_node("Game/game_start/areas"), "_on_show_areas")
	self.connect("hide_area", get_tree().root.get_node("Game/game_start/areas"), "_on_hide_areas")
	emit_signal("show_area")

func _process(_delta):
	var mouse_position = get_global_mouse_position() 
	self.set_position(mouse_position)

func _on_TextureButton_pressed():
	if 	red_circle == 0 :
		emit_signal("instance_strength_flower")
		emit_signal("hide_area")
		self.queue_free()
	else : 
		pass
	print ("button_clicked")

func _draw() :
	
	var center = Vector2(0,0)
	
	#var color
	if red_circle == 0:
		draw_circle(center, radius, Color(0,1, 0.5, 1))
		
	if red_circle > 0 :
		draw_circle(center, radius, Color(0.9, 0.1, 0.0))


func _on_Area2D_area_entered(area):
	red_circle += 1
	update()

func _on_Area2D_area_exited(area):
	red_circle -= 1
	update()
