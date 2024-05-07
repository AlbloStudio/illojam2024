class_name Setup extends Room

@export var get_stuff_to_disappear: Array[Node3D]
@export var glitched_streaming: Array[Node3D]

var activables_while_penetrated := ["WallsUpActivable", "MoveChairActivable"] as Array[String]
var activables_while_normal := (
	[
		"StreamInActivable",
		"StreamOutActivable",
		"StreamInIncorrectActivable",
		"StreamOutInCorrectActivable",
		"ExitWindowActivable",
		"BlindersUpActivable",
		"BlindersDownActivable",
		"WallsUpActivable",
	]
	as Array[String]
)
var activables_while_up := ["JumpDownActivable"] as Array[String]
var activables_while_out := ["EnterWindowActivable"] as Array[String]
var activables_while_streaming_right := ["StreamOutActivable"] as Array[String]
var activables_while_streaming_wrong := ["StreamOutInCorrectActivable"] as Array[String]

@onready var exit_window_activable := $Activables/ExitWindowActivable as Activable
@onready var enter_window_activable := $Activables/EnterWindowActivable as Activable

@onready var move_chair_animation := $MoveChairAnimation as AnimationPlayer

@onready var colliders := $Colliders/StaticBody3D as StaticBody3D
@onready var colliders_up := $CollidersUp/StaticBody3D as StaticBody3D

@onready var blinders := $"Ventana 1" as MeshInstance3D
@onready var setup_ceiling := $SetupCeiling as MeshInstance3D

@onready var tablet := $Tablet as Tablet


func _ready() -> void:
	switch_context(activables_while_normal)


func switch_to_penerated_context() -> void:
	switch_context(activables_while_penetrated)


func switch_to_normal_context() -> void:
	switch_context(activables_while_normal)
	colliders.collision_layer = 4
	colliders_up.collision_layer = 0


func switch_to_upwall_context() -> void:
	switch_context(activables_while_up)
	colliders.collision_layer = 0
	colliders_up.collision_layer = 4


func show_secret_room() -> void:
	setup_ceiling.visible = false
	switch_context(activables_while_out)
	tablet.activate()


func hide_secret_room() -> void:
	setup_ceiling.visible = true
	switch_context(activables_while_normal)
	tablet.deactivate()


func blinders_up() -> void:
	blinders.scale.y = 0.1
	exit_window_activable.forbidden = false
	exit_window_activable.enable_after = [exit_window_activable]


func blinders_down() -> void:
	blinders.scale.y = 1
	exit_window_activable.forbidden = true
	exit_window_activable.enable_after = [enter_window_activable]


func move_chair() -> void:
	move_chair_animation.play("move_chair")


func say_tablet(to_say: Array[String], audio: String, delay: Array[float] = [3.0]) -> void:
	tablet.say(to_say, audio, delay)


func stream_in() -> void:
	switch_context(activables_while_streaming_right)


func stream_out() -> void:
	switch_context(activables_while_normal)


func stream_wrong() -> void:
	switch_context(activables_while_streaming_wrong)


func stream_out_wrong() -> void:
	switch_context(activables_while_normal)


func awake_jump() -> void:
	pass


func awake_stream() -> void:
	pass


func awake_window() -> void:
	pass
