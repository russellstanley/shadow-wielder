extends Area2D

@export var collision_shape : CollisionShape2D

func activate():
	collision_shape.disabled = false
	
func deactivate():
	collision_shape.disabled = true
