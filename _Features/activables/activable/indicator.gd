extends Node3D

var original_pos: Vector3
var time_passed := 0.0

@onready var indicator_mesh := $IndicatorMesh as MeshInstance3D


func _ready() -> void:
	original_pos = indicator_mesh.global_position


func _process(delta: float) -> void:
	time_passed += delta
	indicator_mesh.global_position.z = original_pos.z + sin(time_passed * 20) * 0.03
