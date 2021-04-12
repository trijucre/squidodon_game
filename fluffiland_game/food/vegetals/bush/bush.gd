extends StaticBody2D

var cost = 1
var energy = 100
var health = 5
var specie = "bush"
var nutrient = 1

func _ready():
	add_to_group("bush", true)

func _process(_delta):
	
	if energy <= 0 or health <= 0:
		get_tree().queue_delete(self)
