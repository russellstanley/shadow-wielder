class_name Enemy extends TopDownCharacter

@onready var highlight = $Highlight

var player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var next_direction = Vector2.ZERO
	if state == State.TRACKING:
		if player != null:			
			next_direction = global_position.direction_to(player.global_position).normalized()
		else:
			transition_state(State.WALK)
			
	if state == State.FROZEN:
		velocity = Vector2.ZERO
		
	if (state == State.WALK or state == State.TRACKING):
		update_annimation("walk", current_direction)
	elif (state == State.HURT or state == State.DEAD):
		update_annimation("hurt", current_direction)
		
	if velocity.is_zero_approx() and state == State.WALK :
		update_annimation("idle", current_direction)
	
	update_direction(next_direction)
	velocity = update_velocity(next_direction, delta)
	move_and_slide()
	
func toggle_highlight():
	highlight.visible = not highlight.visible
	
func freeze():
	transition_state(State.FROZEN)
	state = State.FROZEN
	
func _on_player_detection_body_entered(body):
	transition_state(State.TRACKING)
	player = body
	
func _on_player_detection_body_exited(body):
	transition_state(State.WANDER)
	player = null

func _on_animated_sprite_animation_finished():
	if state == State.HURT:
		damage_taken.emit()
	elif state == State.DEAD:
		damage_taken.emit()
		queue_free()
	
	transition_state(State.TRACKING)

func _on_hurt_box_area_entered(area):
	damage()
