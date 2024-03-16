class_name Tablet extends Node

@onready var speech_bubble_label := $SpeechBubble/SpeechBubbleLabel as Label3D


func say(to_say: String, delay := 3.0) -> void:
	speech_bubble_label.visible = true
	speech_bubble_label.text = to_say
	create_tween().tween_callback(func(): speech_bubble_label.visible = false).set_delay(delay)
