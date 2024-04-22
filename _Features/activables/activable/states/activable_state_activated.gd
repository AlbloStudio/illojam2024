class_name ActivableStateActivated extends ActivableState


func enter(_msg := {}) -> void:
	SignalBus.activable_activated_done.connect(deactivate, CONNECT_ONE_SHOT)

	var initial_point = (
		state_owner.alternative_initial_point
		if state_owner.alternative
		else state_owner.initial_point
	)

	SignalBus.activable_activated.emit(
		state_owner.activable_name, state_owner.alternative, initial_point
	)


func deactivate(activable_name: String) -> void:
	if activable_name != state_owner.activable_name:
		return

	(
		create_tween()
		. tween_callback(
			func(): state_machine.transition_to(state_owner.state_deactivated.name, {"init": false})
		)
		. set_delay(0.3)
	)
