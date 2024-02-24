class_name ActivableLabel extends Node


func make_visible(visible: bool = false, time: float = 0.1) -> void:
	var color_tween = create_tween()
	color_tween.tween_property(
		self, "modulate", Color.WHITE if visible else Color.TRANSPARENT, time
	)
