class_name PlayerStateControlled extends PlayerState


func enter(_msg := {}) -> void:
	SignalBus.activable_activated.connect(_activable_activated)


func exit() -> void:
	SignalBus.activable_activated.disconnect(_activable_activated)


func physics_update(delta: float) -> void:
	_calculate_velocity(delta)

	state_owner.move_and_slide()


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


func _activable_activated(activable_name: String) -> void:
	match activable_name:
		"Tablet":
			_tablet()


func _tablet() -> void:
	state_machine.transition_to(state_owner.state_puppet.name)
	SignalBus.tablet_opened.emit()
