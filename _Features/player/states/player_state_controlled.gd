class_name PlayerStateControlled extends PlayerState


func physics_update(delta: float) -> void:
	_calculate_velocity(delta)
	_calculate_look_at()
	_calculate_animations()

	state_owner.move_and_slide()


func _calculate_animations() -> void:
	if state_owner.velocity.length() > 0.05:
		state_owner.player_animation.play("Walk")
	else:
		state_owner.player_animation.play("Idle")


func _calculate_velocity(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector(
		"player_left", "player_right", "player_up", "player_down"
	)

	var input_direction_3d = Vector3(input_direction.x, 0.0, input_direction.y)

	if input_direction_3d != Vector3.ZERO:
		state_owner.velocity = lerp(
			state_owner.velocity,
			input_direction_3d * state_owner.speed,
			state_owner.acceleration * delta
		)
	else:
		state_owner.velocity = lerp(
			state_owner.velocity, Vector3.ZERO, state_owner.intertia * delta
		)


func _calculate_look_at() -> void:
	if state_owner.velocity.normalized() == Vector3.ZERO:
		return

	var vector_to_look_to := (
		state_owner.global_position
		+ Vector3(
			-state_owner.velocity.normalized().x,
			state_owner.velocity.normalized().y,
			-state_owner.velocity.normalized().z
		)
	)

	state_owner.look_at(vector_to_look_to)
