class_name AwakeInProcess

signal switched(awake_in_process: AwakeInProcess)

var nodes: Array[Node3D]
var time_on_range: Vector2
var time_off_range: Vector2
var time_to_switch: float
var status := false
var time_passed := 0.0
var material: Material
var translation: Vector3
var rotation: Vector3


func _init(
	_nodes: Array[Node3D],
	_time_on_range: Vector2,
	_time_off_range: Vector2,
	_translation := Vector3.ZERO,
	_rotation := Vector3.ZERO,
	_material: Material = null
) -> void:
	self.nodes = _nodes
	self.time_on_range = _time_on_range
	self.time_off_range = _time_off_range
	self.translation = _translation
	self.material = _material
	_switch_status()


func _execute_switch() -> void:
	for node in nodes:
		if status:
			node.translate(translation)
			node.rotation_degrees += rotation
			if node is GeometryInstance3D:
				node.material_override = material
		else:
			node.translate(-translation)
			node.rotation_degrees -= rotation
			if node is GeometryInstance3D:
				node.material_override = null


func _switch_status() -> void:
	status = !status
	_execute_switch()
	switched.emit(self)

	time_passed = 0.0
	time_to_switch = (
		randf_range(time_on_range.x, time_on_range.y)
		if status
		else randf_range(time_off_range.x, time_off_range.y)
	)


func emit_if_completed(delta: float) -> void:
	time_passed += delta
	if time_passed >= time_to_switch:
		_switch_status()
