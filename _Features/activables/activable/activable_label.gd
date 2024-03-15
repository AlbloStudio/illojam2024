class_name ActivableLabel extends Node


func make_visible(
	is_visible: bool, is_alternative := false, is_forbidden := false, time: float = 0.1
) -> void:
	var color := get_color(is_visible, is_alternative, is_forbidden)

	var color_tween = create_tween()
	if color_tween != null:
		color_tween.tween_property(self, "modulate", color, time)


func get_color(is_visible: bool, is_alternative: bool, is_forbidden: bool) -> Color:
	var a := 1 if is_visible else 0

	var color := Color(1.0, 1.0, 1.0, a)
	if is_alternative:
		color = Color(Color.LIGHT_SALMON.r, Color.LIGHT_SALMON.g, Color.LIGHT_SALMON.b, a)
	elif is_forbidden:
		color = Color(0.7, 0.7, 0.7, a)

	return color
