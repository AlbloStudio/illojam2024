class_name Player extends CharacterBody3D

@export var speed = 300.0
@export var acceleration := 10.0
@export var intertia := 15.0

var desired_velocity := Vector2.ZERO
var clothes = ["underwear", "pants", "tshirt"]
var original_speech_bubble_position := Vector3.ZERO

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


func sit_on_chair() -> void:
	if state_machine.is_in_state([state_controlled.name]):
		go_puppet()


func get_up_from_chair() -> void:
	if state_machine.is_in_state([state_puppet.name]):
		go_controlled()