class_name Tablet extends Node

@onready var speech_bubble_label := $SpeechBubble/SpeechBubbleLabel as Label3D
@onready var activable := $Tablet as Activable
@onready var audiostream_player := $AudioStreamPlayer3D as AudioStreamPlayer3D


func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null

	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound


func say(to_say: Array[String], audio: String, delay: Array[float] = [3.0]) -> void:
	var sound = load_mp3("res://_Features/audio/" + audio + ".mp3")
	if sound != null:
		audiostream_player.stream = sound
		audiostream_player.play()

	speech_bubble_label.visible = true
	for i in to_say.size():
		speech_bubble_label.text = to_say[i]
		await get_tree().create_timer(delay[i]).timeout

	speech_bubble_label.visible = false


func activate() -> void:
	activable.reactivate()
