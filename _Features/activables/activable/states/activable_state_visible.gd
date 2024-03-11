class_name ActivableStateVisible extends ActivableState

var times_pressed := 0
var time_pressing := 0.0
var is_alternative_set := false
var is_pressing: bool:
	get:
		return is_pressing
	set(value):
		is_pressing = value
		if value == false:
			time_pressing = 0.0


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(true, state_owner.alternative, state_owner.forbidden)
	state_owner.body_exited.connect(_on_activable_body_exited)
	times_pressed = 0


func update(delta: float) -> void:
	if is_pressing:
		time_pressing += delta
		if time_pressing >= state_owner.time_to_alternate:
			state_owner.alternative = !state_owner.alternative
			is_alternative_set = true
			time_pressing = 0.0


func exit(_msg := {}) -> void:
	state_owner.body_exited.disconnect(_on_activable_body_exited)


func _on_activable_body_exited(_body: Node3D) -> void:
	if state_machine.is_in_state([name]):
		state_machine.transition_to(state_owner.state_idle.name)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_action"):
		is_pressing = true
	elif event.is_action_released("player_action"):
		is_pressing = false

		if is_alternative_set:
			is_alternative_set = false
		else:
			times_pressed += 1
			_check_should_activate()


func _check_should_activate() -> void:
	var should_transition: bool = (
		!state_owner.forbidden || times_pressed >= state_owner.times_to_unforbid
	)

	if should_transition:
		SignalBus.activable_activated.emit(state_owner.activable_name, state_owner.alternative)
