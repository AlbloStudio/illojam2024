class_name Player extends CharacterBody3D

@export var naked_texture: Texture
@export var speed = 3.0
@export var speed_slow = 0.5
@export var speed_fast = 3.0
@export var acceleration := 10.0
@export var intertia := 15.0
@export var zarzillos: AudioStream

var desired_velocity := Vector2.ZERO
var clothes = ["underwear", "pants", "tshirt"]
var original_speech_bubble_position := Vector3.ZERO
var previous_position := Vector3.ZERO
var dont_animate_movement := false
var original_hoodie_texture: Texture
var original_pants_texture: Texture

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_controlled := $FiniteStateMachine/Controlled as PlayerState
@onready var state_puppet := $FiniteStateMachine/Puppet as PlayerState
@onready var speech_bubble_label := $SpeechBubble/SpeechBubbleLabel as Label3D
@onready var player_animation := $player/AnimationPlayer as AnimationPlayer

@onready var arms := $player/arms_skeleton/Skeleton3D/arms as MeshInstance3D
@onready var body := $player/arms_skeleton/Skeleton3D/body2 as MeshInstance3D
@onready var hair := $player/arms_skeleton/Skeleton3D/hair_005 as MeshInstance3D
@onready var head := $player/arms_skeleton/Skeleton3D/head_001 as MeshInstance3D
@onready var pixelation := $Pixelation as MeshInstance3D
@onready var audiostream_player := $AudioStreamPlayer3D as AudioStreamPlayer3D


func _ready():
	desired_velocity = Vector2.LEFT
	original_speech_bubble_position = speech_bubble_label.global_position


func _process(_delta: float) -> void:
	if speech_bubble_label.visible:
		speech_bubble_label.global_position.x = (
			original_speech_bubble_position.x + global_position.x
		)
		speech_bubble_label.global_position.z = (
			original_speech_bubble_position.z + global_position.z
		)


func go_controlled() -> void:
	state_machine.transition_to(state_controlled.name)


func go_puppet() -> void:
	state_machine.transition_to(state_puppet.name)


func is_puppet() -> bool:
	return state_machine.is_in_state([state_puppet.name])


func get_naked() -> void:
	clothes = []
	var hoodie_material := body.get_active_material(1)
	original_hoodie_texture = hoodie_material.albedo_texture
	hoodie_material.albedo_texture = naked_texture
	var pants_material := body.get_active_material(2)
	original_pants_texture = pants_material.albedo_texture
	pants_material.albedo_texture = naked_texture
	pixelation.visible = true
	pixelation.rotation_degrees = Vector3(0, 0, 0)


func put_some_clothes(cloth_name: String) -> void:
	if not clothes.has(cloth_name):
		clothes.append(cloth_name)
		if cloth_name == "pants":
			body.get_active_material(2).albedo_texture = original_pants_texture
			audiostream_player.stream = zarzillos
			audiostream_player.play()
		elif cloth_name == "tshirt":
			body.get_active_material(1).albedo_texture = original_hoodie_texture

	if clothes.size() == 3:
		pixelation.visible = false

		if clothes.find("underwear") > clothes.find("pants"):
			SignalBus.clothes_wrong.emit()
		else:
			SignalBus.clothes_right.emit()


func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null

	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound


func say(text: String, audio: String, delay := 3.0) -> void:
	speech_bubble_label.visible = true
	speech_bubble_label.text = text
	create_tween().tween_callback(func(): speech_bubble_label.visible = false).set_delay(delay)

	var sound = load_mp3("res://_Features/audio/" + audio + ".mp3")
	if sound != null:
		audiostream_player.stream = sound
		audiostream_player.play()


func sit_on_chair(sit_position: Vector3) -> void:
	if state_machine.is_in_state([state_controlled.name]):
		animate("SitOnChair", sit_position, Vector3.ZERO, state_puppet.name)


