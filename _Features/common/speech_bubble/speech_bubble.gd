class_name SpeechBubble extends Node3D

@onready var speech_bubble_label := $SpeechBubbleLabel as Label3D
@onready var audiostream_player := $AudioStreamPlayer3D as AudioStreamPlayer3D


func _process(_delta) -> void:
	if speech_bubble_label.visible:
		global_rotation = Vector3(0, 0, 0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_action"):
		stop_saying()


func say(text: Array[String], audio: String, delay: Array[float] = [3.0]) -> void:
	var sound = _load_mp3("res://_Features/audio/" + audio + ".mp3")
	if sound != null:
		audiostream_player.stream = sound
		audiostream_player.play()

	speech_bubble_label.visible = true

	for i in text.size():
		speech_bubble_label.text = text[i]
		await get_tree().create_timer(delay[i]).timeout

	speech_bubble_label.visible = false


func stop_saying() -> void:
	speech_bubble_label.visible = false
	audiostream_player.stop()


func _load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null

	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound
