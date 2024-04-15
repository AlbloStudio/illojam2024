class_name Setup extends Room

var recently_deactivated_activables := [] as Array[Activable]

var activables_while_penetrated := ["WallsUpActivable", "MoveChairActivable"] as Array[String]
var activables_while_normal := (
	[
		"StreamInActivable",
		"StreamOutActivable",
		"StreamInIncorrectActivable",
		"StreamOutInCorrectActivable",
		"ExitWindowActivable",
		"EnterWindowActivable",
		"BlindersUpActivable",
		"BlindersDownActivable",
		"WallsUpActivable",
	]
	as Array[String]
)
var activables_while_up := ["JumpDownActivable"] as Array[String]

@onready var exit_window_activable := $Activables/ExitWindowActivable as Activable

@onready var move_chair_animation := $MoveChairAnimation as AnimationPlayer

@onready var colliders := $Colliders/StaticBody3D as StaticBody3D
@onready var colliders_up := $CollidersUp/StaticBody3D as StaticBody3D

@onready var blinders := $"Ventana 1" as MeshInstance3D
@onready var setup_ceiling := $SetupCeiling as MeshInstance3D


func _ready() -> void:
	switch_context(activables_while_normal)


func switch_to_penerated_context() -> void:
	switch_context(activables_while_penetrated)
	enable_activable("WallsUpActivable")


func switch_to_normal_context() -> void:
	switch_context(activables_while_normal)
	colliders.collision_layer = 4
	colliders_up.collision_layer = 0
	enable_activable("WallsUpActivable")


func switch_to_upwall_context() -> void:
	switch_context(activables_while_up)
	colliders.collision_layer = 0
	colliders_up.collision_layer = 4
	enable_activable("JumpDownActivable")


func show_secret_room() -> void:
	setup_ceiling.visible = false


func hide_secret_room() -> void:
	setup_ceiling.visible = true


func blinders_up() -> void:
	blinders.scale.y = 0.1
	exit_window_activable.forbidden = false
	enable_activable("BlindersDownActivable", 2.0)


func blinders_down() -> void:
	blinders.scale.y = 1
	exit_window_activable.forbidden = true
	enable_activable("BlindersUpActivable", 2.0)


func move_chair() -> void:
	move_chair_animation.play("move_chair")
	deactivate_activable("StreamInActivable", 0.0, true)
	deactivate_activable("StreamOutActivable", 0.0, true)
	enable_activable("StreamInIncorrectActivable")


func awake_wall() -> void:
	pass


func awake_jump() -> void:
	pass


func awake_stream() -> void:
	pass


func awake_window() -> void:
	pass
