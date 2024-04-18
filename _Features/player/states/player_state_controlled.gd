class_name PlayerStateControlled extends PlayerState

func physics_update(delta: float) -> void:
	_calculate_velocity(delta)
	if !state_owner.dont_animate_movement:
		_calculate_look_at()
		_calculate_animations()

	state_owner.move_and_slide()


func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && !event.pressed:
		var project_ray_origin = state_owner.camera.project_position(
			event.position, state_owner.camera.global_position.y
		)
		state_owner.nav_agent.target_position = project_ray_origin


func _calculate_animations() -> void:
	if state_owner.velocity.length() > 0.1:
		state_owner.player_animation.play("Walk")
	else:
		state_owner.player_animation.play("Idle")


func _calculate_velocity(delta: float) -> void:
	var input_direction_3d = (
		(state_owner.nav_agent.get_next_path_position() - state_owner.global_position).normalized()
		if !state_owner.nav_agent.is_navigation_finished()
		else Vector3.ZERO
	)
	input_direction_3d.y = 0.0

	if input_direction_3d != Vector3.ZERO:
		state_owner.velocity = input_direction_3d * state_owner.speed
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
