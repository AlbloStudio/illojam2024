class_name Tablet extends Node

@onready var activable := $Tablet as Activable
@onready var speech_bubble := $SpeechBubble as SpeechBubble


func say(to_say: Dictionary, audio: String, actions: Dictionary = {}) -> void:
	speech_bubble.say(to_say, audio, actions)


func activate() -> void:
	if activable != null:
		activable.reactivate()


func deactivate() -> void:
	if activable != null:
		activable.deactivate()
