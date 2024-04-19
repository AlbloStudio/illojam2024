class_name ActivableStateIdle extends ActivableState


func enter(_msg := {}) -> void:
	state_owner.label.make_visible(false, state_owner.alternative, state_owner.forbidden)
	state_owner.indicator.visible = true


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var cursor_placement := MouseExtends.get_mouse_pos_in_floor(event, get_viewport())
		var distance_from_indicator = cursor_placement.distance_to(
			state_owner.indicator.global_position
		)

		var transparency = (
			1
			- (
				maxf(0.0, state_owner.transparency_distance - distance_from_indicator)
				/ state_owner.transparency_distance
			)
		)
		state_owner.indicator_mesh.transparency = transparency
