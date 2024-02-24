class_name ActivableStateIdle extends ActivableState


func _on_body_entered(_body: Node3D) -> void:
	SignalBus.activable_triggered.emit(name)


func _on_activable_body_entered(body: Node3D) -> void:
	print(body.name)
	state_machine.transition_to(state_owner.state_visible.name)
