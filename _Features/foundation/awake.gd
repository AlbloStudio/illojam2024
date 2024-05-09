class_name Awake extends Node

var in_process: Array[AwakeInProcess]

@export var world_environment: WorldEnvironment


func _process(delta):
	for awake_in_process in in_process:
		awake_in_process.emit_if_completed(delta)


func _create_timer(time: float) -> void:
	await get_tree().create_timer(time).timeout


func start_transform_distorsion(
	nodes: Array[Node3D],
	translation := Vector3.ZERO,
	rotation := Vector3.ZERO,
	time_on := Vector2(1.0, 10.0),
	time_off := Vector2(20.0, 30.0),
	delay := 6.0
) -> void:
	await _create_timer(delay)
	in_process.append(AwakeInProcess.new(nodes, time_on, time_off, translation, rotation))


func start_material_distorsion(
	nodes: Array[Node3D],
	material: Material,
	time_on := Vector2(1.0, 10.0),
	time_off := Vector2(20.0, 30.0),
	delay := 6.0
) -> void:
	await _create_timer(delay)
	in_process.append(
		AwakeInProcess.new(nodes, time_on, time_off, Vector3.ZERO, Vector3.ZERO, material)
	)


func start_visibility_distorsion(
	nodes: Array[Node3D],
	time_on := Vector2(1.0, 10.0),
	time_off := Vector2(20.0, 30.0),
	delay := 6.0
) -> void:
	await _create_timer(delay)
	in_process.append(
		AwakeInProcess.new(nodes, time_on, time_off, Vector3.ZERO, Vector3.ZERO, null, true)
	)


func turn_off_lights(mirror_effect: Node3D) -> void:
	await _create_timer(8)

	var all_lights = get_parent().find_children("*", "Light3D")
	var light_states = {}

	world_environment.environment.background_color = Color.BLACK
	world_environment.environment.fog_enabled = false
	mirror_effect.visible = false

	for light in all_lights:
		light_states[light] = light.visible
		light.visible = false

	await _create_timer(7)

	world_environment.environment.background_color = Color(0.2, 0.2, 0.2)
	world_environment.environment.fog_enabled = true
	mirror_effect.visible = true

	for light in all_lights:
		light.visible = light_states[light]


func spawn_something(scene: PackedScene, parent: Node3D, delay := 0.0) -> void:
	await _create_timer(delay)

	var instance = scene.instantiate()
	parent.add_child(instance)
