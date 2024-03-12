class_name ActivableStateDeactivated extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(false, state_owner.alternative, state_owner.forbidden)
	set_collision_shape_activation.call_deferred(true)


func exit(_msg := {}) -> void:
	set_collision_shape_activation.call_deferred(false)


func set_collision_shape_activation(activate: bool) -> void:
	state_owner.collision_shape_3d.disabled = activate
