class_name Activable extends Area3D

@export var activable_name: String
@export var activable_text := "..."
@export var activable_alternative_text := "..."
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

var player: Player

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_deactivated := $FiniteStateMachine/Deactivated as ActivableState
@onready var state_activated := $FiniteStateMachine/Activated as ActivableState
@onready var state_visible := $FiniteStateMachine/Visible as ActivableState
@onready var state_idle := $FiniteStateMachine/Idle as ActivableState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabel as ActivableLabel
@onready var indicator := $Indicator as Node3D


func _ready() -> void:
	label.outline_modulate = label.get_color(false, alternative, forbidden)

	reset_label()


func change_current_activable() -> void:
	SignalBus.current_activable_changed.emit(self)


func stop_being_current() -> void:
	if state_machine.is_in_state([state_visible.name]):
		state_machine.transition_to(state_idle.name)


func deactivate() -> void:
	state_machine.transition_to(state_deactivated.name)


func reactivate() -> void:
	state_machine.transition_to(state_idle.name)


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


func _on_indicator_trigger_area_entered(body) -> void:
	if body is Player && !state_machine.is_in_state([state_deactivated.name]):
		indicator.visible = true
	# create_tween().tween_method(change_indicator_transparency, 0, 1, 0.4)


func _on_indicator_trigger_area_exited(body) -> void:
	if body is Player:
		indicator.visible = false

	# create_tween().tween_method(change_indicator_transparency, 1, 0, 0.4)

# func change_indicator_transparency(value: float) -> void:
# 	indicator.get_surface_override_material(0).albedo_color.a = value
