class_name ActivableStateVisible extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(true)


func _on_activable_body_exited(_body: Node3D) -> void:
	SignalBus.activable_idled.emit(name)
	state_machine.transition_to(state_owner.state_idle.name)
