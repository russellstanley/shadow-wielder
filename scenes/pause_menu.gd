extends Control

@export var game_manager : GameManger

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_resume_button_pressed():
	game_manager.game_paused = false
