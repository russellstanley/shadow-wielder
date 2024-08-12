extends Node2D

@onready var player : TopDownCharacter = $Player
@onready var enemies = $Enemies
@onready var timer = $Timer

const SKELETON = preload("res://scenes/skeleton.tscn")
const DEFAULT_SPEED = 50
const DEFAULT_ACCELERATION = 50
const DEFAULT_FRICTION = 100
const DEFAULT_MAX_HEALTH = 3
const POTION_CHANCE = 2 # Chance is 1 in <POTION_CHANCE> 

const SPAWN_POINTS : Array = [
	Vector2(-360, -240), 
	Vector2(-360, 240), 
	Vector2(360, -240), 
	Vector2(360, 240)
]

@export var game_manager : GameManger
var wave : int

signal wave_started(wave : int)
signal wave_ended(wave : int)
signal potion_dropped(amount)

func _process(delta):
	if enemies.get_child_count() <= 0:
		wave_ended.emit(wave)
		
		if timer.is_stopped() and player.potions > 0:
			game_manager.alert("Upgrade", false)
			
		if timer.is_stopped():
			timer.start()

func _ready():
	spawn_enemy(Vector2i(50, -150))
	spawn_enemy(Vector2i(100, 100))
		
func start_new_wave():
	wave += 1
	wave_started.emit(wave)
	
	for i in wave + 2:
		var location = SPAWN_POINTS.pick_random()
		location.x += randi_range(-70, 70)
		location.y += randi_range(-70, 70)
		spawn_enemy(location)

func spawn_enemy(location : Vector2i):
	var new_skelton = SKELETON.instantiate()
	new_skelton.setup(DEFAULT_SPEED, DEFAULT_ACCELERATION, DEFAULT_FRICTION, DEFAULT_MAX_HEALTH)
	new_skelton.global_position = location
	new_skelton.connect("character_died", _on_enemy_died)
	enemies.add_child(new_skelton)

func _on_player_damage_received(health):
	game_manager.hud.update_health(health, player.max_health)

func _on_player_character_died():
	game_manager.alert("Dead", true)
	
func _on_enemy_died():
	if randi_range(1, POTION_CHANCE) == 1:
		player.potions += 1
		print(player.potions)
		potion_dropped.emit(player.potions)
	
func _on_player_mana_used(mana):
	game_manager.hud.update_mana(mana, player.max_mana)

func _on_timer_timeout():
	timer.stop()
	start_new_wave()
