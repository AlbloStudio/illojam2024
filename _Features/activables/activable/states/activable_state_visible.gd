class_name ActivableStateVisible extends ActivableState

var times_pressed = 0


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(true, state_owner.alternative, state_owner.forbidden)
	state_owner.body_exited.connect(_on_activable_body_exited)
	times_pressed = 0


func exit(_msg := {}) -> void:
	state_owner.body_exited.disconnect(_on_activable_body_exited)


func _on_activable_body_exited(_body: Node3D) -> void:
	if state_machine.is_in_state([name]):
		state_machine.transition_to(state_owner.state_idle.name)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_action"):
		times_pressed += 1
		var should_transition: bool = (
			!state_owner.forbidden || times_pressed >= state_owner.times_to_unforbid
		)
		if should_transition:
			state_machine.transition_to(state_owner.state_activated.name)
