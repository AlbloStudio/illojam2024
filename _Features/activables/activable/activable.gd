class_name Activable extends Area3D

@export var activable_name: String
@export var activable_alternative_name: String
@export var activable_text := "Realizar action"
@export var activable_alternative_text := "Realizar action"
@export var times_to_unforbid := 5
@export var time_to_alternate := 3.0
@export var alternative := false:
	set(value):
		alternative = value
		reset_label()

@export var forbidden := false:
	set(value):
		forbidden = value
		reset_label()

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_deactivated := $FiniteStateMachine/Deactivated as ActivableState
@onready var state_activated := $FiniteStateMachine/Activated as ActivableState
@onready var state_visible := $FiniteStateMachine/Visible as ActivableState
@onready var state_idle := $FiniteStateMachine/Idle as ActivableState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabel as ActivableLabel


func _ready() -> void:
	label.outline_modulate = label.get_color(false, alternative, forbidden)

	reset_label()


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


func switch_alternative() -> void:
	alternative = !alternative
	reset_label()


func reset_label() -> void:
	if !label:
		return

	set_label_text()
	set_label_colors()


func set_label_colors() -> void:
	if !label:
		return

	var should_be_visible = state_machine.is_in_state([state_visible.name])
	label.modulate = label.get_color(should_be_visible, alternative, forbidden)


func set_label_text() -> void:
	if !label:
		return

	var label_prefix = "🚫 " if forbidden else ""
	var label_text = activable_alternative_text if alternative else activable_text
	label.text = label_prefix + label_text
