class_name ActivableStateIdle extends ActivableState


func enter(_msg := {}) -> void:
	SignalBus.activable_idled.emit(state_owner.name)
	state_owner.label.make_visible(false)


func _on_activable_body_entered(_body: Node3D) -> void:
	state_machine.transition_to(state_owner.state_visible.name)
