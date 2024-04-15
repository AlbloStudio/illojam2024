class_name ActivableStateDeactivated extends ActivableState


func enter(msg := {}) -> void:
	state_owner.label.make_visible(false, state_owner.alternative, state_owner.forbidden)
	_set_collision_shape_activation.call_deferred(true)
	state_owner.indicator.visible = false

	if msg == {"init": false}:
		if !state_owner.alternative:
			_enable_after()
			_deactivate_after()
		else:
			_alternative_enable_after()
			_alternative_deactivate_after()

	if state_owner.destroy_after_activation:
		state_owner.queue_free()


func exit(_msg := {}) -> void:
	_set_collision_shape_activation.call_deferred(false)

	var overlapping_bodies = state_owner.indicator_trigger.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		state_owner.indicator.visible = true


func _set_collision_shape_activation(activate: bool) -> void:
	state_owner.collision_shape_3d.disabled = activate


func _enable_after() -> void:
	_switch_after("reactivate", state_owner.enable_after, state_owner.enable_after_seconds)


func _deactivate_after() -> void:
	_switch_after("deactivate", state_owner.deactivate_after, state_owner.deactivate_after_seconds)


func _alternative_enable_after() -> void:
	_switch_after(
		"reactivate",
		state_owner.alternative_enable_after,
		state_owner.alternative_enable_after_seconds
	)


func _alternative_deactivate_after() -> void:
	_switch_after(
		"deactivate",
		state_owner.alternative_deactivate_after,
		state_owner.alternative_deactivate_after_seconds
	)


func _switch_after(
	function_name: String, activables: Array[Activable], after_seconds: float
) -> void:
	for activable in activables:
		var function = func(): activable.deactivate({})
		if function_name == "reactivate":
			function = func(): activable.reactivate()

		create_tween().tween_callback(function).set_delay(after_seconds)
