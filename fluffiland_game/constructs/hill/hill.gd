extends StaticBody2D

signal strength_spend
signal diversity_level_2_enter
signal pearl_earned
signal construct_panel

onready var area_radius = $Area2D/area.shape.radius

var save_value = "Persist_child"

var health_time =0

var saved = false
var ressource_transferred = false
var transfer_time = 0

var ressource_given_count_max = 10
var ressource_given = "strength"

var cost = 0
var energy = 200
var energy_max = 200
var health = 200
var health_max = 200
var specie = "hill"

var id

onready var used_position = Vector2(-30, -600)


onready var sprite = $Sprite
onready var used_indicator = preload("res://popup/produced_spent_indicator/strength_used_indicator.tscn")
onready var default = preload("res://constructs/hill/sprite/rock_sprite.png")
onready var thirsty = preload ("res://constructs/hill/sprite/rock_sprite_thirsty.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	self.connect("pearl_earned", get_tree().root.get_node("Game/game_start"), "_on_pearl_earned")
	
	self.connect("construct_panel", get_tree().root.get_node("Game/game_start"), "_on_construct_panel_pressed")
	
	randomize()
	
	add_to_group("construct")
	add_to_group("hill")


	add_to_group("Persist", true)
	add_to_group("persist_child", true)

	self.connect("strength_spend", get_tree().root.get_node("Game/game_start"), "_on_strength_spend")
	if saved == false :
		emit_signal("pearl_earned")
	emit_signal("diversity_level_2_enter")
	
	if saved == false :
		id = str(self.get_instance_id())
	
	add_to_group(id)
	saved = true
	
func _on_Timer_timeout():

	
	if ressource_transferred == true :
		sprite.play("thirsty")
		transfer_time += 1
		if transfer_time >= 60 :
			ressource_transferred = false
			transfer_time = 0
			sprite.play("default")


func _on_info_panel_pressed():
	print ("button construct panel pressed in hill scne")
	emit_signal("construct_panel", ressource_given_count_max, ressource_given, ressource_transferred, id)


func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"health_time" : health_time,
		"saved" : saved,
		"ressource_transferred" : ressource_transferred,
		"transfer_time" : transfer_time,
		"id" : id
	}
	return save
