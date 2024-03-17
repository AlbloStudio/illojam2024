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
@onready var walls_up_activable := $WallsUpActivable as Activable
@onready var exit_window_activable := $Activables/ExitWindowActivable as Activable
@onready var enter_window_activable := $Activables/EnterWindowActivable as Activable
@onready var blinders_up_activable := $Activables/BlindersUpActivable as Activable
@onready var blinders_down_activable := $Activables/BlindersDownActivable as Activable
@onready var jump_down_activable := $Activables/JumpDownActivable as Activable
@onready var move_chair_activable := $ActivablesPenetrated/MoveChairActivable as Activable
@onready var activables := $Activables as Node3D
@onready var activables_penetrated := $ActivablesPenetrated as Node3D

@onready var move_chair_animation := $MoveChairAnimation as AnimationPlayer

@onready var colliders := $Colliders/StaticBody3D as StaticBody3D
@onready var colliders_up := $CollidersUp/StaticBody3D as StaticBody3D

@onready var blinders := $"Ventana 1" as MeshInstance3D
@onready var setup_ceiling := $SetupCeiling as MeshInstance3D


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


func switch_to_penetration() -> void:
	activables_penetrated.process_mode = Node.PROCESS_MODE_INHERIT
	activables.process_mode = Node.PROCESS_MODE_DISABLED


func switch_to_normal() -> void:
	activables_penetrated.process_mode = Node.PROCESS_MODE_DISABLED
	activables.process_mode = Node.PROCESS_MODE_INHERIT


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


func activate_exit_window_activable() -> void:
	exit_window_activable.reactivate()


func activate_enter_window_activable() -> void:
	enter_window_activable.reactivate()


func allow_exit_window() -> void:
	exit_window_activable.forbidden = false


func forbid_exit_window() -> void:
	exit_window_activable.forbidden = true


func show_secret_room() -> void:
	setup_ceiling.visible = false


func hide_secret_room() -> void:
	setup_ceiling.visible = true


func blinders_up() -> void:
	blinders.scale.y = 0.1

func blinders_down() -> void:
	blinders.scale.y = 1


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


func awake_wall() -> void:
	pass


func awake_jump() -> void:
	pass


func awake_stream() -> void:
	pass


func awake_window() -> void:
	pass


func activate_activable(activable_name: String, delay := 0.0) -> void:
	(
		create_tween()
		. tween_callback(func(): get_node("Activables/" + activable_name).reactivate())
		. set_delay(delay)
	)


func activate_penetrated_activable(activable_name: String, delay := 0.0) -> void:
	(
		create_tween()
		. tween_callback(func(): get_node("ActivablesPenetrated/" + activable_name).reactivate())
		. set_delay(delay)
	)
