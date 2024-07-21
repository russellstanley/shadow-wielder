extends Sprite2D

@onready var tendril = $Tendril
const TENDRIL_SPEED = 2

var tendril_on = false
var tendril_max_length = 0

func _process(delta):
	if tendril_on:
		extend_tendril()
	
func extend_tendril():
	var tendril_length = tendril.region_rect.size.y
	if tendril_length < tendril_max_length:
		tendril.region_rect = tendril.region_rect.expand(Vector2i(0,tendril_length + TENDRIL_SPEED))

func _on_player_grab(body):
	modulate.a = 255
	tendril.region_rect.size.y = 0
	tendril.visible = true
	tendril_max_length = global_position.distance_to(body.global_position)

	# NOTE: Note sure why added angle is needed.
	tendril.rotation = body.global_position.angle_to_point(global_position) + PI/2
	tendril_on = true
