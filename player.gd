class_name Player extends CharacterBody3D

@export var speed = 300.0
@export var acceleration := 10.0
@export var intertia := 15.0

var desired_velocity := Vector2.ZERO
var current_activable: Activable = null

@onready var state_machine := $FiniteStateMachine as FiniteStateMachine
@onready var state_controlled := $FiniteStateMachine/Controlled as PlayerState
@onready var state_puppet := $FiniteStateMachine/Puppet as PlayerState


func _ready():
	desired_velocity = Vector2.LEFT
	SignalBus.tablet_closed.connect(_tablet_closed)


func _tablet_closed() -> void:
	state_machine.transition_to(state_controlled.name)
