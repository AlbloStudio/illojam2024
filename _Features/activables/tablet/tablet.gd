class_name Tablet extends Node

@onready var speech_bubble_label := $SpeechBubble/SpeechBubbleLabel as Label3D
@onready var activable := $Tablet as Activable


func say(to_say: Array[String], delay: Array[float] = [3.0]) -> void:
	speech_bubble_label.visible = true
	for i in to_say.size():
		speech_bubble_label.text = to_say[i]
		await get_tree().create_timer(delay[i]).timeout

	speech_bubble_label.visible = false


func activate() -> void:
	activable.reactivate()
