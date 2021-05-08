extends Control


signal robot_updated
signal strength_spend
signal fertilizer_created

var option_1_bought = false
var option_2_bought = false
var option_3_bought = false
var option_4_bought = false
var option_5_bought = false
var option_6_bought = false
var option_7_bought = false

onready var buy_button_1 = $texts/HBoxContainer/buy_1
onready var buy_button_2 = $texts/HBoxContainer2/buy_2
onready var buy_button_3 = $texts/HBoxContainer3/buy_3
onready var buy_button_4 = $texts/HBoxContainer4/buy_4
onready var buy_button_5 = $texts/HBoxContainer5/buy_5
onready var buy_button_6 = $texts/HBoxContainer6/buy_6
onready var buy_button_7 = $texts/HBoxContainer7/buy_7

onready var cost_text_1 = $texts/HBoxContainer/price_1
onready var cost_text_2 = $texts/HBoxContainer2/price_2
onready var cost_text_3 = $texts/HBoxContainer3/price_3
onready var cost_text_4 = $texts/HBoxContainer4/price_4
onready var cost_text_5 = $texts/HBoxContainer5/price_5
onready var cost_text_6 = $texts/HBoxContainer6/price_6
onready var cost_text_7 = $texts/HBoxContainer7/price_7

onready var container_product_button = $make_fertilizer
onready var poop_texture = load("res://food/poop/medium_poop/sprite/poop.png")

var cost_1 = 500
var cost_2 = 250
var cost_3 = 120
var cost_4 = 60
var cost_5 = 120
var cost_6 = 250
var cost_7 = 500

var poop_number = 0
var poop_quality = 0

var container = "empty"

var fertilizer = 0
var fertilizer_quality = 0


func _ready():
	self.connect("strength", get_tree().root.get_node("Game/game_start"), "_on_strength_spend")
	self.connect("robot_updated", get_tree().root.get_node("Game/game_start/YSort/robot"), "_on_robot_updated")
	self.connect("robot_updated", get_tree().root.get_node("Game/game_start"), "_on_robot_updated")
	self.connect("fertilizer_created", get_tree().root.get_node("Game/game_start"), "_on_fertilizer_created")
	self.connect("fertilizer_created", get_tree().root.get_node("Game/game_start/YSort/robot"), "_on_fertilizer_created")
	
	cost_text_1.text = str(cost_1)
	cost_text_2.text = str(cost_2)
	cost_text_3.text = str(cost_3)
	cost_text_4.text = str(cost_4)
	cost_text_5.text = str(cost_5)
	cost_text_6.text = str(cost_6)
	cost_text_7.text = str(cost_7)
		
	if option_1_bought == true :
		buy_button_1.queue_free()
	
	if option_2_bought == true :
		buy_button_2.queue_free()

	if option_3_bought == true :
		buy_button_3.queue_free()
		
	if option_4_bought == true :
		buy_button_4.queue_free()
		
	if option_5_bought == true :
		buy_button_5.queue_free()
		
	if option_6_bought == true :
		buy_button_6.queue_free()
		
	if option_7_bought == true :
		buy_button_7.queue_free()		
	
	if container == "empty" :
		container_product_button.queue_free()
		
	elif container == "poop" :
		container_product_button.set_normal_texture(poop_texture)
	
	else :
		pass
	print ("poop info robot : ", poop_number)
	print ("poop quality info robot : ", poop_quality)
func _on_buy_1_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count > cost_1 :
		emit_signal("strength_spend", cost_1)
		emit_signal("robot_updated", 1)
		option_1_bought = true
		update()
	else : 
		pass

func _on_buy_2_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count > cost_2 :
		emit_signal("strength_spend", cost_2)
		emit_signal("robot_updated", 2)
		option_2_bought = true
		update()

func _on_buy_3_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count > cost_3 :
		emit_signal("strength_spend", cost_3)
		emit_signal("robot_updated", 3)
		option_3_bought = true
		update()

func _on_buy_4_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count > cost_4 :
		emit_signal("strength_spend", cost_4)
		emit_signal("robot_updated", 4)
		option_4_bought = true
		update()

func _on_buy_5_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count > cost_5 :
		emit_signal("strength_spend", cost_5)
		emit_signal("robot_updated", 5)
		option_5_bought = true
		update()

func _on_buy_6_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count > cost_6 :
		emit_signal("strength_spend", cost_6)
		emit_signal("robot_updated", 6)
		option_6_bought = true
		update()

func _on_buy_7_pressed():
	if get_tree().root.get_node("Game/game_start").strength_count > cost_7:
		emit_signal("strength_spend", cost_7)
		emit_signal("robot_updated", 7)
		option_7_bought = true
		update()



func _on_make_fertilizer_pressed():
	if container != "empty" :
		fertilizer = 1

	if container == "poop" :
		if poop_quality <= 10 :
			fertilizer_quality = 1
		
		elif poop_quality <= 20 :
			fertilizer_quality = 2
		
		elif poop_quality <= 40 :
			fertilizer_quality = 3

		elif poop_quality <= 80 :
			fertilizer_quality = 4

		elif poop_quality <= 160 :
			fertilizer_quality = 5

		elif poop_quality <= 320 :
			fertilizer_quality = 6

		elif poop_quality <= 640 :
			fertilizer_quality = 7

		elif poop_quality <= 1280 :
			fertilizer_quality = 8

		elif poop_quality <= 2560 :
			fertilizer_quality = 9
			
		elif poop_quality >=2560 :
			fertilizer_quality = 10
		
		container = "fertilizer"	
		poop_number = 0
		poop_quality = 0
		
	emit_signal("fertilizer_created", fertilizer_quality)
	print ("fertilizer  ,", fertilizer, "quality, ", fertilizer_quality)

		
func _on_container_product_pressed():
	print ("fertilizer  ,", fertilizer, "quality, ", fertilizer_quality)


			
		
	

		

func _on_close_button_pressed():
	get_tree().paused = false
	self.queue_free()








