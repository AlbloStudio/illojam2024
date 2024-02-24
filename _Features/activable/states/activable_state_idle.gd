class_name ActivableStateIdle extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(false)


func _on_activable_body_entered(_body: Node3D) -> void:
	SignalBus.activable_visibled.emit(name)
	state_machine.transition_to(state_owner.state_visible.name)
