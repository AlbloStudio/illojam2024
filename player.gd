class_name Player extends CharacterBody3D

@export var speed = 300.0
@export var acceleration := 10.0
@export var intertia := 15.0

var desired_velocity := Vector2.ZERO

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_controlled := $FiniteStateMachine/Controlled as PlayerState
@onready var state_puppet := $FiniteStateMachine/Puppet as PlayerState


func _ready():
	desired_velocity = Vector2.LEFT


func go_controlled() -> void:
	state_machine.transition_to(state_controlled.name)


func go_puppet() -> void:
	state_machine.transition_to(state_puppet.name)
