class_name Activable extends Area3D

@export var activable_name: String

@export var times_to_unforbid := 5
@export var time_to_alternate := 3.0
@export var initial_state := "Idle"
@export var transparency_distance := 4.0
@export var vibration_distance := 3.0

@export var correct_activated_sfx: AudioStream
@export var forbidden_activated_sfx: AudioStream
@export var alternative_activated_sfx: AudioStream

@export var alternative := false:
	set(value):
		alternative = value
		reset_label()

@export var forbidden := false:
	set(value):
		forbidden = value
		reset_label()

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
@export_range(-24, 10) var sound_volume := 0.0

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
@export_range(-24, 10) var alternative_sound_volume := 0.0

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
var original_position_indicator: Vector3
var original_position_label: Vector3
var is_using_help := false

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_deactivated := $FiniteStateMachine/Deactivated as ActivableState
@onready var state_activated := $FiniteStateMachine/Activated as ActivableState
@onready var state_visible := $FiniteStateMachine/Visible as ActivableState
@onready var state_idle := $FiniteStateMachine/Idle as ActivableState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabelMesh as ActivableLabel
@onready var indicator := $Indicator as Node3D
@onready var indicator_mesh := $Indicator/IndicatorMesh as MeshInstance3D
@onready var audio_stream := $SFX as AudioStreamPlayer3D
@onready var game_feel_audio := $GameFeelAudio as AudioStreamPlayer3D
@onready var progress_audio := $ProgressAudio as AudioStreamPlayer3D
@onready var activating_light := $ActivatingLight as OmniLight3D
@onready var activating_light_label := $ActivatingLightLabel as OmniLight3D
@onready var animation_player := $AnimationPlayer as ActivableAnimations


func _ready() -> void:
	if initial_state != "":
		state_machine.forced_initial_state = initial_state

	original_position_indicator = indicator.position as Vector3
	original_position_label = label.position as Vector3

	reset_label()

	animation_player.do_the_shake.connect(do_the_shake)
	animation_player.stop_shaking.connect(stop_shaking)


func _process(delta):
	time_passed += delta

	indicator_mesh.position.z = (
		cos(time_passed * 10) * minf(distance_from_indicator, vibration_distance) * 0.02
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("activable_help"):
		indicator_mesh.transparency = 0
		is_using_help = true
	elif event.is_action_released("activable_help"):
		is_using_help = false

	if !is_using_help && event is InputEventMouseMotion:
		set_indicator_transparency_given_mouse_position(event)


func set_indicator_transparency_given_mouse_position(event: InputEvent) -> void:
	var cursor_placement := MouseExtends.get_mouse_pos_in_floor(event, get_viewport())
	distance_from_indicator = cursor_placement.distance_to(
		Vector3(indicator.global_position.x, 0, indicator.global_position.z)
	)

	var transparency = (
		1 - (maxf(0.0, transparency_distance - distance_from_indicator) / transparency_distance)
	)

	indicator_mesh.transparency = transparency


func calculate_next_pos(node_position: Vector3, node_original_position: Vector3) -> Vector3:
	var pos_margin := 0.2

	var x = node_position.x + randf_range(-pos_margin, pos_margin)
	var y = node_position.y + randf_range(-pos_margin, pos_margin)
	var z = node_position.z + randf_range(-pos_margin, pos_margin)

	var x_clamped := clampf(
		x, node_original_position.x - pos_margin, node_original_position.x + pos_margin
	)
	var y_clamped := clampf(
		y, node_original_position.y - pos_margin, node_original_position.y + pos_margin
	)
	var z_clamped := clampf(
		z, node_original_position.z - pos_margin, node_original_position.z + pos_margin
	)

	return Vector3(x_clamped, y_clamped, z_clamped)


func do_the_shake() -> void:
	indicator.position = calculate_next_pos(indicator.position, original_position_indicator)
	label.position = calculate_next_pos(label.position, original_position_label)


func stop_shaking() -> void:
	indicator.position = original_position_indicator
	label.position = original_position_label


func activate_lights(activate: bool) -> void:
	activating_light.visible = activate
	activating_light_label.visible = activate


func activated_game_feel() -> void:
	activate_lights(true)
	animation_player.play("activated")
	game_feel_audio.stream = correct_activated_sfx
	game_feel_audio.play()


func forbidden_game_feel() -> void:
	animation_player.play_forbidden()
	game_feel_audio.stream = forbidden_activated_sfx
	game_feel_audio.play()


func alternative_game_feel() -> void:
	game_feel_audio.stream = alternative_activated_sfx
	game_feel_audio.play()
	label.get_material().set_shader_parameter("voronoi_active", true)
	create_tween().tween_method(alternative_shader_pass, 0.0, 0.7, 0.3).finished.connect(
		alterantive_mid, CONNECT_ONE_SHOT
	)


func alterantive_mid() -> void:
	alternative = !alternative

	create_tween().tween_method(alternative_shader_pass, 0.7, 0.0, 0.3).finished.connect(
		func(): label.get_material().set_shader_parameter("voronoi_active", false), CONNECT_ONE_SHOT
	)


func alternative_shader_pass(ratio: float) -> void:
	label.get_material().set_shader_parameter("radius", ratio)


func change_current_activable() -> void:
	SignalBus.current_activable_changed.emit(self)


func stop_being_current() -> void:
	game_feel_audio.stop()
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


func check_should_activate(times_pressed: int) -> void:
	var should_transition: bool = !forbidden || times_pressed >= times_to_unforbid

	if should_transition:
		SignalBus.should_activate.emit(self)
	elif forbidden:
		forbidden_game_feel()
