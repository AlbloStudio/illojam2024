class_name Tablet extends Node

@onready var activable := $Tablet as Activable
@onready var speech_bubble := $SpeechBubble as SpeechBubble


func say(to_say: Dictionary, audio: String, actions: Dictionary = {}) -> void:
	speech_bubble.say(to_say, audio, actions)


func activate() -> void:
	activable.reactivate()


func deactivate() -> void:
	activable.deactivate()
