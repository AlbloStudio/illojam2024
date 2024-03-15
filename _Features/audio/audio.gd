class_name Audio extends Node

@export var song_layers: Array[AudioStream]

var bpm = 130.0
var level = 0

@onready var current_song := $MainMusic as AudioStreamPlayer
@onready var plas := $Plas as AudioStreamPlayer


func _ready():
	current_song.finished.connect(_song_finished)
	_play_level_music()


func advance_level(_name):
	plas.play()
	level += 1
	_play_level_music()


func _play_level_music():
	var time = 0.0
	if current_song:
		time = current_song.get_playback_position()
		current_song.stop()
	current_song.stream = song_layers[level]
	current_song.play(time)


func _song_finished():
	current_song.play(0)
