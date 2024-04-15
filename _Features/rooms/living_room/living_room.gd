class_name LivingRoom extends Room

var cloth_names := ["underwear", "pants", "tshirt"]
var poster_awaken := false

@onready var closet := $Closet_001 as MeshInstance3D

@onready var closet_handles := $Cube_005 as MeshInstance3D
@onready var closet_collider := $Closet_001/StaticBody3D as StaticBody3D
@onready var closet_activable := $Activables/ClosetActivable as Activable

@onready var clothes := $Clothes as Node3D

@onready var char_activable_sit := $Activables/ChairActivableSit as Activable
@onready var char_activable_getup := $Activables/ChairActivableGetUp as Activable

@onready var colliders := $Colliders as Node3D
@onready var colliders_body := $Colliders/StaticBody3D as StaticBody3D
@onready var colliders_layed := $CollidersLayed/StaticBody3D as StaticBody3D

@onready var pennywise := $Pennywise as MeshInstance3D
@onready var picture := $Plane_030 as MeshInstance3D
@onready var sofa01 := $Plane_002 as MeshInstance3D
@onready var sofa02 := $Plane_011 as MeshInstance3D
@onready var sofa03 := $Plane_023 as MeshInstance3D
@onready var sofa04 := $Plane_022 as MeshInstance3D
@onready var sofa05 := $Plane_017 as MeshInstance3D


func _ready() -> void:
	closet.visible = false
	closet_handles.visible = false
	clothes.visible = false

	closet_collider.process_mode = Node.PROCESS_MODE_DISABLED


func make_closet_appear() -> void:
	closet.transparency = 1
	closet_handles.transparency = 1
	closet.visible = true
	closet_handles.visible = true
	create_tween().tween_property(closet, "transparency", 0, 0.3)
	create_tween().tween_property(closet_handles, "transparency", 0, 0.3)

	closet_collider.process_mode = Node.PROCESS_MODE_INHERIT

	closet_activable.state_machine.transition_to(closet_activable.state_idle.name)


func make_closet_disappear() -> void:
	var tww = create_tween()
	tww.set_parallel(true)
	tww.finished.connect(on_closet_disappeared, CONNECT_ONE_SHOT)
	tww.tween_property(closet, "transparency", 1, 0.3)
	tww.tween_property(closet_handles, "transparency", 1, 0.3)


func on_closet_disappeared() -> void:
	closet.queue_free()
	closet_handles.queue_free()
	closet_activable.queue_free()


func reset_closet() -> void:
	for cloth_name in cloth_names:
		var cloth_activable = get_node(_clothes_path(cloth_name, false)) as Node3D
		cloth_activable.visible = true
	clothes.visible = false
	closet_activable.reactivate()


func make_clothes_appear() -> void:
	clothes.visible = true


func make_cloth_disappear(cloth_name: String) -> void:
	get_node(_clothes_path(cloth_name, false)).visible = false


func destroy_clothes() -> void:
	clothes.queue_free()

	for cloth_name in cloth_names:
		var clothe_activable = get_node(_clothes_path(cloth_name)) as Activable
		clothe_activable.queue_free()


func _clothes_path(cloth: String, with_activable := true) -> String:
	return "Clothes/" + cloth + ("/Activable" if with_activable else "")


func switch_to_layed_mode() -> void:
	colliders_body.collision_layer = 0
	colliders_layed.collision_layer = 4


func switch_to_up_mode() -> void:
	colliders_body.collision_layer = 4
	colliders_layed.collision_layer = 0


func switch_to_none_mode() -> void:
	colliders_body.collision_layer = 0
	colliders_layed.collision_layer = 0


func activate_clothe(clothe_name: String, delay := 0.0) -> void:
	(
		create_tween()
		. tween_callback(func(): get_node("Clothes/" + clothe_name + "/Activable").reactivate())
		. set_delay(delay)
	)


func awake_poster() -> void:
	pennywise.visible = true


func awake_sit() -> void:
	pass


func awake_sofa() -> void:
	pass


func awake_clothes() -> void:
	pass


func get_new_rotation_vector() -> Vector3:
	var x = randf_range(-2 * PI, 2 * PI)
	var y = randf_range(-2 * PI, 2 * PI)
	var z = randf_range(-2 * PI, 2 * PI)

	return Vector3(x, y, z)


func rotate_sofa() -> void:
	var rotation_tween = create_tween()
	rotation_tween.set_parallel(true)
	rotation_tween.set_ease(Tween.EASE_IN_OUT)

	rotation_tween.tween_property(sofa01, "global_rotation", get_new_rotation_vector(), 1.0)
	rotation_tween.tween_property(sofa02, "global_rotation", get_new_rotation_vector(), 1.0)
	rotation_tween.tween_property(sofa03, "global_rotation", get_new_rotation_vector(), 1.0)
	rotation_tween.tween_property(sofa04, "global_rotation", get_new_rotation_vector(), 1.0)
	rotation_tween.tween_property(sofa05, "global_rotation", get_new_rotation_vector(), 1.0)

	create_tween().tween_callback(return_sofa).set_delay(4.0)


func return_sofa() -> void:
	var rotation_tween = create_tween()
	rotation_tween.set_parallel(true)
	rotation_tween.set_ease(Tween.EASE_IN_OUT)

	rotation_tween.tween_property(sofa01, "global_rotation", Vector3.ZERO, 0.4)
	rotation_tween.tween_property(sofa02, "global_rotation", Vector3.ZERO, 0.4)
	rotation_tween.tween_property(sofa03, "global_rotation", Vector3.ZERO, 0.4)
	rotation_tween.tween_property(sofa04, "global_rotation", Vector3.ZERO, 0.4)
	rotation_tween.tween_property(sofa05, "global_rotation", Vector3.ZERO, 0.4)

	create_tween().tween_callback(func(): SignalBus.awaked.emit("rotation")).set_delay(0.5)
