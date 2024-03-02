extends Node

var current_activable: Activable = null

@onready var player := $Player as Player


func _ready():
	SignalBus.tablet_closed.connect(_tablet_closed)
	SignalBus.activable_activated.connect(_activable_activated)
	SignalBus.current_activable_changed.connect(_set_current_activable)


func _activable_activated(activable_name: String) -> void:
	match activable_name:
		"Tablet":
			_tablet_opened()


func _tablet_opened() -> void:
	player.go_puppet()
	SignalBus.tablet_opened.emit()


func _tablet_closed() -> void:
	player.go_controlled()


func _set_current_activable(new_activable: Activable) -> void:
	if current_activable:
		current_activable.stop_being_current()
	current_activable = new_activable
