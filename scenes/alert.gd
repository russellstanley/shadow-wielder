extends Control

@export var game_manager : GameManger

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
@onready var label = $Panel/VBoxContainer/Label

func set_alert_messsage(message: String):
	label.text = message

func _on_restart_pressed():
	game_manager.restart()
