extends StaticBody2D


var energy = 100
var health = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("meat")
	
func _process(_delta):
	
	if energy <= 0 or health <= 0:
		get_tree().queue_delete(self)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
