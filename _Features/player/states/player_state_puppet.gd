class_name PlayerStatePuppet extends PlayerState


func enter(_msg := {}) -> void:
	create_tween().tween_callback(_back_to_controlled).set_delay(1)


func _back_to_controlled() -> void:
	state_machine.transition_to(state_owner.state_controlled.name)
