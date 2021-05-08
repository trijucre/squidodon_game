extends StaticBody2D

signal algae_cut

var save_value = "Persist_child"

var reproduction_time = 0
var hunger_time = 0

export var num_rays = 4
export var look_ahead = 150
var ray_directions = []
var algae_presence = []

var nutrient = 2
var health = 50
var energy = 50
var specie = "parasite_algae"

onready var area_radius = $Area2D/area.shape.radius

var hunger
onready var child_scene = load ("res://entities/parasite_algae/baby/parasite_algae_baby.tscn")

func _ready():
	
	hunger = false
	add_to_group("parasite", true)
	add_to_group("parasite_algae", true)
	
	add_to_group("Persist", true)
	add_to_group("persist_child", true)
	
	self.connect("algae_cut", get_tree().root.get_node("Game/game_start"), "_on_algae_cut")
	
	ray_directions.resize(num_rays)
	algae_presence.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
		algae_presence[i] = 0.0

func _process(delta):
	if nutrient <= 0 :
		self.queue_free()
	#check_algae_presence()

func check_algae_presence():
	var space_state = get_world_2d().direct_space_state
	
	for i in num_rays:
		
		var result = space_state.intersect_ray(position, position + ray_directions[i].rotated(rotation) * look_ahead)#, [self])
		
		if result :
			
			var target = result["collider"]
			if target :
				algae_presence[i] = 1.0
			
				if target.is_in_group ("vegetals") and hunger == true :
					print("algae detected target")
					target.health -= 1
					hunger = false

func reproduce():
	
	if (algae_presence[0]) == 0 :
		var child_1 = child_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(child_1)
		child_1.position.x = self.position.x + 100
		child_1.position.y = self.position.y
	else :
		pass
		
	if (algae_presence[1]) == 0 :
		var child_2 = child_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(child_2)
		child_2.position.x = self.position.x
		child_2.position.y = self.position.y + 100
	else :
		pass
	
	if (algae_presence[2]) == 0 :
		var child_3 = child_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(child_3)
		child_3.position.x = self.position.x - 100
		child_3.position.y = self.position.y
	else :
		pass
	
	if (algae_presence[3]) == 0 :
		var child_4 = child_scene.instance()
		get_tree().root.get_node("Game/game_start/YSort").add_child(child_4)
		child_4.position.x = self.position.x
		child_4.position.y = self.position.y - 100
	else :
		pass



func _on_Timer_timeout():
	
	reproduction_time += 1
	hunger_time += 1
	
	if reproduction_time >= 120 :
		check_algae_presence()
		reproduce()
		reproduction_time = 0
	 
	if hunger_time >= 60 :
		hunger = true
		check_algae_presence()
		hunger_time = 0
	

	
#func _draw():
#	for i in num_rays:
#		draw_line(Vector2(0,0), Vector2(0,0) + ray_directions[i] * look_ahead, Color(255, 255, 0), 5)


func _on_TextureButton_pressed():
	if get_tree().root.get_node("Game/game_start/").strength_count > 1 :
		emit_signal("algae_cut")
		emit_signal("algae_cut")
		self.queue_free()
	else :
		pass
		
		
func save():
	var save = {
		"filename" : get_filename(),
		#"parent" : get_parent().get_path(),
		"position" : get_global_position(),
		"pos_y" : get_position(),
		"hunger" : hunger,
		"hunger_time" : hunger_time,
		"reproduction_time" : reproduction_time
	}
	return save
