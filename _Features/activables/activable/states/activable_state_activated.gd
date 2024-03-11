class_name ActivableStateActivated extends ActivableState


func enter(_msg := {}) -> void:
	create_tween().tween_callback(deactivate).set_delay(0.3)


func deactivate() -> void:
	state_machine.transition_to(state_owner.state_deactivated.name)
