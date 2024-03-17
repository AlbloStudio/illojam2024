extends Node

@export var discord_call: AudioStream

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
@onready var tablet_living_room := $Stage/LivingRoom/TabletLivingRoom as Tablet
@onready var tablet_nolas := $Stage/MoorGnivil/TabletNolas as Tablet
@onready var tablet_secret := $Stage/Setup/TabletSecret as Tablet
@onready var ui := $UI as GameUI
@onready var audio := $Audio as Audio
@onready var scan := $Scan as ColorRect


func _ready():
	# player.global_position = living_room.get_start_position()
	# player.lay_up_from_sofa_init(living_room.get_up_init_position())

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
	SignalBus.exited_window.connect(_exited_window)
	SignalBus.entered_window.connect(_entered_window)
	SignalBus.jumped_down.connect(_jumped_down)
	SignalBus.upped_wall.connect(_upped_wall)
	SignalBus.downed_wall.connect(_downed_wall)
	SignalBus.started.connect(_started)
	SignalBus.should_activate.connect(_should_activate)


func _started() -> void:
	player.collision_layer = 1


func _activable_activated(activable_name: String, alternative: bool) -> void:
	if current_activable == null || current_activable.activable_name != activable_name:
		return

	match activable_name:
		"TabletLivingRoom":
			_tablet_living_room_opened()
		"TabletNolas":
			_tablet_nolas_opened()
		"TabletSecret":
			_tablet_secret_opened()
		"Get Naked":
			if alternative:
				player.exit_dream(living_room.get_marker_position("exitDreamMarker"))
			else:
				_get_player_naked()
		"Put on T-Shirt":
			if alternative:
				player.say(
					"No me puedo quitar lo que ya me he quitado... espabila.",
					"QuitarseRopcaSinRopa"
				)
				living_room.activate_clothe("tshirt", 2.0)
			else:
				_put_on_clothes("tshirt")
		"Put on Pants":
			if alternative:
				player.say(
					"No me puedo quitar lo que ya me he quitado... espabila.",
					"QuitarseRopcaSinRopa"
				)
				living_room.activate_clothe("pants", 2.0)
			else:
				_put_on_clothes("pants")
		"Put on Underwear":
			if alternative:
				player.say(
					"No me puedo quitar lo que ya me he quitado... espabila.",
					"QuitarseRopcaSinRopa"
				)
				living_room.activate_clothe("underwear", 2.0)
			else:
				_put_on_clothes("underwear")
		"ReadPoster":
			if alternative:
				(
					player
					. say(
						"Dios, hermano, qué guapo se me ve en el poster. Y porque no se me ve el culo, si no... vaya culito",
						"ContemplarPoster"
					)
				)
				living_room.activate_activable("PosterActivable", 2.0)
			else:
				_read_poster()
				living_room.activate_activable("PosterActivable", 2.0)
		"Sit":
			if alternative:
				player.say("Qué pasa, taburte? TABURRES?", "TabureteAlternativo")
			else:
				_sit_on_chair()
		"GetUp":
			if alternative:
				player.say("ZZzzzZzZZzZ", "")
				living_room.activate_activable("ChairActivableGetUp", 2.0)
			else:
				_get_up_from_chair()
		"Tis":
			if alternative:
				player.say("?SERRUBAT ?etrubat ,asap euQ", "TabureteAlternativo")
				nolas.activate_activable("ChairActivableSit", 2.0)
			else:
				_sit_on_mirror_chair()
		"RetsopDear":
			if alternative:
				(
					player
					. say(
						"oticuluc ayav ...on is ,oluc le ev em es on euqrop Y .retsoP le ne ev em es apuog euq ,onamreh ,soiD",
						"ContemplarPoster"
					)
				)
				nolas.activate_activable("PosterActivable", 2.0)
			else:
				_read_mirror_poster()
		"Lay down":
			if alternative:
				living_room.activate_activable("SofaActivableLayDown", 2.0)
			else:
				_sofa_lay_down()
		"Lay down wall":
			if alternative:
				living_room.activate_activable("SofaActivableLayDownWall", 2.0)
			else:
				_sofa_lay_down_wall()
		"Lay up":
			if alternative:
				player.say("ZZzzzZzZZzZ", "")
				living_room.activate_activable("SofaActivableLayUp", 2.0)
			else:
				_sofa_lay_up()
		"Lay up wall":
			if alternative:
				player.say("ZZzzzZzZZzZ", "")
				living_room.activate_activable("SofaActivableLayUpWall", 2.0)
			else:
				_sofa_lay_up_wall()
		"StreamIn":
			if alternative:
				player.say(
					"No puedo desede aquí arriba, por alguna razón...", "no puedo desde aqui arriba"
				)
				setup.activate_activable("StreamInActivable", 2.0)
			else:
				_stream_in()
		"StreamOut":
			if alternative:
				player.say("ZZzzzZzZZzZ", "")
				setup.activate_activable("StreamOutActivable", 2.0)
			else:
				_stream_out()
		"StreamWrong":
			if alternative:
				player.say(
					"No puedo desede aquí arriba, por alguna razón...", "no puedo desde aqui arriba"
				)
				setup.activate_activable("StreamInIncorrectActivable", 2.0)
			else:
				_stream_in_wrong()
		"StreamOutWrong":
			if alternative:
				player.say("ZZzzzZzZZzZ", "")
				setup.activate_activable("StreamOutInCorrectActivable", 2.0)
			else:
				_stream_out_wrong()
		"TouchWall":
			if alternative:
				_up_wall()
			else:
				_touch_wall()
		"Exit Window":
			if alternative:
				(
					player
					. say(
						"Hostia.... eso que se ve desde aquí es rarísimo. La gente tira cualquier porquería al suelo",
						"AsomarsePorLaVentana"
					)
				)
				setup.activate_activable("ExitWindowActivable", 2.0)
			else:
				_exit_window()
		"Enter Window":
			if alternative:
				player.say("MI CASA ILLO", "AsomarseDesdeFuera")
				setup.activate_activable("EnterWindowActivable", 2.0)
			else:
				_enter_window()
		"Blinders Up":
			if alternative:
				(
					player
					. say(
						"Que hace aquí el cordelillo de bajar la persiana? Por la cara. Y la músia tétrica esta? Hermano, cabeza fría, te lo juro",
						"cordelillopersianaDialogo"
					)
				)
				setup.activate_activable("BlindersUpActivable", 2.0)
			else:
				_bilders_up()
		"Blinders Down":
			if alternative:
				(
					player
					. say(
						"Que hace aquí el cordelillo de bajar la persiana? Por la cara. Y la músia tétrica esta? Hermano, cabeza fría, te lo juro",
						"cordelillopersianaDialogo"
					)
				)
				setup.activate_activable("BlindersDownActivable", 2.0)
			else:
				_blinders_down()
		"Jump Down":
			if alternative:
				_jump_down()
			else:
				_down_wall()
		"Move Chair":
			if alternative:
				player.say("...", " ")
				setup.activate_penetrated_activable("MoveChairActivable", 2.0)
			else:
				_move_chair()


