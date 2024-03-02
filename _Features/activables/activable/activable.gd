class_name Activable extends Area3D

@export var activable_name: String
@export var activable_alternative_name: String
@export var forbidden := false
@export var activable_text := "Realizar action"

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_deactivated := $FiniteStateMachine/Deactivated as ActivableState
@onready var state_activated := $FiniteStateMachine/Activated as ActivableState
@onready var state_visible := $FiniteStateMachine/Visible as ActivableState
@onready var state_idle := $FiniteStateMachine/Idle as ActivableState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabel as ActivableLabel


func _ready() -> void:
	label.text = activable_text
	label.outline_modulate = Color.TRANSPARENT
	label.modulate = Color.TRANSPARENT


func change_current_activable() -> void:
	SignalBus.current_activable_changed.emit(self)


func stop_being_current() -> void:
	state_machine.transition_to(state_idle.name)


func deactivate() -> void:
	state_machine.transition_to(state_deactivated.name)


func reactivate() -> void:
	state_machine.transition_to(state_idle.name)
