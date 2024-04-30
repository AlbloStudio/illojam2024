class_name ActivableAnimations extends AnimationPlayer

signal do_the_shake
signal stop_shaking

var is_forbidding = false
var time_forbidding = 0.5
var forbid_counter = 0.0
var forbid_frequency = 0.05


func _process(delta: float) -> void:
	if is_forbidding:
		forbid_counter += delta
		forbid_frequency -= delta

		if forbid_frequency <= 0.0:
			do_the_shake.emit()
			forbid_frequency = 0.05

		if forbid_counter >= time_forbidding:
			is_forbidding = false
			forbid_counter = 0.0
			stop_shaking.emit()


func play_forbidden() -> void:
	is_forbidding = true
