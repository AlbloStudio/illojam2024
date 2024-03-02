class_name ActivableStateDeactivated extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(false)
