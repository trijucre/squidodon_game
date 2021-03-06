extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100
var energy =20

var energy_bit_value = 5
var health_bit_value = 1
var bar_size = 10

var save_value = "Persist_child"

onready var health_bar = $health_bar
onready var strength_bar = $strength_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group ("Persist", true)
	add_to_group("Persist_child", true)
	
	health_bar.rect_size.x = float(health) * health_bit_value
	health_bar.rect_size.y = 20
	
	strength_bar.rect_size.x = float(energy) * energy_bit_value
	strength_bar.rect_size.y = 20
	#for i in number_of_pv :
	#	var healthbit = TextureRect.new()
	#	healthbit.set_texture(image)
	#	lifecontainer.add_child(healthbit)

func _on_stats_changed(stat, value):
	print("stat bar of robot has changed")
	print ("stat ", stat, "value ", value)
	if stat == "health" :
		health -= value
		health_bar.rect_size.x = float(health) * health_bit_value

	
	if stat == "strength" :
		energy -= value
		strength_bar.rect_size.x = float(energy) * energy_bit_value
		

	
		
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"health" : health,
		"energy" : energy
	}
	return save
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