func _tablet_living_room_opened() -> void:
	(
		tablet_living_room
		. say(
			[
				"Hola, soy LMDSHOW... Estás atrapado en un sueño. Lo sé, rarete. Pero quiero ayudarte.",
				"En la vida real hay normas, leyes, principios que nos gobiernan. En los sueños, todo eso se desmorona. Sigo?",
				"La clave para despertar es hacer cosas inusuales e ilógicas, cosas que no harías en la vida real.",
				"Y... por dónde empezar? Tal vez, ese.... ese armario. Sí, el armario.",
				"En los sueños, lo ordinario puede convertirse en extraordinario.",
				"Adelante, es solo un paso. Espero que esto te guíe hacia la luz de la realidad. AIIIPS"
			],
			[
				4.0,
				4.0,
				4.0,
				4.0,
				4.0,
				4.0,
			]
		)
	)
	create_tween().tween_callback(living_room.make_closet_appear).set_delay(12.0)
	create_tween().tween_callback(nolas.make_closet_appear).set_delay(12.0)
	create_tween().tween_callback(tablet_living_room.activate).set_delay(26.0)


func _tablet_nolas_opened() -> void:
	(
		tablet_nolas
		. say(
			[
				"Has visto que hay acciones deshabilitadas, o prohibidas?",
				"Dale 5 veces... y las forzarás."
			],
			[
				4.0,
				6.0,
			]
		)
	)
	create_tween().tween_callback(tablet_living_room.activate).set_delay(12.0)


func _tablet_secret_opened() -> void:
	tablet_secret.say(
		[
			"Deja pulsado durante 3 segundos sobre una acción y...",
			"Podrás hacer una acción alternativa."
		],
		[5.0, 4.0]
	)
	create_tween().tween_callback(tablet_living_room.activate).set_delay(11.0)


func _set_current_activable(new_activable: Activable) -> void:
	print("setting as current " + new_activable.name)
	if current_activable == new_activable:
		return

	if current_activable != null:
		current_activable.stop_being_current()

	current_activable = new_activable


func _should_activate(activable: Activable) -> void:
	if activable.name == current_activable.name:
		activable.state_machine.transition_to(activable.state_activated.name)


func _get_player_naked() -> void:
	#TODO: get player naked
	living_room.make_clothes_appear()
	player.get_naked()


func _put_on_clothes(cloth_name: String) -> void:
	living_room.make_cloth_disappear(cloth_name)
	player.put_some_clothes(cloth_name)


