extends Node2D

var show_areas = false

func _on_show_areas():
	show_areas = true
	update()

func _on_hide_areas():
	show_areas = false
	update()
	
func _draw() :
	if show_areas == true :
		for node in  get_tree().get_nodes_in_group ("vegetals") :
			var center = node.position
			var radius = node.area_radius
			var color = Color(0.3, 0.5, 0.8)
			draw_circle(center, radius, color)

