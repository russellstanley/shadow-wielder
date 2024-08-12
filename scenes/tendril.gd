class_name Tendril extends Sprite2D

var  target_length
const TENDRIL_SPEED = 300
signal target_reached

func _init(target_length):
	self.target_length = target_length

func extend_tendril(delta):
	var tendril_length = region_rect.size.y
	if tendril_length < target_length:
		region_rect = region_rect.expand(Vector2i(0, tendril_length + TENDRIL_SPEED * delta))
	else:
		target_reached.emit()
		
func reset():
	queue_free()
