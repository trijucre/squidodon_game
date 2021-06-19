extends Node2D

var save_value = "Persist_clock"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var season_duration = (0.0)
onready var year_wheel_rotation = $year_wheel_rotation
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Persist", true)
	add_to_group("Persist_clock", true)
	
	year_wheel_rotation.play("season_needle_rotation")
	year_wheel_rotation.seek(season_duration, true)

	
func save():
	var save = {
		"filename" : get_filename(),
		"pos_y" : get_position(),
		"season_duration" : year_wheel_rotation.get_current_animation_position()
	}
	return save
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
