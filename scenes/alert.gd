extends Control

@export var game_manager : GameManger
	
@onready var label = $Panel/VBoxContainer/Label
@onready var restart = $Panel/VBoxContainer/Restart
@onready var continue_game = $Panel/VBoxContainer/Continue
@onready var max_health = $Panel/VBoxContainer/MaxHealth
@onready var max_mana = $Panel/VBoxContainer/MaxMana

func _ready():
	hide()

func set_alert_messsage(message: String):
	label.text = message
	
func show_death_buttons():
	restart.show()
	continue_game.hide()
	max_health.hide()
	max_mana.hide()
	
func show_upgrade_buttons():
	restart.hide()
	continue_game.show()
	max_health.show()
	max_mana.show()
	
func show_continue_button():
	restart.hide()
	continue_game.show()
	max_health.hide()
	max_mana.hide()

func _on_restart_pressed():
	game_manager.restart()
		
func _on_max_health_pressed():
	if (game_manager.forest.player.potions > 0):
		game_manager.increase_max_health(2)
		game_manager.forest.player.potions -= 1
		game_manager.hud.update_potions(game_manager.forest.player.potions)
		

func _on_max_mana_pressed():
	if (game_manager.forest.player.potions > 0):
		game_manager.increase_max_mana(2)
		game_manager.forest.player.potions -= 1
		game_manager.hud.update_potions(game_manager.forest.player.potions)
	
func _on_continue_pressed():
	game_manager.game_paused = false
