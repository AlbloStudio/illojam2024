extends Node

var current_activable: Activable = null
var awakes = {
	"wall": false,
	"jump": false,
	"stream": false,
	"window": false,
	"clothes": false,
	"poster": false,
	"sit": false,
	"sofa": false,
}

@onready var player := $Player as Player
@onready var living_room := $Stage/LivingRoom/LivingRoom as LivingRoom
@onready var nolas := $Stage/MoorGnivil/Nolas as Nolas
@onready var setup := $Stage/Setup/setup as Setup
@onready var ui := $UI as GameUI


func _ready():
	SignalBus.tablet_closed.connect(_tablet_closed)
	SignalBus.activable_activated.connect(_activable_activated)
	SignalBus.current_activable_changed.connect(_set_current_activable)
	SignalBus.clothes_wrong.connect(_clothes_wronged)
	SignalBus.clothes_right.connect(_clothes_righted)
	SignalBus.awaked.connect(_awaked)
	SignalBus.layed_down.connect(_layed_down)
	SignalBus.layed_up.connect(_layed_up)
	SignalBus.streaming.connect(_streaming)
	SignalBus.stopped_streaming.connect(_stopped_streaming)
	SignalBus.streaming_wrong.connect(_streaming_wrong)
	SignalBus.stopped_streaming_wrong.connect(_stopped_streaming_wrong)


func _activable_activated(activable_name: String, alternative: bool) -> void:
	if current_activable == null || current_activable.activable_name != activable_name:
		return

	match activable_name:
		"Tablet":
			_tablet_opened()
		"Get Naked":
			_get_player_naked()
		"Put on T-Shirt":
			_put_on_clothes("tshirt")
		"Put on Pants":
			_put_on_clothes("pants")
		"Put on Underwear":
			_put_on_clothes("underwear")
		"ReadPoster":
			_read_poster()
		"Sit":
			_sit_on_chair()
		"GetUp":
			_get_up_from_chair()
		"Tis":
			_sit_on_mirror_chair()
		"RetsopDear":
			_read_mirror_poster()
		"Lay down":
			_sofa_lay_down()
		"Lay up":
			_sofa_lay_up()
		"Lay up wall":
			_sofa_lay_up_wall()
		"StreamIn":
			_stream_in()
		"StreamOut":
			_stream_out()
		"StreamWrong":
			_stream_in_wrong()
		"StreamOutWrong":
			_stream_out_wrong()
		"TouchWall":
			if alternative:
				_up_wall()
			else:
				_touch_wall()
		"Exit Window":
			_exit_window()
		"Blinders Up":
			_bilders_up()
		"Blinders Down":
			_blinders_down()
		"Jump Down":
			if alternative:
				_jump_down()
			else:
				_down_wall()
		"Move Chair":
			_move_chair()


func _tablet_opened() -> void:
	player.go_puppet()
	SignalBus.tablet_opened.emit()


func _tablet_closed() -> void:
	player.go_controlled()
	living_room.make_closet_appear()


func _set_current_activable(new_activable: Activable) -> void:
	if current_activable == new_activable:
		return

	if current_activable != null:
		current_activable.stop_being_current()

	current_activable = new_activable


func _get_player_naked() -> void:
	#TODO: get player naked
	living_room.make_clothes_appear()
	player.get_naked()


func _put_on_clothes(cloth_name: String) -> void:
	living_room.make_cloth_disappear(cloth_name)
	player.put_some_clothes(cloth_name)


func _clothes_wronged() -> void:
	living_room.make_closet_disappear()
	living_room.destroy_clothes()
	_awaked("clothes")


func _clothes_righted() -> void:
	living_room.reset_closet()


func _awaked(awake_name: String) -> void:
	if !awakes[awake_name]:
		ui.add_progress(1)
		ui.awake()
		awakes[awake_name] = true


func _read_poster() -> void:
	player.say('"¿OGAC EM?" ¿Qué significa eso?')


func _sit_on_chair() -> void:
	player.sit_on_chair(living_room.get_marker_position("chairMarker"))
	living_room.sit_in_chair()


func _get_up_from_chair() -> void:
	player.get_up_from_chair()
	living_room.get_up_from_chair()


func _sit_on_mirror_chair() -> void:
	player.sit_on_mirror_chair(nolas.get_marker_position("chairMarker"))


func _read_mirror_poster() -> void:
	player.say("ME CAGO", 2)
	create_tween().tween_callback(func(): _awaked("poster")).set_delay(2)


func _sofa_lay_down() -> void:
	player.lay_down_on_sofa(living_room.get_layed_position())


func _sofa_lay_up() -> void:
	player.lay_up_from_sofa(living_room.get_up_position())


func _sofa_lay_up_wall() -> void:
	player.lay_up_from_sofa(living_room.get_wall_position(), true)


func _layed_down() -> void:
	living_room.switch_to_layed_mode()


func _layed_up() -> void:
	living_room.switch_to_up_mode()


func _stream_in() -> void:
	player.sit_to_stream(setup.get_stream_position())


func _stream_out() -> void:
	player.get_up_from_streaming()


func _stream_in_wrong() -> void:
	player.sit_to_stream_wrong(setup.get_stream_position_wrong())


func _stream_out_wrong() -> void:
	player.get_up_from_streaming_wrong()


func _streaming() -> void:
	setup.activate_stream_out_activable()


func _stopped_streaming() -> void:
	setup.activate_stream_in_activable()


func _streaming_wrong() -> void:
	setup.activate_stream_out_wrong_activable()
	_awaked("stream")


func _stopped_streaming_wrong() -> void:
	setup.activate_stream_in_wrong_activable()


func _touch_wall() -> void:
	player.say("Otia, una pared")
	create_tween().tween_callback(func(): setup.activate_touch_wall_activable()).set_delay(2)


func _up_wall() -> void:
	setup.switch_to_up_mode()
	player.set_up_walls(setup.get_walls_up_position())
	_awaked("wall")


func _exit_window() -> void:
	_awaked("window")


func _bilders_up() -> void:
	player.say("Subí la persiana")
	setup.allow_exit_window()
	setup.activate_blinders_down_activable()


func _blinders_down() -> void:
	player.say("Bajé la persiana")
	setup.forbid_exit_window()
	setup.activate_blinders_up_activable()


func _jump_down() -> void:
	player.penetrate(setup.get_penetration_position())
	setup.switch_to_normal_mode()
	_awaked("jump")


func _down_wall() -> void:
	player.set_down_wall(setup.get_walls_down_position())
	setup.switch_to_normal_mode()


func _move_chair() -> void:
	setup.move_chair()
	setup.activate_wrong_streams()
