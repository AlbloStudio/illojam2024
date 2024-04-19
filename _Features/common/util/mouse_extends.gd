class_name MouseExtends


static func get_mouse_pos_in_floor(event: InputEvent, viewport: Viewport) -> Vector3:
	var camera := viewport.get_camera_3d()
	return camera.project_position(event.position, camera.global_position.y)
