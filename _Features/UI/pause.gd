extends Control

var is_paused = false

@onready var music_slider := %Music as HSlider
@onready var dialog_slider := %Dialogs as HSlider


func _ready():
	SignalBus.paused.connect(_on_Pause_pressed)

	music_slider.value = (
		(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) + 80) / 0.8
	)

	dialog_slider.value = (
		(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogs")) + 80) / 0.8
	)


func _on_Pause_pressed():
	is_paused = !is_paused
	visible = is_paused


func _on_dialogs_value_changed(value: float) -> void:
	print(-80 + value * 0.8)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialogs"), -80 + value * 0.8)


func _on_music_value_changed(value: float) -> void:
	print(-80 + value * 0.8)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80 + value * 0.8)
