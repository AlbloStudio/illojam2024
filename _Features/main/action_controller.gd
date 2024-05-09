class_name ActionController extends Node

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
var can_press = true
var current_activable: Activable = null:
	set(value):
		current_activable = value
		times_pressed = 0


func _process(delta: float) -> void:
	if current_activable == null || !current_activable.is_in_context:
			is_pressing = false
			return

	if is_pressing:
		time_pressing += delta
		if time_pressing >= current_activable.time_to_alternate:
			is_alternative_set = true
			time_pressing = 0.0
			current_activable.alternative_game_feel()


func _unhandled_input(event):
	if can_press && current_activable != null && current_activable.is_in_context:
		if event.is_action_pressed("player_action"):
			is_pressing = true
			current_activable.progress_audio.play()
		if event.is_action_released("player_action"):
			current_activable.progress_audio.stop()
			is_pressing = false

			if is_alternative_set:
				is_alternative_set = false
			else:
				times_pressed += 1
				current_activable.check_should_activate(times_pressed)
