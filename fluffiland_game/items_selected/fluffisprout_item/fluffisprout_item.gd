extends StaticBody2D

signal instance_fluffisprout
signal show_area
signal hide_area

onready var area_space = $fluffi_node_base/life_space
onready var life_area = $fluffi_node_base/life_space/life_area
onready var life_radius = life_area.shape.radius
onready var red_circle


var gender


func _ready() :

	red_circle = 0
	self.connect("instance_fluffisprout", get_tree().root.get_node("Game/game_start/"), "_on_fluffisprout_item_pressed")
	self.connect("show_area", get_tree().root.get_node("Game/game_start/areas"), "_on_show_areas")
	self.connect("hide_area", get_tree().root.get_node("Game/game_start/areas"), "_on_hide_areas")
	emit_signal("show_area")
	
	area_space.connect("area_entered", self, "_on_Area2D_area_entered")
	area_space.connect("area_exited", self, "_on_Area2D_area_exited")
	
func _process(_delta):

	var mouse_position = get_global_mouse_position() 
	self.set_position(mouse_position)
	
	#update()
	
func _on_TextureButton_pressed():
	
	if 	red_circle == 0 :
		emit_signal("instance_fluffisprout", gender)
		emit_signal("hide_area")
		self.queue_free()
	else : 
		pass
	

func _draw() :
	
	var center = Vector2(0,0)
	
	#var color
	if red_circle == 0:
		draw_circle(center, life_radius, Color(0,1, 0.5, 1))
		
	if red_circle > 0 :
		draw_circle(center, life_radius, Color(1, 0.5, 0))
		
func _on_Area2D_area_entered(area):
	print ("area detected")
	red_circle += 1
	update()

func _on_Area2D_area_exited(area):
	red_circle -= 1
	update()


