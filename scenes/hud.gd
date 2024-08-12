extends Control

@onready var health_container = $HealthContainer
@onready var mana_container = $ManaContainer
@onready var wave_counter = $Header/WaveCounter
@onready var potion_container = $PotionContainer


const MAX_SIZE = 50
const POTION_SIZE = 16

func update_wave(wave):
	wave_counter.text = "Wave\n" + str(wave)
	
func update_potions(amount):
	if amount == 0:
		potion_container.hide()
	else:
		potion_container.show()
		potion_container.size.x = amount * POTION_SIZE

func update_health(health, max_health):
	health_container.size.x = MAX_SIZE * (float(health) / float(max_health))
	
func update_mana(mana, max_mana):
	mana_container.size.x = MAX_SIZE * (float(mana) / float(max_mana))
