extends Node

@onready var tablet_label := $TabletLabel as Label3D


func _ready() -> void:
	SignalBus.tablet_opened.connect(_tablet_opened)


func _unhandled_input(event: InputEvent) -> void:
	if tablet_label.visible and event.is_action_released("player_action"):
		print("action!")
		SignalBus.tablet_closed.emit()
		tablet_label.visible = false


func _tablet_opened() -> void:
	tablet_label.visible = true
