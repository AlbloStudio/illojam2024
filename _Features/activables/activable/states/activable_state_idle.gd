class_name ActivableStateIdle extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(false, state_owner.alternative, state_owner.forbidden)
	state_owner.body_entered.connect(_on_activable_body_entered)


func exit(_msg := {}) -> void:
	state_owner.body_entered.disconnect(_on_activable_body_entered)


func _on_activable_body_entered(_body: Node3D) -> void:
	if _body is Player:
		state_owner.change_current_activable()
		state_machine.transition_to(state_owner.state_visible.name)
