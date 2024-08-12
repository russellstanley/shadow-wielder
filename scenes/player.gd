extends TopDownCharacter

@onready var enemy_highlight_zone = $EnemyHighlightZone
@onready var hit_box = $HitBox
@onready var hurt_box = $HurtBox
@onready var thunder = $Thunder
@onready var whoosh = $Whoosh

var highighted_enemies : Array
@export var max_mana = 2
var mana : int = max_mana:
	set(value):
		if value > max_mana:
			mana = max_mana
		else:
			mana = value
			
@export var max_potions = 3
var potions : int = 0:
	set(value):
		if value > max_mana:
			potions = max_potions
		else:
			potions = value
			
signal grab(enemies : Array)
signal mana_used(mana : int)

var roataion_map = {
	Direction.UP: 180,
	Direction.DOWN: 0,
	Direction.LEFT: 90,
	Direction.RIGHT: 270
}

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		shadow_attack()
	if Input.is_action_just_pressed("attack"):
		melee_attack()
	
	if (state == State.WALK):
		if velocity.is_zero_approx():
			update_annimation("idle", current_direction)
		else:
			update_annimation("walk", current_direction)
	elif (state == State.HURT or state == State.DEAD):
		update_annimation("hurt", current_direction)
		
	# Create the input vector
	var input_vector = get_input_vector()

	update_direction(input_vector)
	velocity = update_velocity(input_vector, delta)
	rotate_highlight_zone()
	rotate_hitbox()
		
	move_and_slide()
	
func shadow_attack():
	var selected_enemy : Enemy
	if mana <= 0:
		# TODO: Play sound
		return
	
	if not highighted_enemies.is_empty() and state != State.HURT:
		transition_state(State.ATTACK)
		update_annimation("attack", current_direction)
		mana -= 1
		thunder.play()
		mana_used.emit(mana)
		grab.emit(highighted_enemies)

func melee_attack():
	if state != State.HURT:
		whoosh.play()
		transition_state(State.ATTACK)
		update_annimation("attack", current_direction)
		hit_box.activate()
	
func get_input_vector():
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	return input_vector.normalized()
	
func rotate_highlight_zone():
	enemy_highlight_zone.rotation_degrees = roataion_map[current_direction]

func rotate_hitbox():
	hit_box.rotation_degrees = roataion_map[current_direction]
	if (current_direction == Direction.LEFT or current_direction == Direction.RIGHT):
		hit_box.collision_shape.rotation_degrees = 0
	else: 
		hit_box.collision_shape.rotation_degrees = 90
		
func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.toggle_highlight(true)
		highighted_enemies.append(body)
		
func _on_area_2d_body_exited(body):
	var index = highighted_enemies.find(body)
	if index != -1:
		highighted_enemies.remove_at(index)
		
	if body is Enemy:
		body.toggle_highlight(false)

func _on_animated_sprite_animation_finished():
	if (state == State.ATTACK):
		hit_box.deactivate()
	if (state == State.HURT):
		hurt_box.activate()
		
	transition_state(State.WALK)

func _on_hurt_box_area_entered(area):
	hurt_box.deactivate()
	
	var direction = -global_position.direction_to(area.global_position).normalized()
	knockback(direction, 300)
	damage()