func _clothes_wronged() -> void:
	nolas.make_closet_disappear()
	living_room.make_closet_disappear()
	living_room.destroy_clothes()
	SignalBus.awaked.emit("clothes")


func _clothes_righted() -> void:
	living_room.reset_closet()


func _awaked(awake_name: String) -> void:
	if !awakes[awake_name]:
		ui.add_progress(1)
		ui.awake()
		awakes[awake_name] = true
		audio.advance_level(awake_name)

	var scan_material := scan.material as ShaderMaterial
	var overall_effect = scan_material.get_shader_parameter("overall_effect")
	var pallete_effect = scan_material.get_shader_parameter("pallete_effect")
	var scan_brightness = scan_material.get_shader_parameter("scan_brightness")

	scan_material.set_shader_parameter("overall_effect", overall_effect + 0.1)
	scan_material.set_shader_parameter("pallete_effect", pallete_effect + 0.1)
	scan_material.set_shader_parameter("scan_brightness", scan_brightness - 0.012)

	match awake_name:
		"wall":
			setup.awake_wall()
		"jump":
			setup.awake_jump()
		"stream":
			setup.awake_stream()
		"window":
			setup.awake_window()
		"clothes":
			living_room.awake_clothes()
		"poster":
			living_room.awake_poster()
		"sit":
			living_room.awake_sit()
		"sofa":
			living_room.awake_sofa()


func _read_poster() -> void:
	player.say('"¿OGAC EM?" ¿Qué significa eso?', "OGACEM")


func _sit_on_chair() -> void:
	player.sit_on_chair(living_room.get_marker_position("chairMarker"))
	living_room.sit_in_chair()


func _get_up_from_chair() -> void:
	player.get_up_from_chair()
	living_room.get_up_from_chair()


func _sit_on_mirror_chair() -> void:
	player.sit_on_mirror_chair(nolas.get_marker_position("chairMarker"))


func _read_mirror_poster() -> void:
	player.say("ME CAGO", "MeCago2", 2)
	create_tween().tween_callback(func(): _awaked("poster")).set_delay(2)
	tablet_nolas.visible = true


func _sofa_lay_down() -> void:
	player.lay_down_on_sofa(living_room.get_layed_position())
	living_room.switch_to_none_mode()


func _sofa_lay_down_wall() -> void:
	player.lay_down_on_sofa(living_room.get_layed_position(), true)
	living_room.switch_to_none_mode()


func _sofa_lay_up() -> void:
	player.lay_up_from_sofa(living_room.get_up_position())
	living_room.switch_to_none_mode()


func _sofa_lay_up_wall() -> void:
	player.lay_up_from_sofa(living_room.get_wall_position(), true)
	living_room.switch_to_none_mode()


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
	SignalBus.awaked.emit("stream")


func _stopped_streaming_wrong() -> void:
	setup.activate_stream_in_wrong_activable()


func _touch_wall() -> void:
	player.say("Otia, una pared", "HostiaUnaPared")
	create_tween().tween_callback(func(): setup.activate_touch_wall_activable()).set_delay(2)


func _exit_window() -> void:
	if setup.exit_window_activable.forbidden:
		player.exit_window()
		setup.show_secret_room()
	else:
		player.exit_window()
		player.global_position = living_room.get_start_position()
		create_tween().tween_callback(func(): setup.activate_exit_window_activable()).set_delay(1)


func _enter_window() -> void:
	player.enter_window()


func _entered_window() -> void:
	setup.activate_exit_window_activable()
	setup.hide_secret_room()


func _exited_window() -> void:
	setup.activate_enter_window_activable()
	SignalBus.awaked.emit("window")


func _bilders_up() -> void:
	setup.blinders_up()
	setup.allow_exit_window()
	create_tween().tween_callback(func(): setup.activate_blinders_down_activable()).set_delay(2.0)


func _blinders_down() -> void:
	setup.blinders_down()
	setup.forbid_exit_window()
	create_tween().tween_callback(func(): setup.activate_blinders_up_activable()).set_delay(2.0)


func _up_wall() -> void:
	player.set_up_walls(setup.get_walls_up_position(), func(): setup.switch_to_up_mode())
	setup.switch_to_normal()


func _upped_wall() -> void:
	SignalBus.awaked.emit("wall")


func _jump_down() -> void:
	player.penetrate(setup.get_penetration_position())
	setup.switch_to_normal_mode()


func _jumped_down() -> void:
	setup.switch_to_penetration()


func _down_wall() -> void:
	player.set_down_wall(setup.get_walls_down_position(), func(): setup.switch_to_normal_mode())


func _downed_wall() -> void:
	pass


func _move_chair() -> void:
	setup.move_chair()
	setup.activate_wrong_streams()
