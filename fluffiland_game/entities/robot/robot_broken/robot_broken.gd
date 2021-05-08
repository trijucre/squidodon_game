extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save_value = "Persist_child"
var infos = preload("res://GUI/info_robot/info_broken_robot/broken_robot_info.tscn")
var infos_position = Vector2(1200, 100)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("robot", true)
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)

func _on_TextureButton_pressed():
	print ("data robot")
	var infos_scene = infos.instance()
	get_tree().root.get_node("Game/game_start/CanvasLayer").add_child(infos_scene)
	infos_scene.position = infos_position

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position()
	}
	return save
