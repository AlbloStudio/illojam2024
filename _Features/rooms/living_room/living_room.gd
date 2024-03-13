class_name LivingRoom extends Node3D

var cloth_names := ["underwear", "pants", "tshirt"]

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
@onready var sofa_activable_lay_up := $Activables/SofaActivableLayUp as Activable
@onready var sofa_activable_lay_up_wall := $Activables/SofaActivableLayUpWall as Activable

@onready var sofa_marker := $Markers/layMarker as Marker3D
@onready var wall_marker := $Markers/wallMarker as Marker3D
@onready var up_marker := $Markers/upMarker as Marker3D


func _ready() -> void:
	closet.visible = false
	closet_handles.visible = false
	clothes.visible = false

	closet_collider.process_mode = Node.PROCESS_MODE_DISABLED


func make_closet_appear() -> void:
	closet.visible = true
	closet_handles.visible = true

	closet_collider.process_mode = Node.PROCESS_MODE_INHERIT

	closet_activable.state_machine.transition_to(closet_activable.state_idle.name)


func make_closet_disappear() -> void:
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
		. set_delay(1)
	)


func get_up_from_chair() -> void:
	(
		create_tween()
		. tween_callback(
			func(): char_activable_sit.state_machine.transition_to(
				char_activable_sit.state_idle.name
			)
		)
		. set_delay(1)
	)


func switch_to_layed_mode() -> void:
	colliders_body.collision_layer = 0
	colliders_layed.collision_layer = 4
	sofa_activable_lay_up.reactivate()
	sofa_activable_lay_up_wall.reactivate()


func switch_to_up_mode() -> void:
	colliders_body.collision_layer = 4
	colliders_layed.collision_layer = 0
	sofa_activable_lay_up.deactivate()
	sofa_activable_lay_up_wall.deactivate()
	sofa_activable_lay_down.reactivate()


func get_layed_position() -> Vector3:
	return sofa_marker.global_position


func get_up_position() -> Vector3:
	return up_marker.global_position


func get_wall_position() -> Vector3:
	return wall_marker.global_position


func get_marker_position(marker_name: String) -> Vector3:
	return get_node("Markers/" + marker_name).global_position
