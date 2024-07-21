class_name TopDownCharacter extends CharacterBody2D

@export var ACCELERATION = 300
@export var FRICTION = 1000
@export var SPEED = 100.0
@onready var animated_sprite = $AnimatedSprite

var current_direction : Direction = Direction.DOWN
var state : State = State.WALK

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum State {
	WALK,
	ATTACK,
	WANDER, # TODO
	TRACKING,
	FROZEN
}
	
func update_velocity(direction, delta):
	if (direction != Vector2.ZERO):
		return velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		return velocity.move_toward(direction * SPEED, FRICTION * delta)
	
func update_direction(direction : Vector2):
	var rot_direction = direction.rotated(45)
	var x = rot_direction.x
	var y = rot_direction.y
	
	if (x > 0 and y > 0):
		current_direction = Direction.RIGHT
	elif (x > 0 and y < 1):
		current_direction = Direction.UP
	elif (x < 0 and y > 0):
		current_direction = Direction.DOWN
	elif (x < 0 and y < 1):
		current_direction = Direction.LEFT
		
func update_annimation(type : String, direction : Direction):
	if direction == Direction.UP:
		animated_sprite.play(type + "_up")
	elif direction == Direction.DOWN:
		animated_sprite.play(type + "_down")
	elif direction == Direction.LEFT:
		animated_sprite.play(type + "_left")
	elif direction == Direction.RIGHT:
		animated_sprite.play(type + "_right")
		
func _on_animated_sprite_animation_finished():
	state = State.WALK
