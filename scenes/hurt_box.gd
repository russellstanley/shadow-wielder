extends Area2D

@export var collision_shape : CollisionShape2D

func activate():
	collision_shape.call_deferred("set_disabled", false)
	
func deactivate():
	collision_shape.call_deferred("set_disabled", true)
