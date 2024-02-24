class_name Activable extends Area3D

@export var activable_name: String
@export var activable_alternative_name: String
@export var forbidden := false
@export var activable_text := "Realizar acciÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³n"

@onready var state_activated := $FiniteStateMachine/Activated as FiniteState
@onready var state_visible := $FiniteStateMachine/Visible as FiniteState
@onready var state_idle := $FiniteStateMachine/Idle as FiniteState
@onready var collision_shape_3d := $CollisionShape3D as CollisionShape3D
@onready var label := $ActionLabel as ActivableLabel


func _ready() -> void:
	label.text = activable_text
	label.outline_modulate = Color.TRANSPARENT
	label.modulate = Color.TRANSPARENT
