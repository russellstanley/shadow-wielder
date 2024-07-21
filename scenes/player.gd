extends TopDownCharacter

signal grab(body : Enemy)
@onready var enemy_highlight_zone = $EnemyHighlightZone
var highighted_enemies : Array

var roataion_map = {
	Direction.UP: 180,
	Direction.DOWN: 0,
	Direction.LEFT: 90,
	Direction.RIGHT: 270
}

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		state = State.ATTACK
		update_annimation("attack", current_direction)
		
		if not highighted_enemies.is_empty():
			var selected_enemy = highighted_enemies[0]
			selected_enemy.freeze()
			grab.emit(selected_enemy)
		
	# Create the input vector
	var input_vector = get_input_vector()
	update_direction(input_vector)
	rotate_highlight_zone()
	velocity = update_velocity(input_vector, delta)
	
	if (state == State.WALK):
		update_annimation("walk", current_direction)
	if velocity.is_zero_approx():
		update_annimation("idle", current_direction)
		
	move_and_slide()
	
func get_input_vector():
	var input_vector : Vector2
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	return input_vector.normalized()
	
func rotate_highlight_zone():
	enemy_highlight_zone.rotation_degrees = roataion_map[current_direction]
	
func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.toggle_highlight()
		highighted_enemies.append(body)
		
func _on_area_2d_body_exited(body):
	var index = highighted_enemies.find(body)
	if index != -1:
		highighted_enemies.remove_at(index)
		
	if body is Enemy:
		body.toggle_highlight()
