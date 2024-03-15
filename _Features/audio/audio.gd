extends Node

@export var song_layers: Array[AudioStream]

var bpm = 130.0
var level = 0

@onready var current_song = $MainMusic
@onready var plas = $Plas


func _ready():
	SignalBus.awaked.connect(_advance_level)
	_play_level_music()


func _advance_level(_name):
	plas.play()
	level += 1
	_play_level_music()


func _get_song_position(song_t):
	return (song_t * bpm) / 60.0


func _play_level_music():
	var time = 0.0
	if current_song:
		time = current_song.get_playback_position()
		current_song.stop()
	current_song.stream = song_layers[level]
	current_song.play(time)
