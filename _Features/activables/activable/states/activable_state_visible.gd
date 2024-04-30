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
	state_owner.change_current_activable()
	state_owner.indicator.visible = true
	state_owner.label.make_visible(true, state_owner.alternative, state_owner.forbidden)
	times_pressed = 0
	state_owner.activate_lights(true)


func exit() -> void:
	state_owner.activate_lights(false)


func update(delta: float) -> void:
	if !state_owner.is_in_context:
		return

	if is_pressing:
		time_pressing += delta
		if time_pressing >= state_owner.time_to_alternate:
			state_owner.alternative = !state_owner.alternative
			is_alternative_set = true
			time_pressing = 0.0

			state_owner.alternative_game_feel()


func handle_input(event: InputEvent) -> void:
	if !state_owner.is_in_context:
		return

	# This will be moved to player and checked if the player is controlled
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
		SignalBus.should_activate.emit(state_owner)
	elif state_owner.forbidden:
		state_owner.forbidden_game_feel()
