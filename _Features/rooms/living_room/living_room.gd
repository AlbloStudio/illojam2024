class_name LivingRoom extends Node3D

var cloth_names := ["underwear", "pants", "tshirt"]
var poster_awaken := false

@onready var mirror_collider = $MirrorSalonMesh/MirrorCollider as StaticBody3D

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
@onready var sofa_activable_lay_down := $Activables/SofaActivableLayDown as Activable
@onready var sofa_activable_lay_down_wall := $Activables/SofaActivableLayDownWall as Activable
@onready var sofa_activable_lay_up := $Activables/SofaActivableLayUp as Activable
@onready var sofa_activable_lay_up_wall := $Activables/SofaActivableLayUpWall as Activable

@onready var pennywise := $Pennywise as MeshInstance3D
@onready var picture := $Plane_030 as MeshInstance3D

@onready var sofa_marker := $Markers/layMarker as Marker3D
@onready var wall_marker := $Markers/wallMarker as Marker3D
@onready var up_marker := $Markers/upMarker as Marker3D
@onready var up_init_marker := $Markers/layInitMarker as Marker3D
@onready var start_marker := $Markers/startMarker as Marker3D


func _ready() -> void:
	closet.visible = false
	closet_handles.visible = false
	clothes.visible = false
	mirror_collider.get_node("CollisionMirrorShape").disabled = false

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
	mirror_collider.get_node("CollisionMirrorShape").disabled = true
	


func reset_closet() -> void:
	for cloth_name in cloth_names:
		var cloth_activable = get_node(_clothes_path(cloth_name, false)) as Node3D
		cloth_activable.visible = true
	clothes.visible = false
	closet_activable.reactivate()


func make_clothes_appear() -> void:
	clothes.visible = true

	for cloth_name in cloth_names:
		var cloth_activable = get_node(_clothes_path(cloth_name)) as Activable
		cloth_activable.state_machine.transition_to(cloth_activable.state_idle.name)


func make_cloth_disappear(cloth_name: String) -> void:
	get_node(_clothes_path(cloth_name, false)).visible = false

	var clothe_activable = get_node(_clothes_path(cloth_name)) as Activable
	clothe_activable.state_machine.transition_to(clothe_activable.state_deactivated.name)


func destroy_clothes() -> void:
	clothes.queue_free()

	for cloth_name in cloth_names:
		var clothe_activable = get_node(_clothes_path(cloth_name)) as Activable
		clothe_activable.queue_free()


func _clothes_path(cloth: String, with_activable := true) -> String:
	return "Clothes/" + cloth + ("/Activable" if with_activable else "")


func sit_in_chair() -> void:
	(
		create_tween()
		. tween_callback(
			func(): char_activable_getup.state_machine.transition_to(
				char_activable_getup.state_idle.name
			)
		)
		. set_delay(2)
	)


func get_up_from_chair() -> void:
	(
		create_tween()
		. tween_callback(
			func(): char_activable_sit.state_machine.transition_to(
				char_activable_sit.state_idle.name
			)
		)
		. set_delay(2)
	)


func switch_to_layed_mode() -> void:
	colliders_body.collision_layer = 0
	colliders_layed.collision_layer = 4
	sofa_activable_lay_up.reactivate()
	sofa_activable_lay_up_wall.reactivate()
	sofa_activable_lay_down.deactivate()
	sofa_activable_lay_down_wall.deactivate()


func switch_to_up_mode() -> void:
	colliders_body.collision_layer = 4
	colliders_layed.collision_layer = 0
	sofa_activable_lay_up.deactivate()
	sofa_activable_lay_up_wall.deactivate()
	sofa_activable_lay_down.reactivate()
	sofa_activable_lay_down_wall.reactivate()


func switch_to_none_mode() -> void:
	colliders_body.collision_layer = 0
	colliders_layed.collision_layer = 0
	sofa_activable_lay_up.deactivate()
	sofa_activable_lay_up_wall.deactivate()
	sofa_activable_lay_down.deactivate()
	sofa_activable_lay_down_wall.deactivate()


func get_layed_position() -> Vector3:
	return sofa_marker.global_position


func get_up_position() -> Vector3:
	return up_marker.global_position


func get_up_init_position() -> Vector3:
	return up_init_marker.global_position


func get_start_position() -> Vector3:
	return start_marker.global_position


func get_wall_position() -> Vector3:
	return wall_marker.global_position


func get_marker_position(marker_name: String) -> Vector3:
	return get_node("Markers/" + marker_name).global_position


func activate_activable(activable_name: String, delay := 0.0) -> void:
	(
		create_tween()
		. tween_callback(func(): get_node("Activables/" + activable_name).reactivate())
		. set_delay(delay)
	)


func activate_clothe(clothe_name: String, delay := 0.0) -> void:
	(
		create_tween()
		. tween_callback(func(): get_node("Clothes/" + clothe_name + "/Activable").reactivate())
		. set_delay(delay)
	)


func awake_poster() -> void:
	pennywise.visible = true
	picture.global_rotation.z += PI / 2.4


func awake_sit() -> void:
	pass


func awake_sofa() -> void:
	pass


func awake_clothes() -> void:
	pass
