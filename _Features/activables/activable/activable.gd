class_name Activable extends Area3D

@export var activable_name: String
@export var activable_alternative_name: String
@export var forbidden := false
@export var alternative := false
@export var activable_text := "Realizar action"
@export var times_to_unforbid := 5
@export var time_to_alternate := 3.0

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_deactivated := $FiniteStateMachine/Deactivated as ActivableState
@onready var state_activated := $FiniteStateMachine/Activated as ActivableState
@onready var state_visible := $FiniteStateMachine/Visible as ActivableState
@onready var state_idle := $FiniteStateMachine/Idle as ActivableState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabel as ActivableLabel


func _ready() -> void:
	var label_prefix = "🚫 " if forbidden else ""
	label.text = label_prefix + activable_text
	label.outline_modulate = label.get_color(false, alternative, forbidden)
	label.modulate = label.get_color(false, alternative, forbidden)


func change_current_activable() -> void:
	SignalBus.current_activable_changed.emit(self)


func stop_being_current() -> void:
	state_machine.transition_to(state_idle.name)


func deactivate() -> void:
	state_machine.transition_to(state_deactivated.name)


func reactivate() -> void:
	state_machine.transition_to(state_idle.name)


func activate() -> void:
	state_machine.transition_to(state_activated.name)
