class_name GameManger extends Node

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var hud = $HUD/HUD
@onready var alert_menu = $AlertLayer/AlertMenu
@onready var forest = $Forest

var alert_on_screen = false

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		alert_menu.hide()
		alert_on_screen = false
		get_tree().paused = game_paused
		show_pause_menu(game_paused)
		
func _ready():
	game_paused = false
	alert("Your goal. Survive as long as possible\n\nMovement:  Arrow Keys\nMelee Attack:  E\nShadow Attack:  Space", false)
	alert_menu.show_continue_button()
	hud.update_health(forest.player.health, forest.player.max_health)
	hud.update_mana(forest.player.mana, forest.player.max_mana)
	hud.update_potions(0)
	hud.update_wave(0)
		
func alert(message : String, is_death : bool):
	alert_on_screen = true
	game_paused = true
	pause_menu.hide()
	alert_menu.show()
	alert_menu.set_alert_messsage(message)
	if (is_death):
		alert_menu.show_death_buttons()
	else:
		alert_menu.show_upgrade_buttons()

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		# Toggle pause
		if not alert_on_screen:
			game_paused = not game_paused
		
func show_pause_menu(show : bool):
	if show:
		pause_menu.show()
	else:
		pause_menu.hide()
		
func heal_player(amount : int):
	forest.player.heal(amount)
	hud.update_health(forest.player.health, forest.player.max_health)
	
func add_mana(amount : int):
	forest.player.mana += amount
	hud.update_mana(forest.player.mana, forest.player.max_mana)

func increase_max_health(amount : int):
	forest.player.max_health += amount
	hud.update_health(forest.player.health, forest.player.max_health)
	
func increase_max_mana(amount : int):
	forest.player.max_mana += amount
	hud.update_mana(forest.player.mana, forest.player.max_mana)

func restart():	
	get_tree().reload_current_scene()

func _on_forest_wave_started(wave):
	hud.update_wave(wave)
	add_mana(forest.player.max_mana)
	heal_player(forest.player.max_health)

func _on_forest_potion_dropped(amount):
	hud.update_potions(amount)

func _on_forest_wave_ended(wave):
	pass # Replace with function body.
