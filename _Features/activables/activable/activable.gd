class_name Activable extends Area3D

@export var activable_name: String

@export var times_to_unforbid := 5
@export var time_to_alternate := 3.0
@export var initial_state := "Idle"
@export var transparency_distance := 4.0
@export var vibration_distance := 3.0

@export_category("Normal")
@export var activable_text := "..."
@export var enable_after := [] as Array[Activable]
@export var deactivate_after := [] as Array[Activable]
@export var enable_after_seconds := 2.0
@export var deactivate_after_seconds := 0.0
@export var destroy_after_activation := false
@export var initial_point: Node3D
@export var sound: AudioStream
@export var sound_delay := 0.0
@export_range(-24, 6) var sound_volume := 0.0

@export_category("Alternative")
@export var activable_alternative_text := "..."
@export var alternative_enable_after := [] as Array[Activable]
@export var alternative_deactivate_after := [] as Array[Activable]
@export var alternative_enable_after_seconds := 2.0
@export var alternative_deactivate_after_seconds := 0.0
@export var alternative_destroy_after_activation := false
@export var alternative_initial_point: Node3D
@export var alternative_sound: AudioStream
@export var alternative_sound_delay := 0.0
@export_range(-24, 6) var alternative_sound_volume := 0.0

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

var time_passed := 0.0
var distance_from_indicator := 0.0

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_deactivated := $FiniteStateMachine/Deactivated as ActivableState
@onready var state_activated := $FiniteStateMachine/Activated as ActivableState
@onready var state_visible := $FiniteStateMachine/Visible as ActivableState
@onready var state_idle := $FiniteStateMachine/Idle as ActivableState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabelMesh as ActivableLabel
@onready var indicator := $Indicator as Node3D
@onready var indicator_mesh := $Indicator/IndicatorMesh as MeshInstance3D
@onready var audio_stream := $AudioStreamPlayer3D as AudioStreamPlayer3D
@onready var activating_light := $ActivatingLight as OmniLight3D
@onready var activating_light_label := $ActivatingLightLabel as OmniLight3D


func _ready() -> void:
	if initial_state != "":
		state_machine.forced_initial_state = initial_state

	reset_label()


func _process(delta):
	time_passed += delta

	indicator_mesh.position.z = (
		cos(time_passed * 10) * minf(distance_from_indicator, vibration_distance) * 0.02
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var cursor_placement := MouseExtends.get_mouse_pos_in_floor(event, get_viewport())
		distance_from_indicator = cursor_placement.distance_to(
			Vector3(indicator.global_position.x, 0, indicator.global_position.z)
		)

		var transparency = (
			1 - (maxf(0.0, transparency_distance - distance_from_indicator) / transparency_distance)
		)

		indicator_mesh.transparency = transparency


func activate_lights(activate: bool) -> void:
	activating_light.visible = activate
	activating_light_label.visible = activate


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
	label.set_current_color(should_be_visible, alternative, forbidden)


func set_label_text() -> void:
	if !label:
		return

	var label_prefix = "🚫 " if forbidden else ""
	var label_text = activable_alternative_text if alternative else activable_text
	label.set_text(label_prefix + label_text)


func _on_activable_input_event(
	_camera: Node, _event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int
) -> void:
	pass


func _on_mouse_exited() -> void:
	if state_machine.is_in_state([state_visible.name]):
		state_machine.transition_to(state_idle.name)


func _on_mouse_entered() -> void:
	if state_machine.is_in_state([state_idle.name]):
		state_machine.transition_to(state_visible.name)
