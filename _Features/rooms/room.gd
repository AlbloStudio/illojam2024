class_name Room extends Node3D

@onready var activables := $Activables as Node3D


func switch_context(context_array_to_use: Array[String]) -> void:
	for activable in activables.get_children():
		if context_array_to_use.has(activable.name):
			activable.is_in_context = true
			print("Activating", activable.name)
		else:
			activable.is_in_context = false
			print("Deactivating", activable.name)


func enable_activable(activable_name: String, delay := 0.0) -> void:
	var activable_node = get_node_or_null("Activables/" + activable_name)
	if activable_node == null:
		return

	create_tween().tween_callback(func(): activable_node.reactivate()).set_delay(delay)


func deenable_activable(activable_name: String, delay := 0.0, forever := false) -> void:
	var activable_node = get_node_or_null("Activables/" + activable_name)
	if activable_node == null:
		return

	var just_deactivate = func(): activable_node.deactivate()
	var destroy = func(): activable_node.deactivate_forever()
	create_tween().tween_callback(destroy if forever else just_deactivate).set_delay(delay)


func get_marker_position(marker_name: String) -> Vector3:
	return get_node("Markers/" + marker_name).global_position
