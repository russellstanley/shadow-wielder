class_name Enemy extends TopDownCharacter

var player = null
@onready var highlight = $Highlight

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var next_direction = Vector2.ZERO
	if state == State.TRACKING:
		next_direction = global_position.direction_to(player.global_position).normalized()
	if state == State.FROZEN:
		velocity = Vector2.ZERO
		
	if (state == State.WALK):
		update_annimation("walk", current_direction)
	if velocity.is_zero_approx():
		update_annimation("idle", current_direction)
	
	update_direction(next_direction)
	velocity = update_velocity(next_direction, delta)
	move_and_slide()
	
func toggle_highlight():
	highlight.visible = not highlight.visible
	
func freeze():
	state = State.FROZEN
	
func _on_player_detection_body_entered(body):
	state = State.TRACKING
	player = body
	
func _on_player_detection_body_exited(body):
	state = State.WANDER
	player = null
