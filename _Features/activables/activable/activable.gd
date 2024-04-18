class_name Activable extends Area3D

@export var activable_name: String

@export var times_to_unforbid := 5
@export var time_to_alternate := 3.0
@export var initial_state := "Idle"

@export_category("Normal")
@export var activable_text := "..."
@export var enable_after := [] as Array[Activable]
@export var deactivate_after := [] as Array[Activable]
@export var enable_after_seconds := 2.0
@export var deactivate_after_seconds := 0.0
@export var destroy_after_activation := false

@export_category("Alternative")
@export var activable_alternative_text := "..."
@export var alternative_enable_after := [] as Array[Activable]
@export var alternative_deactivate_after := [] as Array[Activable]
@export var alternative_enable_after_seconds := 2.0
@export var alternative_deactivate_after_seconds := 0.0
@export var alternative_destroy_after_activation := false

@export var alternative := false:
	set(value):
		alternative = value
		reset_label()

@export var forbidden := false:
	set(value):
		forbidden = value
		reset_label()

var player: Player
var is_in_context := true:
	set(value):
		is_in_context = value
		if !is_in_context:
			stop_being_current()
			visible = false
		else:
			visible = true

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_deactivated := $FiniteStateMachine/Deactivated as ActivableState
@onready var state_activated := $FiniteStateMachine/Activated as ActivableState
@onready var state_visible := $FiniteStateMachine/Visible as ActivableState
@onready var state_idle := $FiniteStateMachine/Idle as ActivableState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabel as ActivableLabel
@onready var indicator := $Indicator as Node3D


func _ready() -> void:
	state_machine.initial_state = initial_state
	label.outline_modulate = label.get_color(false, alternative, forbidden)
	reset_label()


func change_current_activable() -> void:
	SignalBus.current_activable_changed.emit(self)


func stop_being_current() -> void:
	if state_machine.is_in_state([state_visible.name]):
		state_machine.transition_to(state_idle.name)


func deactivate(msg := {"init": false}) -> void:
	state_machine.transition_to(state_deactivated.name, msg)


func deactivate_forever() -> void:
	queue_free()


func reactivate() -> void:
	state_machine.transition_to(state_idle.name)


func is_activated() -> bool:
	return !state_machine.is_in_state([state_deactivated.name])


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

func _on_activable_input_event(
	_camera: Node, _event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int
) -> void:
	pass

func _on_mouse_exited() -> void:
	if !state_machine.is_in_state([state_deactivated.name]):
		if(state_machine.is_in_state([state_visible.name])):
			state_machine.transition_to(state_idle.name)


func _on_mouse_entered() -> void:
	if !state_machine.is_in_state([state_deactivated.name]):
		if(state_machine.is_in_state([state_idle.name])):
			state_machine.transition_to(state_visible.name)
