extends Sprite2D

@onready var tendril = $Tendril
const TENDRIL_SPEED = 300

var tendril_on = false
var target_length = 0
var target_body: Enemy

func _process(delta):
	if tendril_on:
		extend_tendril(delta)
	
func extend_tendril(delta):
	var tendril_length = tendril.region_rect.size.y
	if tendril_length < target_length:
		tendril.region_rect = tendril.region_rect.expand(Vector2i(0, tendril_length + TENDRIL_SPEED * delta))
	else:
		target_body.damage()
		tendril_on = false
		
func grab(body : Enemy):
	tendril_on = true
	modulate.a = 255
	target_body = body
	tendril.region_rect.size.y = 0
	tendril.visible = true
	target_length = global_position.distance_to(body.global_position)
	body.connect("damage_taken", _on_enemy_damage_taken)

	# NOTE: Note sure why added angle is needed.
	tendril.rotation = body.global_position.angle_to_point(global_position) + PI/2
	
func reset():
	modulate.a = 198
	tendril.region_rect.size.y = 0
	tendril.visible = false

func _on_enemy_damage_taken(enemy : Enemy):
	reset()
	enemy.disconnect("damage_taken", _on_enemy_damage_taken)
