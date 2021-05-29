extends Node2D

var save_value = "Persist_clock"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var season_duration = (0.0)
onready var season_animation = $season_needle_rotation
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Persist", true)
	add_to_group("Persist_clock", true)
	
	season_animation.play("season_needle_rotation")
	season_animation.seek(season_duration, true)
	print(season_animation.get_current_animation_position())
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"season_duration" : season_animation.get_current_animation_position()



	}
	return save
	print (season_animation.get_current_animation_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
