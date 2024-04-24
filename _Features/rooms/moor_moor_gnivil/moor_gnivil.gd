class_name MoorGnivil extends Node3D

@onready var ceiling := $Ceiling as MeshInstance3D
@onready var nolas := $Nolas as Nolas


func _ready() -> void:
	SignalBus.barrier_entered.connect(_remove_ceiling)
	SignalBus.barrier_exited.connect(_show_ceiling)


func _remove_ceiling(barrier_name: String) -> void:
	if barrier_name == "MirrorBarrier":
		ceiling.visible = false
		nolas.reactivate_tablet()


func _show_ceiling(barrier_name: String) -> void:
	if barrier_name == "MirrorBarrier":
		ceiling.visible = true
		nolas.deactivate_tablet()
