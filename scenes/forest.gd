extends Node2D

@export var game_manager : GameManger
@onready var player : TopDownCharacter = $Player

func _ready():
	print("hello")
	player.connect("character_died", _on_player_character_died)

func _on_player_damage_received(health):
	print("ouchie hello")
	game_manager.hud.update_health(health)

func _on_player_character_died():
	print("ded")
	game_manager.alert("Dead")
	
