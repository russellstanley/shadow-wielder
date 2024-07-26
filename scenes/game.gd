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
		get_tree().paused = game_paused
		show_pause_menu(game_paused)
		print(game_paused)
		
func _ready():
	game_paused = false
		
func alert(message : String):
	alert_on_screen = true
	game_paused = true
	pause_menu.hide()
	alert_menu.show()
	alert_menu.set_alert_messsage(message)

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
		
func restart():	
	get_tree().reload_current_scene()
