class_name Vector2Extends


static func clamp_vector2(value: Vector2, min_value: Vector2, max_value: Vector2) -> Vector2:
	var x := clampf(value.x, min_value.x, max_value.x)
	var y := clampf(value.y, min_value.y, max_value.y)

	return Vector2(x, y)
