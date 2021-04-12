extends StaticBody2D

signal algae_cut

export var num_rays = 4
export var look_ahead = 150
var ray_directions = []
var algae_presence = []

var health = 50
var energy = 50
var specie = "parasite_algae"

var hunger 
onready var child_scene = load ("res://food/vegetals/parasite_algae/baby/parasite_algae_baby.tscn")

func _ready():
	
	hunger = false
	add_to_group("parasite", true)
	add_to_group("parasite_algae", true)
	
	self.connect("algae_cut", get_tree().root.get_node("Game"), "_on_algae_cut")
	
	ray_directions.resize(num_rays)
	algae_presence.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
		algae_presence[i] = 0.0

func _process(_delta):

	check_algae_presence()

func check_algae_presence():
	var space_state = get_world_2d().direct_space_state
	
	for i in num_rays:
		
		var result = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead)#, [self])
		
		if result :
			
			var target = result["collider"]
			if target :
				algae_presence[i] = 1.0
			
				if target.is_in_group ("vegetals") and hunger == true :
					target.nutrient -= 1
					hunger = false




func _on_hunger_timeout():
	hunger = true

func _on_reproduction_timeout():
	
	if (algae_presence[0]) == 0 :
		var child_1 = child_scene.instance()
		get_tree().root.get_node("Game/YSort").add_child(child_1)
		child_1.position.x = self.position.x + 100
		child_1.position.y = self.position.y
	else :
		pass
		
	if (algae_presence[1]) == 0 :
		var child_2 = child_scene.instance()
		get_tree().root.get_node("Game/YSort").add_child(child_2)
		child_2.position.x = self.position.x 
		child_2.position.y = self.position.y + 100
	else :
		pass
	
	if (algae_presence[2]) == 0 :
		var child_3 = child_scene.instance()
		get_tree().root.get_node("Game/YSort").add_child(child_3)
		child_3.position.x = self.position.x - 100
		child_3.position.y = self.position.y 
	else :
		pass
	
	if (algae_presence[3]) == 0 :
		var child_4 = child_scene.instance()
		get_tree().root.get_node("Game/YSort").add_child(child_4)
		child_4.position.x = self.position.x
		child_4.position.y = self.position.y - 100
	else :
		pass
	
#func _draw():
#	for i in num_rays:
#		draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i] * look_ahead, Color(255, 255, 0), 5)


func _on_TextureButton_pressed():
	if get_tree().root.get_node("Game").strength_count > 1 :
		emit_signal("algae_cut")
		emit_signal("algae_cut")
		self.queue_free()
	else :
		pass
