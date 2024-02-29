class_name ActivableState extends FiniteState

var state_owner: Activable


func _ready() -> void:
	await owner.ready
	state_owner = owner as Activable
	assert(owner != null)
