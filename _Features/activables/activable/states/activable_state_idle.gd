class_name ActivableStateIdle extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(false, state_owner.alternative, state_owner.forbidden)
	state_owner.indicator.visible = true
