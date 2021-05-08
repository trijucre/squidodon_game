extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sprite_text = "happy"
onready var sprite = $Sprite

onready var happy_bubble = preload("res://popup/popup_robot/sprites/robot_bubble_happy.png")
onready var angry_bubble = preload("res://popup/popup_robot/sprites/robot_bubble_mad.png")
onready var fertilizer_bubble = preload ("res://popup/popup_robot/sprites/robot_bubble_fertilizer.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if sprite_text == "angry" :
		sprite.set_texture(angry_bubble)
	
	if sprite_text == "fertilizer" :
		sprite.set_texture(fertilizer_bubble)

	else :
		sprite.set_texture(happy_bubble)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	self.queue_free()
