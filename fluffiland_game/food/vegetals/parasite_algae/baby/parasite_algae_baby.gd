extends StaticBody2D

signal algae_cut

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var adult_scene = preload ("res://food/vegetals/parasite_algae/parasite_algae.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_to_group("vegetals")
	add_to_group("parasite")
	
	self.connect("algae_cut", get_tree().root.get_node("Game"), "_on_algae_cut")


func _on_grow_timeout():
	
	var adult = adult_scene.instance()
	
	get_tree().root.get_node("Game/YSort").add_child(adult)
	adult.position.x = self.position.x
	adult.position.y = self.position.y
	
	self.queue_free()


func _on_TextureButton_pressed():
	if get_tree().root.get_node("Game").strength_count > 0 :
		emit_signal("algae_cut")
		self.queue_free()
	else :
		pass

