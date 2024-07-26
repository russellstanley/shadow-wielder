extends Sprite2D

@onready var tendril = $Tendril
const TENDRIL_SPEED = 4

var tendril_on = false
var target_length = 0
var target_body: Enemy

func _process(delta):
	if tendril_on:
		extend_tendril()
	
func extend_tendril():
	var tendril_length = tendril.region_rect.size.y
	if tendril_length < target_length:
		tendril.region_rect = tendril.region_rect.expand(Vector2i(0,tendril_length + TENDRIL_SPEED))
	else:
		target_body.damage()
		tendril_on = false
		
func _on_player_grab(body):
	modulate.a = 255
	target_body = body
	tendril.region_rect.size.y = 0
	tendril.visible = true
	target_length = global_position.distance_to(body.global_position)

	# NOTE: Note sure why added angle is needed.
	tendril.rotation = body.global_position.angle_to_point(global_position) + PI/2
	tendril_on = true
	
func reset():
	modulate.a = 198
	tendril.region_rect.size.y = 0
	tendril.visible = false

func _on_skeleton_2_damage_taken():
	print("here")
	reset()

func _on_skeleton_damage_taken():
	print("here")
	reset()
