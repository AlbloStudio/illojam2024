class_name ActivableStateDeactivated extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(false)
	state_owner.collision_shape_3d.disabled = true


func exit(_msg := {}) -> void:
	state_owner.collision_shape_3d.disabled = false
