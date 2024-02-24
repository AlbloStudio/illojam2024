class_name ActivableStateVisible extends ActivableState


func enter(_msg := {}) -> void:
	SignalBus.activable_visibled.emit(state_owner.name)
	state_owner.label.make_visible(true)


func _on_activable_body_exited(_body: Node3D) -> void:
	state_machine.transition_to(state_owner.state_idle.name)


func handle_input(event: InputEvent) -> void:
	if event.is_action("player_action"):
		state_machine.transition_to(state_owner.state_activated.name)
