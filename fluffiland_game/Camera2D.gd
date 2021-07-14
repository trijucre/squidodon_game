extends Camera2D

var spd = 500
var radius_required_to_move = 1000

export var x_move = 950
export var y_move = 500

func _ready():
	self.zoom.x += 0
	self.zoom.y += 0
	
func _physics_process(delta):
	
	var mouse_position = get_global_mouse_position()
	var mouse_delta = mouse_position - global_position
	if (mouse_delta.x >= x_move*self.zoom.x or mouse_delta.y >= y_move*self.zoom.x or mouse_delta.x <= -x_move*self.zoom.x or mouse_delta.y <= -y_move*self.zoom.x ) :
	#if (mouse_delta.length() >= (radius_required_to_move + 200 * self.zoom.x)) :
		position += (mouse_delta / (radius_required_to_move / (1+ self.zoom.x))) * spd * delta
	
	zoom()
	
func zoom():

		if Input.is_action_just_released("zoom on") and self.zoom.x < 5 and self.zoom.y < 3:
			self.zoom.x += 0.25
			self.zoom.y += 0.25
			
		if Input.is_action_just_released("zoom out") and self.zoom.x > 1 and self.zoom.y > 1:
			self.zoom.x -= 0.25
			self.zoom.y -= 0.25
