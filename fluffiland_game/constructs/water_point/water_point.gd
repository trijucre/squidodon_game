extends StaticBody2D

onready var area_radius = $Area2D/area.shape.radius

var save_value = "Persist_child"

var specie = "pond"

var water_stock = 3
var picture = "full"

onready var used_position = Vector2(-30, -600)


onready var sprite = $Sprite
 
# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_to_group("construct")
	add_to_group("water_point")

	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	
func _process(delta):
	
	if water_stock > 0 and picture == "empty" :
		sprite.play("default")
		picture == "full"

	if water_stock <= 0 and picture == "full" :
		sprite.play("thirsty")
		picture == "empty"
	
	if water_stock <= 0 and picture == "empty" :
		var rain = get_tree().root.get_node("Game/game_start").rain_falling
		if rain == true :
			water_stock = 3
	
	
			
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"water_stock" : water_stock,
		"picture" : picture
	}
	return save
