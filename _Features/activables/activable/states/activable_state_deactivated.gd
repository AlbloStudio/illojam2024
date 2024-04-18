class_name ActivableStateDeactivated extends ActivableState


func enter(msg := {}) -> void:
	state_owner.label.make_visible(false, state_owner.alternative, state_owner.forbidden)
	_set_collision_shape_activation.call_deferred(true)
	state_owner.indicator.visible = false

	await _after(msg)
	after_destroy()


func exit(_msg := {}) -> void:
	_set_collision_shape_activation.call_deferred(false)


func _after(msg := {}) -> void:
	if msg != {"init": false}:
		return

	if !state_owner.alternative:
		await _enable_after()
		await _deactivate_after()
	else:
		await _alternative_enable_after()
		await _alternative_deactivate_after()


func after_destroy() -> void:
	if !state_owner.alternative:
		if state_owner.destroy_after_activation:
			state_owner.queue_free()
	else:
		if state_owner.alternative_destroy_after_activation:
			state_owner.queue_free()


func _set_collision_shape_activation(activate: bool) -> void:
	state_owner.collision_shape_3d.disabled = activate


func _enable_after() -> void:
	await _switch_after("reactivate", state_owner.enable_after, state_owner.enable_after_seconds)


func _deactivate_after() -> void:
	await _switch_after(
		"deactivate", state_owner.deactivate_after, state_owner.deactivate_after_seconds
	)


func _alternative_enable_after() -> void:
	await _switch_after(
		"reactivate",
		state_owner.alternative_enable_after,
		state_owner.alternative_enable_after_seconds
	)


func _alternative_deactivate_after() -> void:
	await _switch_after(
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

		await get_tree().create_timer(after_seconds).timeout
		function.call()
