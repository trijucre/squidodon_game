extends StaticBody2D




var energy =100
var health = 5
var quality = 1

func _ready():
	add_to_group("poop")

func _process(_delta):
	if health <= 0 :
		self.queue_free()
	
	
