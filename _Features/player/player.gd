class_name Player extends CharacterBody3D

@export var speed = 3.0
@export var speed_slow = 0.5
@export var acceleration := 10.0
@export var intertia := 15.0

var desired_velocity := Vector2.ZERO
var clothes = ["underwear", "pants", "tshirt"]
var original_speech_bubble_position := Vector3.ZERO
var previous_position := Vector3.ZERO

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_controlled := $FiniteStateMachine/Controlled as PlayerState
@onready var state_puppet := $FiniteStateMachine/Puppet as PlayerState
@onready var speech_bubble_label := $SpeechBubble/SpeechBubbleLabel as Label3D
@onready var player_animation := $player/AnimationPlayer as AnimationPlayer


func _ready():
	desired_velocity = Vector2.LEFT
	original_speech_bubble_position = speech_bubble_label.position


func _process(_delta: float) -> void:
	if speech_bubble_label.visible:
		speech_bubble_label.position.x = original_speech_bubble_position.x + position.x
		speech_bubble_label.position.z = original_speech_bubble_position.z + position.z


func go_controlled() -> void:
	state_machine.transition_to(state_controlled.name)


func go_puppet() -> void:
	state_machine.transition_to(state_puppet.name)


func get_naked() -> void:
	clothes = []


func put_some_clothes(cloth_name: String) -> void:
	if not clothes.has(cloth_name):
		clothes.append(cloth_name)

	if clothes.size() == 3:
		if clothes.find("underwear") > clothes.find("pants"):
			SignalBus.clothes_wrong.emit()
		else:
			SignalBus.clothes_right.emit()


func say(text: String, delay := 3.0) -> void:
	speech_bubble_label.visible = true
	speech_bubble_label.text = text
	create_tween().tween_callback(func(): speech_bubble_label.visible = false).set_delay(delay)


func sit_on_chair(sit_position: Vector3) -> void:
	if state_machine.is_in_state([state_controlled.name]):
		animate("SitOnChair", sit_position, Vector3.ZERO, state_puppet.name)


func get_up_from_chair() -> void:
	animate("SitOnChair", previous_position, Vector3.ZERO, state_controlled.name, true)


func lay_down_on_sofa(new_position: Vector3) -> void:
	if state_machine.is_in_state([state_controlled.name]):
		_change_player_speed()
		global_position = new_position


func lay_up_from_sofa(new_position: Vector3) -> void:
	if state_machine.is_in_state([state_controlled.name]):
		_change_player_speed()
		global_position = new_position


func _change_player_speed() -> void:
	var previous_speed = speed
	speed = speed_slow
	speed_slow = previous_speed


func sit_to_stream(new_position: Vector3) -> void:
	if state_machine.is_in_state([state_controlled.name]):
		global_position = new_position
		go_puppet()


func get_up_from_streaming(new_position: Vector3) -> void:
	if state_machine.is_in_state([state_puppet.name]):
		global_position = new_position
		go_controlled()


func sit_to_stream_wrong(new_position: Vector3) -> void:
	if state_machine.is_in_state([state_controlled.name]):
		global_position = new_position
		go_puppet()


func get_up_from_streaming_wrong(new_position: Vector3) -> void:
	if state_machine.is_in_state([state_puppet.name]):
		global_position = new_position
		go_controlled()


func set_up_walls(new_position: Vector3) -> void:
	global_position = new_position


func set_down_wall(new_position: Vector3) -> void:
	global_position = new_position


func penetrate(new_position: Vector3) -> void:
	global_position = new_position


func animate(
	animation_name: String,
	position_target: Vector3,
	rotation_target: Vector3,
	target_state_name: String,
	backwards := false,
	walking_target = null
) -> void:
	previous_position = global_position

	go_puppet()

	if walking_target != null:
		create_tween().tween_property(self, "global_position", walking_target, 1.2)

	var animation_tweener = create_tween()
	animation_tweener.set_parallel(true)
	animation_tweener.tween_property(self, "global_position", position_target, 1.2)
	animation_tweener.tween_property(self, "rotation", rotation_target, 1.2)

	player_animation.animation_finished.connect(
		func(_animation): state_machine.transition_to(target_state_name), CONNECT_ONE_SHOT
	)

	if !backwards:
		player_animation.play(animation_name)
	else:
		player_animation.play_backwards(animation_name)
