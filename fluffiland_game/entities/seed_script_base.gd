extends StaticBody2D


var save_value = "Persist_child"

onready var area_shape = $fluffi_node_base/life_space
onready var life_area = $fluffi_node_base/life_space/life_area
onready var area_radius = life_area.shape.radius
onready var baby_scene = preload ("res://entities/fluffiplant/fluffiplant_baby/fluffiplant_baby.tscn")

onready var timer = $fluffi_node_base/Timer
# Called when the node enters the scene tree for the first time.
onready var enough_space = false
var adulthood = 0

var adult_time = 120

func _ready():

	add_to_group("tree")
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	
	timer.connect("timeout", self, "_on_Timer_timeout")
	area_shape.connect("area_entered", self, "_on_life_space_area_entered")

func _on_Timer_timeout():
	adulthood += 1
	
	if enough_space == false :
		enough_space = true
		
	if adulthood >= adult_time :
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
