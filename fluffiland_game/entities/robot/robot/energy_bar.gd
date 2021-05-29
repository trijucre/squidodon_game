extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var energy
var energy_bit_value = 5
var bar_size = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	if energy == null :
		energy = 20
	self.rect_size.x = float(energy) * energy_bit_value * bar_size
	
func _on_robot_stat_changed(value):
		energy = value
		self.rect_size.x = float(energy) * energy_bit_value * bar_size
