class_name ActivableStateActivated extends ActivableState


func enter(_msg := {}) -> void:
	var initial_point = (
		state_owner.alternative_initial_point
		if state_owner.alternative
		else state_owner.initial_point
	)

	SignalBus.activable_activated.emit(
		state_owner.activable_name, state_owner.alternative, initial_point
	)

	SignalBus.activable_activated.emit(state_owner.activable_name, state_owner.alternative)

	create_tween().tween_callback(deactivate).set_delay(0.3)


func deactivate() -> void:
	state_machine.transition_to(state_owner.state_deactivated.name, {"init": false})
