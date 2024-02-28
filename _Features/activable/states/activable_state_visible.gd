class_name ActivableStateVisible extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(true)
	state_owner.body_exited.connect(_on_activable_body_exited)


func exit(_msg := {}) -> void:
	state_owner.body_exited.disconnect(_on_activable_body_exited)


func _on_activable_body_exited(_body: Node3D) -> void:
	if state_machine.is_in_state([name]):
		state_machine.transition_to(state_owner.state_idle.name)


func handle_input(event: InputEvent) -> void:
	if event.is_action("player_action"):
		state_machine.transition_to(state_owner.state_activated.name)
