class_name Enemy extends TopDownCharacter

@onready var highlight = $Highlight
@onready var hurt_box = $HurtBox

var player = null
var near_trees : Array = []

func setup(speed, acceleration, friction, enemy_health):
	SPEED = speed
	ACCELERATION = acceleration
	FRICTION = friction
	max_health = enemy_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var next_direction = Vector2.ZERO
	
	if state == State.TRACKING:
		update_annimation("walk", current_direction)
		if player != null:			
			next_direction = global_position.direction_to(player.global_position).normalized()
		else:
			transition_state(State.WALK)
	elif state == State.FROZEN:
		velocity = Vector2.ZERO
	elif (state == State.WALK):
		update_annimation("walk", current_direction)
	elif (state == State.HURT):
		update_annimation("hurt", current_direction)
	elif(state == State.DEAD):
		hurt_box.deactivate()
		toggle_highlight(false)
		update_annimation("death", current_direction)
		
	if velocity.is_zero_approx() and state == State.WALK :
		update_annimation("idle", current_direction)
	
	update_direction(next_direction)
	velocity = update_velocity(next_direction, delta)
	
	move_and_slide()
	
func toggle_highlight(visible : bool):
	highlight.visible = visible
	
func freeze():
	transition_state(State.FROZEN)
	
func _on_player_detection_body_entered(body):
	transition_state(State.TRACKING)
	player = body
	
func _on_player_detection_body_exited(_body):
	transition_state(State.WALK)
	player = null

func _on_animated_sprite_animation_finished():
	if state == State.HURT:
		damage_taken.emit(self)
	elif state == State.DEAD:
		damage_taken.emit(self)
		queue_free()
		return
	
	transition_state(State.TRACKING)
	
func _on_hurt_box_area_entered(area):
	damage()

func _on_tree_detector_body_entered(body):
	near_trees.append(body)

func _on_tree_detector_body_exited(body):
	var index = near_trees.find(body)
	if index != -1:
		near_trees.remove_at(index)
