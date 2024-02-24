class_name ActivableStateIdle extends ActivableState


func enter(_msg := {}) -> void:
	SignalBus.activable_idled.emit(state_owner.name)
	state_owner.label.make_visible(false)
	state_owner.body_entered.connect(_on_activable_body_entered)


func exit(_msg := {}) -> void:
	state_owner.body_entered.disconnect(_on_activable_body_entered)


func _on_activable_body_entered(_body: Node3D) -> void:
	if state_machine.is_in_state([name]):
		state_machine.transition_to(state_owner.state_visible.name)
