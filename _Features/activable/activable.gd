class_name Activable extends Area3D

@export var activable_name: String
@export var activable_alternative_name: String
@export var forbidden := false

@onready var state_visible := $FiniteStateMachine/Visible as FiniteState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
