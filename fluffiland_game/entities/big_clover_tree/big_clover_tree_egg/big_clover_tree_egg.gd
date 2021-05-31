extends StaticBody2D


var save_value = "Persist_child"

onready var life_area = $life_space/life_area
onready var area_radius = $Area2D/area.shape.radius
onready var baby_scene = preload ("res://entities/big_clover_tree/big_clover_tree_baby/big_clover_tree_baby.tscn")
# Called when the node enters the scene tree for the first time.
onready var enough_space = false
var adulthood = 0

func _ready():

	add_to_group("tree")
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)

func _on_adulthood_timeout():
	adulthood += 1
	
	if enough_space == false :
		enough_space = true
		
	if adulthood >= 700 :
		var baby = baby_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(baby)
		baby.position = self.position
		self.queue_free()

func _on_life_space_area_entered(area):
	var area_name = area.get_name()
	if area_name == "life_space" :
		if enough_space == false :
			self.queue_free()

func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"save_value" : save_value,
		"adulthood" : adulthood,
		"enough_space" : enough_space
	}
	return save
