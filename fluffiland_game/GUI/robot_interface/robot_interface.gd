extends Node2D

signal refill
signal recolt
signal fertilize

onready var sprite = $Sprite
onready var health_back = $health_back
onready var health = $health_back/health

func _ready():
	pass

func _on_refill_button_pressed():
	emit_signal("refill")

func _on_recolt_button_pressed():
	emit_signal("recolt")

func _on_fertilize_button_pressed():
	emit_signal("fertilize")
	
func _on_stats_changed(energy, energy_max):
	health_back.rect_size.x = 10*energy_max + 6
	health.rect_size.x = 10*energy
	
func _on_robot_here():
	print ("-on-robot-here connected")
	sprite.hide()
	self.connect ("refill", get_tree().root.get_node("Game/game_start/YSort/robot"), "_on_refill_pressed")
	self.connect ("recolt", get_tree().root.get_node("Game/game_start/YSort/robot"), "_on_recolt_pressed")
	self.connect ("fertilize", get_tree().root.get_node("Game/game_start/YSort/robot"), "_on_fertilize_pressed")
