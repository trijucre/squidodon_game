extends Control

signal diversity_counter

var cuttledog_count
var fluffilus_count
var coral_ocelot_count
var sand_catshark_count
var rabbibranch_count
var orca_bear_count

var animal_diversity = 0
var cuttledog_diversity = 0
var fluffilus_diversity = 0
var coral_ocelot_diversity = 0
var sand_catshark_diversity = 0
var rabbibranch_diversity = 0
var orca_bear_diversity = 0

onready var diversity = $diversity
onready var button_1 = get_tree().root.get_node("Game/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box1/animal_counter_text_1")
onready var button_2 = get_tree().root.get_node("Game/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box2/animal_counter_text_2")
onready var button_3 = get_tree().root.get_node("Game/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box3/animal_counter_text_3")
onready var button_4 = get_tree().root.get_node("Game/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box4/animal_counter_text_4")
onready var button_5 = get_tree().root.get_node("Game/CanvasLayer/animal_counter/animal_container_boxes/animal_counter_box5/animal_counter_text_5")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	animal_diversity_count()

func _process(_delta):
	
	button_text(button_1)
	
	button_text(button_2)
	
	button_text(button_3)
	
	button_text(button_4)
	
	button_text(button_5)
	
	#button_text(button_6)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func button_text(button) :
	
	#if button.item == "fluffilus" :
	#	button.text = str("fluffilus : ",fluffilus_count)
	
	#elif button.item == "cuttledog" :
	#	button.text = str("cuttledogs : ", cuttledog_count)
	
	#elif button.item == "coral_ocelot" :
	#	button.text = str("coral_ocelots : " , coral_ocelot_count)

	#elif button.item == "sand_catshark" :
	#	button.text = str("sand_catsharks : ", sand_catshark_count)
		
	#elif button.item == "rabbibranch" :
	#	button.text = str("rabbibranchs : ", rabbibranch_count)
	
	#else :
	pass


func _on_Game_number_of_sand_catshark(Game):
	sand_catshark_count = Game.sand_catshark_count
	
	if sand_catshark_count >= 5 :
		sand_catshark_diversity = 1
	else :
		sand_catshark_diversity = 0
	animal_diversity_count()
	
func _on_Game_number_of_fluffilus(Game):
	fluffilus_count = Game.fluffilus_count

	if fluffilus_count >= 5 :
		fluffilus_diversity = 1
	else :
		fluffilus_diversity = 0
	animal_diversity_count()
	
func _on_Game_number_of_cuttledog(Game):
	cuttledog_count = Game.cuttledog_count
	
	if cuttledog_count >= 5 :
		cuttledog_diversity = 1
	else :
		cuttledog_diversity = 0
	animal_diversity_count()
	
func _on_Game_number_of_coral_ocelot(Game):
	coral_ocelot_count = Game.coral_ocelot_count
	
	if coral_ocelot_count >= 5 :
		coral_ocelot_diversity = 1
	else :
		coral_ocelot_diversity = 0
	animal_diversity_count()
	
func _on_Game_number_of_rabbibranch(Game):
	rabbibranch_count = Game.rabbibranch_count

	if rabbibranch_count >= 5 :
		rabbibranch_diversity = 1
	else :
		rabbibranch_diversity = 0
	animal_diversity_count()
	
func animal_diversity_count():
	animal_diversity = (fluffilus_diversity + rabbibranch_diversity + sand_catshark_diversity + cuttledog_diversity + coral_ocelot_diversity + orca_bear_diversity)
	emit_signal("diversity_counter",self)
	
