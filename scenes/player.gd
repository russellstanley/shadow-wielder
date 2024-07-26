extends TopDownCharacter

@onready var enemy_highlight_zone = $EnemyHighlightZone
var highighted_enemies : Array
signal grab(body : Enemy)
@onready var hit_box = $HitBox
@onready var hurt_box = $HurtBox

var roataion_map = {
	Direction.UP: 180,
	Direction.DOWN: 0,
	Direction.LEFT: 90,
	Direction.RIGHT: 270
}

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		transition_state(State.ATTACK)
		update_annimation("attack", current_direction)
		
		if not highighted_enemies.is_empty():
			var selected_enemy = highighted_enemies[0]
			selected_enemy.freeze()
			grab.emit(selected_enemy)
		
	if Input.is_action_just_pressed("attack"):
		transition_state(State.ATTACK)
		update_annimation("attack", current_direction)
		hit_box.activate()
		
	# Create the input vector
	var input_vector = get_input_vector()
	update_direction(input_vector)
	rotate_highlight_zone()
	rotate_hitbox()
	velocity = update_velocity(input_vector, delta)
	
	if (state == State.WALK):
		update_annimation("walk", current_direction)
	elif (state == State.HURT or state == State.DEAD):
		update_annimation("hurt", current_direction)
	if state == State.WALK and velocity.is_zero_approx():
		update_annimation("idle", current_direction)
		
	move_and_slide()
	
func knockback(direction, strength):
	velocity = velocity + (direction * strength)
	
func get_input_vector():
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	return input_vector.normalized()
	
func rotate_highlight_zone():
	enemy_highlight_zone.rotation_degrees = roataion_map[current_direction]

func rotate_hitbox():
	hit_box.rotation_degrees = roataion_map[current_direction]
	
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

func _on_animated_sprite_animation_finished():
	if (state == State.ATTACK):
		hit_box.deactivate()
	if (state == State.HURT):
		hurt_box.activate()
		
	transition_state(State.WALK)

func _on_hurt_box_area_entered(area):
	hurt_box.deactivate()
	
	var direction = -global_position.direction_to(area.global_position).normalized()
	knockback(direction, 200)
	
	damage()
