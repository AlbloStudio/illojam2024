class_name PlayerState extends FiniteState

var state_owner: Player


func _ready() -> void:
	await owner.ready
	state_owner = owner as Player
	assert(owner != null)