func get_up_from_chair() -> void:
	animate("SitOnChair", previous_position, Vector3.ZERO, state_controlled.name, true)


func sit_on_mirror_chair(sit_position: Vector3) -> void:
	if state_machine.is_in_state([state_controlled.name]):
		animate(
			"SitOnChair",
			sit_position,
			Vector3(0, PI, 0),
			state_puppet.name,
			false,
			after_mirror_chair
		)


func after_mirror_chair() -> void:
	SignalBus.awaked.emit("sit")
	animate("SitOnChair", previous_position, Vector3(0, PI, 0), state_controlled.name, true)


func lay_down_on_sofa(new_position: Vector3, is_wall := false) -> void:
	print(global_position)
	pixelation.rotation_degrees = Vector3(90, 90, 0)
	if !is_wall:
		global_position.x -= 0.9
		global_rotation = Vector3(0, get_target_ang(PI / 2), 0)
		animate(
			"LayingSofa",
			new_position,
			global_rotation,
			state_controlled.name,
			false,
			_layed_down,
		)
	else:
		global_position.x += 0.9
		global_rotation = Vector3(0, get_target_ang(PI / 2), 0)
		animate(
			"LayingSofaWall",
			new_position,
			global_rotation,
			state_controlled.name,
			false,
			_layed_down,
		)


func lay_up_from_sofa_init(new_position: Vector3) -> void:
	pixelation.rotation_degrees = Vector3(90, 90, 0)
	go_puppet()
	global_rotation = Vector3(0, get_target_ang(PI / 2), 0)
	animate(
		"LayingSofa",
		new_position,
		global_rotation,
		state_controlled.name,
		true,
		_layed_up_init,
		null,
		0.3
	)


func lay_up_from_sofa(new_position: Vector3, is_wall := false) -> void:
	pixelation.rotation_degrees = Vector3(90, 90, 0)
	global_rotation = Vector3(0, get_target_ang(PI / 2), 0)
	animate(
		"LayingSofa" if !is_wall else "LayingSofaWall",
		new_position,
		global_rotation,
		state_controlled.name,
		true,
		_layed_up,
		null,
		0
	)
	if is_wall:
		SignalBus.awaked.emit("sofa")


func _change_player_speed(new_speed: float) -> void:
	speed = new_speed


func _layed_down() -> void:
	pixelation.rotation_degrees = Vector3(90, 0, 0)
	_change_player_speed(speed_slow)
	SignalBus.layed_down.emit()
	global_rotation = Vector3(0, get_target_ang(0), 0)
	dont_animate_movement = true
	player_animation.play("LayingDownIddle", 0)


func _layed_up() -> void:
	pixelation.rotation_degrees = Vector3(0, 0, 0)
	_change_player_speed(speed_fast)
	SignalBus.layed_up.emit()
	dont_animate_movement = false


func _layed_up_init() -> void:
	pixelation.rotation_degrees = Vector3(0, 0, 0)
	SignalBus.started.emit()
	SignalBus.layed_up.emit()


func sit_to_stream(new_position: Vector3) -> void:
	animate(
		"SitOnChair",
		new_position,
		Vector3(0, PI, 0),
		state_puppet.name,
		false,
		func(): SignalBus.streaming.emit()
	)


func get_up_from_streaming() -> void:
	pixelation.rotation_degrees = Vector3(0, 0, 0)
	animate(
		"SitOnChair",
		previous_position,
		Vector3(0, PI, 0),
		state_controlled.name,
		true,
		func(): SignalBus.stopped_streaming.emit()
	)


func sit_to_stream_wrong(new_position: Vector3) -> void:
	animate(
		"SitOnChair",
		new_position,
		Vector3.ZERO,
		state_puppet.name,
		false,
		func(): SignalBus.streaming_wrong.emit()
	)


func get_up_from_streaming_wrong() -> void:
	animate(
		"SitOnChair",
		previous_position,
		Vector3.ZERO,
		state_controlled.name,
		true,
		func(): SignalBus.stopped_streaming_wrong.emit()
	)


