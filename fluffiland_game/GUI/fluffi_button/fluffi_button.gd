extends Node2D

signal fluffi_pressed

var save_value = "Persist_fluffi_button"

var gender = "male"
onready var button = $fluffi_sprite
var empty = false


func _ready():
	add_to_group("Persist", true)
	add_to_group("Persist_fluffi_button", true)
	
	self.connect("fluffi_pressed", get_tree().root.get_node("Game/game_start"), "_on_fluffi_pressed")

	if empty == true :
			button.set_disabled(true)
	
func _on_fluffi_sprite_pressed():
	emit_signal("fluffi_pressed", gender)
	button.set_disabled(true)
	empty = true

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
#		"pos_y" : get_position(),
		"empty" : empty,
		"save_value": save_value
	}
	return save
