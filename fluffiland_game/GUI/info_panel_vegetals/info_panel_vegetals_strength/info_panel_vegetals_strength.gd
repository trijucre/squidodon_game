extends Node2D

var specie_text 
var pv 
var pv_max
var id

signal tree_energized

onready var specie_name = $info_panel_text/specie_name
onready var health_bar = $health_bar

onready var health_full = load ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/strength_bar_7.png")
onready var health_6 = load ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/strength_bar_6.png")
onready var health_5 = load ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/strength_bar_5.png")
onready var health_4 = load ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/strength_bar_4.png")
onready var health_3 = load ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/strength_bar_3.png")
onready var health_2 = load ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/strength_bar_2.png")
onready var health_1 = load ("res://GUI/info_panel_vegetals/info_panel_vegetals_strength/strength_bar_1.png")

var health_visual 
# Called when the node enters the scene tree for the first time.
func _ready():

	for node in get_tree().get_nodes_in_group("info_panel") :
		node.queue_free()
	
	add_to_group("info_panel")
	
	self.position = Vector2(1635, 325)
	
	self.connect("tree_energized", get_tree().root.get_node("Game"), "_on_tree_energized")
	
	health_visual = ( float (pv)/ float (pv_max) )

	if health_visual >= 0.86 :
			health_bar.set_texture(health_full)
			
	elif health_visual >= 0.72 :
			health_bar.set_texture(health_6)
			
	elif health_visual >= 0.58 :
			health_bar.set_texture(health_5)
		
	elif health_visual >= 0.44 :
			health_bar.set_texture(health_4)
			
	elif health_visual >= 0.30 :
			health_bar.set_texture(health_3)
		
	elif health_visual >= 0.16 :
			health_bar.set_texture(health_2)
		
	elif health_visual > 0 :
			health_bar.set_texture(health_1)
		
	else :
			health_bar.set_texture(null)
		
	specie_name.text = str (specie_text)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_water_button_pressed():
	if health_bar.texture != health_full and get_tree().root.get_node("Game").water_count > 0 :
		for node in get_tree().get_nodes_in_group("tree") :
			if node.tree_id == self.id :
					
				emit_signal("tree_energized")

				node.health = node.health_max

				health_bar.set_texture(health_full)
			else :
				pass
	else :
		pass

func _on_close_button_pressed():
	self.queue_free()
