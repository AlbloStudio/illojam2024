class_name ActivableStateVisible extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.change_current_activable()
	state_owner.indicator.visible = true
	state_owner.label.make_visible(true, state_owner.alternative, state_owner.forbidden)
	state_owner.activate_lights(true)


func exit() -> void:
	state_owner.activate_lights(false)
	SignalBus.remove_current_activable.emit()
