extends Label

func _on_animal_counter_diversity_counter(animal_counter):
	self.text = str("Diversity : ",animal_counter.animal_diversity)
