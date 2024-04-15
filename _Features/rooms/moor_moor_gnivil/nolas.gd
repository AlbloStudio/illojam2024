class_name Nolas extends Room

@onready var closet := $Closet_001 as MeshInstance3D
@onready var closet_handles := $Cube_005 as MeshInstance3D


func _ready() -> void:
	closet.visible = false
	closet_handles.visible = false


func get_marker_position(marker_name: String) -> Vector3:
	return get_node("Markers/" + marker_name).global_position


func make_closet_appear() -> void:
	closet.visible = true
	closet_handles.visible = true


func make_closet_disappear() -> void:
	closet.queue_free()
	closet_handles.queue_free()
