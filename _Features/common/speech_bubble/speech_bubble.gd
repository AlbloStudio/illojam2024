class_name SpeechBubble extends Node3D

var next_texts: Dictionary = {}
var next_actions: Dictionary = {}
var next_audio: String = ""

var actions_cue: Array[CallbackTweener] = []
var texts_cue: Array[CallbackTweener] = []

@onready var speech_bubble_label := $SpeechBubbleLabel as Label3D
@onready var audiostream_player := $AudioStreamPlayer3D as AudioStreamPlayer3D


func _unhandled_input(event: InputEvent):
	if actions_cue.size() > 0 || audiostream_player.playing:
		if event.is_action_pressed("skip"):
			stop_saying()


func _process(_delta) -> void:
	if speech_bubble_label.visible:
		global_rotation = Vector3(0, 0, 0)


func say(texts: Dictionary, audio: String, actions: Dictionary = {}) -> void:
	if texts_cue.size() > 0:
		next_texts = texts
		next_actions = actions
		next_audio = audio
		stop_saying()
		return

	if TranslationServer.get_locale() == "es":
		var sound = _load_mp3("res://_Features/audio/" + audio + ".mp3")
		if sound != null:
			audiostream_player.stream = sound
			audiostream_player.play()

	speech_bubble_label.visible = true

	for action in actions:
		var tweener = create_tween().tween_callback(action).set_delay(actions[action])
		actions_cue.append(tweener)
		tweener.finished.connect(func(): actions_cue.erase(tweener), CONNECT_ONE_SHOT)

	if texts.size() > 0:
		switch_text(texts.keys()[0])

		if texts.size() > 1:
			for i in texts.size() - 1:
				i += 1

				var current_text = texts.keys()[i - 1]
				var next_text = texts.keys()[i]
				var next_delay = texts[current_text]

				var tweener = create_tween().tween_callback(switch_text.bind(next_text)).set_delay(
					next_delay
				)
				texts_cue.append(tweener)

		var last_delay = texts[texts.keys()[texts.size() - 1]]
		texts_cue.append(create_tween().tween_callback(finish_say).set_delay(last_delay))


func switch_text(text: String) -> void:
	speech_bubble_label.text = tr(text)


func finish_say() -> void:
	speech_bubble_label.visible = false
	texts_cue.clear()
	if next_texts.size() > 0:
		say(next_texts, next_audio, next_actions)
		next_texts.clear()
		next_actions.clear()
		next_audio = ""


func stop_saying() -> void:
	speech_bubble_label.visible = false
	audiostream_player.stop()
	for action in actions_cue:
		action.set_delay(0)
	for text in texts_cue:
		text.set_delay(0)


func _load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null

	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound
