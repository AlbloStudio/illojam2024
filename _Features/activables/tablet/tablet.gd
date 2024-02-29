extends Node

@onready var tablet_screen := $TabletScreen as Control


func _ready() -> void:
	SignalBus.tablet_opened.connect(_tablet_opened)


func _tablet_opened() -> void:
	tablet_screen.visible = true


func _tablet_closed() -> void:
	SignalBus.tablet_closed.emit()
	tablet_screen.visible = false
