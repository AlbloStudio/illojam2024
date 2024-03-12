class_name Setup extends Node3D

@onready var stream_pos := $StreamMarker as Marker3D
@onready var stream_out_pos := $StreamOutMarker as Marker3D
@onready var stream_wrong_pos := $StreamWrongMarker as Marker3D
@onready var walls_up_marker := $WallsUpMarker as Marker3D
@onready var walls_down_marker := $WallsDownMarker as Marker3D
@onready var penetration_marker := $PenetrationMarker as Marker3D

@onready var stream_in_activable := $Activables/StreamInActivable as Activable
@onready var stream_out_activable := $Activables/StreamOutActivable as Activable
@onready var stream_in_incorrect_activable := $Activables/StreamInIncorrectActivable as Activable
@onready var stream_out_incorrect_activable := $Activables/StreamOutInCorrectActivable as Activable
@onready var walls_up_activable := $Activables/WallsUpActivable as Activable
@onready var exit_window_activable := $Activables/ExitWindowActivable as Activable
@onready var blinders_up_activable := $Activables/BlindersUpActivable as Activable
@onready var blinders_down_activable := $Activables/BlindersDownActivable as Activable
@onready var jump_down_activable := $Activables/JumpDownActivable as Activable
@onready var move_chair_activable := $Activables/MoveChairActivable as Activable

@onready var move_chair_animation := $MoveChairAnimation as AnimationPlayer

@onready var colliders := $Colliders/StaticBody3D as StaticBody3D
@onready var colliders_up := $CollidersUp/StaticBody3D as StaticBody3D


func get_stream_position() -> Vector3:
	return stream_pos.global_position


func get_stream_out_position() -> Vector3:
	return stream_out_pos.global_position


func get_stream_position_wrong() -> Vector3:
	return stream_wrong_pos.global_position


func get_walls_up_position() -> Vector3:
	return walls_up_marker.global_position


func get_penetration_position() -> Vector3:
	return penetration_marker.global_position


func get_walls_down_position() -> Vector3:
	return walls_down_marker.global_position


func activate_stream_out_activable() -> void:
	stream_out_activable.reactivate()


func activate_stream_in_activable() -> void:
	stream_in_activable.reactivate()


func activate_stream_out_wrong_activable() -> void:
	stream_out_incorrect_activable.reactivate()


func activate_stream_in_wrong_activable() -> void:
	stream_in_incorrect_activable.reactivate()


func activate_touch_wall_activable() -> void:
	walls_up_activable.reactivate()


func activate_blinders_down_activable() -> void:
	blinders_down_activable.reactivate()


func activate_blinders_up_activable() -> void:
	blinders_up_activable.reactivate()


func activate_jump_down_activable() -> void:
	jump_down_activable.reactivate()


func allow_exit_window() -> void:
	exit_window_activable.forbidden = false


func forbid_exit_window() -> void:
	exit_window_activable.forbidden = true


func switch_to_up_mode() -> void:
	colliders.collision_layer = 0
	colliders_up.collision_layer = 4
	jump_down_activable.reactivate()


func switch_to_normal_mode() -> void:
	colliders.collision_layer = 4
	colliders_up.collision_layer = 0
	activate_touch_wall_activable()


func move_chair() -> void:
	move_chair_animation.play("move_chair")


func activate_wrong_streams() -> void:
	stream_in_activable.deactivate()
	stream_out_activable.deactivate()
	stream_in_incorrect_activable.reactivate()
	stream_out_incorrect_activable.reactivate()
