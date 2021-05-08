extends Node2D
#class_name CustomObject


var start_screen = preload("res://GUI/start_game/start_game.tscn") 
var save_path = "user://savegame.save"

func _ready():
	var start = start_screen.instance()
	
	self.add_child(start)
	
func _on_quit_to_title_screen():
	var start = start_screen.instance()
	
	self.add_child(start)

func _on_load_pressed():
	load_game()
	if get_tree().root.get_node("Game/start_game") :
		get_tree().root.get_node("Game/start_game").queue_free()
	#load_objects()

	
func _on_save_pressed():
	save_game() 
	#save_objects()
	
	
func save_game():
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)
	for node in save_nodes :
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.call("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

			# Call the node's save function.
		var node_data = node.call("save")
		#var node_data = node.save
	
		# Store the save dictionary as a new line in the save file.
		#save_game.store_line(to_json(node_data))
		save_game.store_var(node_data)
	
	
	save_game.close()

func load_game():
	var save_game = File.new()
	save_game.seek(save_game.get_position())
	if not save_game.file_exists(save_path):
		return # Error! We don't have a save to load.
	
	save_game.open(save_path, File.READ)
	
	

	var save_nodes = get_tree().get_nodes_in_group("Persist_parent")
	
	for i in save_nodes:
		i.queue_free()
		
	while save_game.get_position() < save_game.get_len():
		var node_data = save_game.get_var(true)

			
		var new_object = load(node_data["filename"]).instance()
	
		if new_object.save_value == "Persist_parent" :

			for i in node_data :
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" :#or i == "name" :
					continue
				new_object.set(i, node_data[i])

			get_node(node_data["parent"]).add_child(new_object, true)
				
			new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		#else :
		#	new_object.queue_free()
	
	
		elif new_object.save_value == "Persist_child" :
	
			for i in node_data :
				if i == "filename" or i == "parent" or i == "position" :#or i == "name" :
					continue
				new_object.set(i, node_data[i])
				
			get_tree().root.get_node("Game/game_start/YSort").add_child(new_object, true)
				#new_object.set_name()
			new_object.position = Vector2(node_data["position"])
		
		else : 
			new_object.queue_free()

	save_game.close()



func _on_quit_to_menu_pressed():
	get_tree().root.get_node("Game/game_start").queue_free()
	var start = start_screen.instance()
	
	self.add_child(start)

func _on_end_of_day():
	
	save_game()
