class_name Tablet extends Node

@onready var activable := $Tablet as Activable
@onready var speech_bubble := $SpeechBubble as SpeechBubble


func say(to_say: Array[String], audio: String, delay: Array[float] = [3.0]) -> void:
	speech_bubble.say(to_say, audio, delay)


func activate() -> void:
	activable.reactivate()
