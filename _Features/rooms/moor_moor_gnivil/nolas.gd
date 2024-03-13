class_name Nolas extends Node


func get_marker_position(marker_name: String) -> Vector3:
	return get_node("Markers/" + marker_name).global_position
