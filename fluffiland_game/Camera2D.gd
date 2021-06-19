extends Camera2D

var fixed_toggle_point = Vector2(0,0)


func _ready():
	self.zoom.x += 0
	self.zoom.y += 0
func _physics_process(_delta):

	# This happens once 'move_map' is pressed
	if Input.is_action_just_pressed('left_click_mouse'):
		var ref = get_viewport().get_mouse_position()
		fixed_toggle_point = ref
	# This happens while 'move_map' is pressed
	if Input.is_action_pressed('left_click_mouse'):
		slide_map_around()
	
	zoom()
	
func zoom():

		if Input.is_action_just_released("zoom on") and self.zoom.x < 3 and self.zoom.y < 3:
			self.zoom.x += 1
			self.zoom.y += 1
			
		if Input.is_action_just_released("zoom out") and self.zoom.x > 1 and self.zoom.y > 1:
			self.zoom.x -= 1
			self.zoom.y -= 1




# slides the map around
func slide_map_around():
	var ref = get_viewport().get_mouse_position()
	self.global_position.x += (ref.x - fixed_toggle_point.x) / 20
	self.global_position.y += (ref.y - fixed_toggle_point.y) / 20
