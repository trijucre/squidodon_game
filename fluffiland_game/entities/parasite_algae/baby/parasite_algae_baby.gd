extends StaticBody2D

signal algae_cut

var nutrient = 1
var save_value = "Persist_child"
var grow = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var adult_scene = preload ("res://entities/parasite_algae/parasite_algae_adult/parasite_algae.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_to_group("vegetals")
	add_to_group("parasite")
	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	
	self.connect("algae_cut", get_tree().root.get_node("Game/game_start"), "_on_algae_cut")

func _process(delta):
	if nutrient <= 0 :
		self.queue_free()

func _on_grow_timeout():
	

	grow += 1
	if grow >= 180 :
		var adult = adult_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(adult)
		adult.position.x = self.position.x
		adult.position.y = self.position.y
		
		self.queue_free()


func _on_TextureButton_pressed():
	
	if get_tree().root.get_node("Game/game_start").strength_count > 0 :
		emit_signal("algae_cut")
		self.queue_free()
	else :
		pass
	
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"grow" : grow
	}
	return save