func set_up_walls(new_position: Vector3, on_middle: Callable) -> void:
	vanish(new_position, on_middle, func(): SignalBus.upped_wall.emit())


func set_down_wall(new_position: Vector3, on_middle: Callable) -> void:
	vanish(new_position, on_middle, func(): SignalBus.downed_wall.emit())


func penetrate(new_position: Vector3) -> void:
	animate(
		"JumpWall", new_position, Vector3(0, 2 * PI, 0), state_controlled.name, false, penetrated
	)


func penetrated() -> void:
	SignalBus.awaked.emit("jump")
	SignalBus.jumped_down.emit()


func exit_window() -> void:
	global_rotation.y = get_target_ang(-PI / 2)
	var new_position = global_position - Vector3(1.5, 0, 0)

	animate(
		"JumpWindow",
		new_position,
		global_rotation,
		state_controlled.name,
		false,
		func(): SignalBus.exited_window.emit()
	)


func enter_window() -> void:
	global_rotation.y = PI / 2
	var new_position = global_position + Vector3(1.5, 0, 0)

	animate(
		"JumpWindow",
		new_position,
		global_rotation,
		state_controlled.name,
		false,
		func(): SignalBus.entered_window.emit()
	)


func animate(
	animation_name: String,
	position_target: Vector3,
	rotation_target: Vector3,
	target_state_name: String,
	backwards := false,
	on_finished := func(): pass,
	walking_target = null,
	blend := -1.0
) -> void:
	previous_position = global_position

	go_puppet()

	if walking_target != null:
		create_tween().tween_property(self, "global_position", walking_target, 1.2)

	if !backwards:
		player_animation.play(animation_name, blend)
	else:
		player_animation.play_backwards(animation_name, blend)

	var animation_length = player_animation.current_animation_length

	var target_ang = get_target_ang(rotation_target.y)

	var animation_tweener = create_tween()
	animation_tweener.set_parallel(true)
	animation_tweener.tween_property(self, "global_position", position_target, animation_length)
	animation_tweener.tween_property(
		self, "global_rotation", Vector3(0, target_ang, 0), animation_length
	)

	player_animation.animation_finished.connect(
		func(_animation): after_animate(target_state_name, on_finished), CONNECT_ONE_SHOT
	)


func after_animate(
	target_state_name: String,
	on_finished := func(): pass,
) -> void:
	state_machine.transition_to(target_state_name)
	on_finished.call()


func get_target_ang(rotation_target: float) -> float:
	return global_rotation.y + wrapf(rotation_target - global_rotation.y, -PI, PI)


func vanish(new_position: Vector3, on_middle: Callable, on_end: Callable) -> void:
	var disappear_tween := create_tween()
	disappear_tween.finished.connect(_on_disappear.bind(new_position, on_middle, on_end))

	disappear_tween.set_parallel(true)
	disappear_tween.tween_property(arms, "transparency", 1.0, 1.0)
	disappear_tween.tween_property(body, "transparency", 1.0, 1.0)
	disappear_tween.tween_property(hair, "transparency", 1.0, 1.0)
	disappear_tween.tween_property(head, "transparency", 1.0, 1.0)


func _on_disappear(new_position: Vector3, on_middle: Callable, on_end: Callable) -> void:
	on_middle.call()
	global_position = new_position

	var appear_tween := create_tween()
	appear_tween.finished.connect(on_end)

	appear_tween.set_parallel(true)
	appear_tween.tween_property(arms, "transparency", 0.0, 1.0)
	appear_tween.tween_property(body, "transparency", 0.0, 1.0)
	appear_tween.tween_property(hair, "transparency", 0.0, 1.0)
	appear_tween.tween_property(head, "transparency", 0.0, 1.0)


func exit_dream(new_position: Vector3) -> void:
	animate("Walk", new_position, Vector3(0.0, PI, 0.0), state_puppet.name, false)
