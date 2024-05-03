class_name Awake extends Node

var in_process: Array[AwakeInProcess]


func _process(delta):
	for awake_in_process in in_process:
		awake_in_process.emit_if_completed(delta)


func _create_timer(time: float) -> void:
	await get_tree().create_timer(time).timeout


func start_distorsion(
	nodes: Array[Node3D],
	material: Material = null,
	translation:= Vector3.ZERO,
	rotation:= Vector3.ZERO,
	time_on := Vector2(1.0, 10.0),
	time_off := Vector2(20.0, 30.0),
	delay := 6.0
) -> void:
	await _create_timer(delay)
	in_process.append(AwakeInProcess.new(nodes, time_on, time_off, translation, rotation, material))


# func appear_on_and_off(
# 	nodes: Array[Node3D], time_on: Vector2, time_of: Vector2, delay := 0.0
# ) -> void:
# 	await _create_timer(delay)

# 	for node: Node3D in nodes:
# 		node.show()
# 		var time_on_rand := randf_range(time_on.x, time_on.y)
# 		await _create_timer(time_on_rand)
# 		node.hide()
# 		var time_of_rand := randf_range(time_of.x, time_of.y)
# 		await _create_timer(time_of_rand)


# func turn_off_lights(world_environment: WorldEnvironment) -> void:
# 	var all_lights = find_children("*", "Light3D")

# 	await _create_timer(4)

# 	world_environment.environment.background_color = Color.BLACK

# 	for light in all_lights:
# 		light.visible = false

# 	await _create_timer(2)

# 	world_environment.environment.background_color = Color(0.2, 0.2, 0.2)

# 	for light in all_lights:
# 		light.visible = true


# func spawn_something(scene: PackedScene, parent: Node3D, delay := 0.0, time_on := 2.0) -> void:
# 	await _create_timer(delay)

# 	var instance = scene.instance()
# 	parent.add_child(instance)
# 	instance.show()

# 	await _create_timer(time_on)
# 	instance.hide()
