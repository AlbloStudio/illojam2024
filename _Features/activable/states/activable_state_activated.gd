class_name ActivableStateActivated extends ActivableState


func enter(_msg := {}) -> void:
	SignalBus.activable_activated.emit(state_owner.name)
