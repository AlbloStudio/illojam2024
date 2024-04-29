class_name ActivableLabel extends MeshInstance3D


func get_material() -> ShaderMaterial:
	return mesh.surface_get_material(0)


func make_visible(
	should_be_visible: bool, is_alternative := false, is_forbidden := false, time: float = 0.1
) -> void:
	var color := get_color(should_be_visible, is_alternative, is_forbidden)

	var color_tween = create_tween()
	if color_tween != null:
		var the_material = get_material()
		var current_color = the_material.get_shader_parameter("albedo")
		color_tween.tween_method(set_color, current_color, color, time)


func get_color(should_be_visible: bool, is_alternative: bool, is_forbidden: bool) -> Color:
	var a := 1 if should_be_visible else 0

	var color := Color(1.0, 1.0, 0.741176, a)
	if is_alternative:
		color = Color(Color.LIGHT_SALMON.r, Color.LIGHT_SALMON.g, Color.LIGHT_SALMON.b, a)
	elif is_forbidden:
		color = Color(0.7, 0.7, 0.7, a)

	return color


func set_color(color: Color) -> void:
	var the_material = get_material()
	the_material.set_shader_parameter("emission", color)
	the_material.set_shader_parameter("albedo", color)


func set_current_color(should_be_visible := true, alternative := false, forbidden := false) -> void:
	set_color(get_color(should_be_visible, alternative, forbidden))


func set_text(text: String) -> void:
	var text_mesh = mesh as TextMesh
	text_mesh.text = text
