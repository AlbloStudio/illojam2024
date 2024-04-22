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
	"talk": false,
	"sofa": false,
	"rotation": false,
}

@onready var player := $Player as Player
@onready var living_room := $Stage/LivingRoom/LivingRoom as LivingRoom
@onready var nolas := $Stage/MoorGnivil/Nolas as Nolas
@onready var setup := $Stage/Setup/setup as Setup
@onready var tablet_living_room := $Stage/LivingRoom/TabletLivingRoom as Tablet
@onready var tablet_secret := $Stage/Setup/TabletSecret as Tablet
@onready var ui := $UI as GameUI
@onready var audio := $Audio as Audios
@onready var scan := $Scan as ColorRect


func _ready():
	# player.collision_layer = 0
	# player.global_position = living_room.get_marker_position("startMarker")
	# player.lay_up_from_sofa_init(living_room.get_marker_position("upMarker"))

	SignalBus.activable_activated.connect(_activable_activated)
	SignalBus.current_activable_changed.connect(_set_current_activable)
	SignalBus.clothes_wrong.connect(_clothes_wronged)
	SignalBus.clothes_right.connect(_clothes_righted)
	SignalBus.awaked.connect(_awaked)
	SignalBus.layed_down.connect(_layed_down)
	SignalBus.layed_up.connect(_layed_up)
	SignalBus.exited_window.connect(_exited_window)
	SignalBus.entered_window.connect(_entered_window)
	SignalBus.jumped_down.connect(_jumped_down)
	SignalBus.upped_wall.connect(_upped_wall)
	SignalBus.started.connect(_started)
	SignalBus.should_activate.connect(_should_activate)
	SignalBus.despierta.connect(_despierta)
	SignalBus.started_end.connect(_started_end)

	ui.set_total_progress(awakes.size())


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		SignalBus.paused.emit()


func _started() -> void:
	player.collision_layer = 1
	_activable_activated("TabletLivingRoom", false, player)


func _activable_activated(activable_name: String, alternative: bool, initial_point: Node3D) -> void:
	if current_activable == null || current_activable.activable_name != activable_name:
		return

	if initial_point != null:
		player.go_puppet()
		await player.set_target(initial_point.global_position)

	match activable_name:
		"TabletLivingRoom":
			player.go_puppet()
			(
				tablet_living_room
				. say(
					[
						"Hola, soy LMDSHOW... Estás atrapado en un sueño. Lo sé, rarete, no? Pero quiero ayudarte.",
						"La clave para despertar es hacer cosas inusuales e ilógicas, cosas que no harías en la vida real.",
						"Y... por dónde empezar? Tal vez, ese.... ese armario.",
						"Y... en qué orden te vistes todos los días?",
						"Espero que esto te guíe hacia la luz de la realidad. AIIIPS",
						"(Pulsa E o Espacio para ejecutar una acción, y ESC o Enter para el menú de volumen)"
					],
					"IlloIntroCompleta",
					[
						7.0,
						6.0,
						4.5,
						3.0,
						4.0,
						5.0,
					]
				)
			)

			create_tween().tween_callback(living_room.make_closet_appear).set_delay(16.0)
			create_tween().tween_callback(nolas.make_closet_appear).set_delay(16.0)
			create_tween().tween_callback(tablet_living_room.activate).set_delay(108.0)
			create_tween().tween_callback(player.go_controlled).set_delay(26.0)

		"TabletNolas":
			nolas.activate_tablet()

		"TabletSecret":
			tablet_secret.say(
				[
					"Deja pulsado durante 3 segundos sobre una acción y...",
					"Cambiarás a una acción alternativa.",
					"Deja pulsado durante 3 segundos otra vez y volverás a la acción original."
				],
				"AcciónAlternativa",
				[5.0, 4.0, 5.0]
			)
			create_tween().tween_callback(tablet_living_room.activate).set_delay(11.0)

		"Get Naked":
			if alternative:
				player.exit_dream(living_room.get_marker_position("exitDreamMarker"))
			else:
				living_room.make_clothes_appear()
				player.get_naked()

		"Put on T-Shirt":
			if alternative:
				player.say(
					"No me puedo quitar lo que ya me he quitado... espabila.",
					"QuitarseRopcaSinRopa"
				)
			else:
				_put_on_clothes("tshirt")

		"Put on Pants":
			if alternative:
				player.say(
					"No me puedo quitar lo que ya me he quitado... espabila.",
					"QuitarseRopcaSinRopa"
				)
			else:
				_put_on_clothes("pants")

		"Put on Underwear":
			if alternative:
				player.say(
					"No me puedo quitar lo que ya me he quitado... espabila.",
					"QuitarseRopcaSinRopa"
				)
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
			else:
				(
					player
					. say(
						'"OGAC EM?" Qué cojones es eso? desde cuándo tengo yo este poster aquí? parece escrito como si estuviera mirando un espejo.',
						"OGACEM",
						9
					)
				)

		"Sit":
			if alternative:
				player.say("Qué pasa, taburete? TABURRES?", "TabureteAlternativo")
				create_tween().tween_callback(func(): _awaked("talk")).set_delay(3.0)
			else:
				player.sit_on_chair(living_room.get_marker_position("chairMarker"))

		"GetUp":
			if alternative:
				player.say("ZZzzzZzZZzZ", "ZZZSfx")
			else:
				player.get_up_from_chair()

		"Tis":
			if alternative:
				player.say("?SERRUBAT ?etrubat ,asap euQ", "TabureteAlternativoInverso")
			else:
				player.sit_on_mirror_chair(nolas.get_marker_position("chairMarker"))

		"RetsopDear":
			if alternative:
				(
					player
					. say(
						"oticuluc ayav ...on is ,oluc le ev em es on euqrop Y .retsoP le ne ev em es apuog euq ,onamreh ,soiD",
						"ContemplarPosterInvertido"
					)
				)
			else:
				player.say("ME CAGO", "MeCago2", 2)
				create_tween().tween_callback(func(): _awaked("poster")).set_delay(2)
				nolas.make_tablet_visible()
		"Lay down":
			if alternative:
				living_room.rotate_sofa()
			else:
				player.lay_down_on_sofa(living_room.get_marker_position("layMarker"))
				living_room.switch_to_none_mode()

		"Lay down wall":
			if alternative:
				living_room.rotate_sofa()
			else:
				player.lay_down_on_sofa(living_room.get_marker_position("layMarker"), true)
				living_room.switch_to_none_mode()

		"Lay up":
			if alternative:
				player.say("ZZzzzZzZZzZ", "ZZZSfx")
			else:
				player.lay_up_from_sofa(living_room.get_marker_position("upMarker"))
				living_room.switch_to_none_mode()

		"Lay up wall":
			if alternative:
				player.say("ZZzzzZzZZzZ", "ZZZSfx")
			else:
				player.lay_up_from_sofa(living_room.get_marker_position("wallMarker"), true)
				living_room.switch_to_none_mode()

		"StreamIn":
			if alternative:
				player.say(
					"No puedo desde aquí arriba, por alguna razón...", "no puedo desde aqui arriba"
				)
			else:
				player.sit_to_stream(setup.get_marker_position("StreamMarker"))

		"StreamOut":
			if alternative:
				player.say("ZZzzzZzZZzZ", "ZZZSfx")
			else:
				player.get_up_from_streaming()

		"StreamWrong":
			if alternative:
				player.say(
					"No puedo desde aquí arriba, por alguna razón...", "no puedo desde aqui arriba"
				)
			else:
				player.sit_to_stream_wrong(setup.get_marker_position("StreamWrongMarker"))

		"StreamOutWrong":
			if alternative:
				player.say("ZZzzzZzZZzZ", "ZZZSfx")
			else:
				player.get_up_from_streaming_wrong()

		"TouchWall":
			if alternative:
				player.set_up_walls(
					setup.get_marker_position("WallsUpMarker"),
					func(): setup.switch_to_upwall_context()
				)
				setup.switch_to_normal_context()
			else:
				player.say("Otia, una pared", "HostiaUnaPared")

		"Exit Window":
			if alternative:
				(
					player
					. say(
						"Hostia.... eso que se ve desde aquí es rarísimo. La gente tira cualquier porquería al suelo",
						"AsomarsePorLaVentana"
					)
				)
			else:
				if setup.exit_window_activable.forbidden:
					player.exit_window()
					setup.show_secret_room()
				else:
					player.say("Ni de coña salgo por una ventana abierta.", "NiDeCoñaSalgo")

		"Enter Window":
			if alternative:
				player.say("MI CASA ILLO", "AsomarseDesdeFuera")
			else:
				player.enter_window()

		"Blinders Up":
			if alternative:
				(
					player
					. say(
						"Que hace aquí el cordelillo de bajar la persiana? Por la cara. Y la músia tétrica esta? Hermano, cabeza fría, te lo juro",
						"cordelillopersianaDialogo",
						7
					)
				)
			else:
				setup.blinders_up()

		"Blinders Down":
			if alternative:
				(
					player
					. say(
						"Que hace aquí el cordelillo de bajar la persiana? Por la cara. Y la músia tétrica esta? Hermano, cabeza fría, te lo juro",
						"cordelillopersianaDialogo"
					)
				)
			else:
				setup.blinders_down()

		"Jump Down":
			if alternative:
				player.penetrate(setup.get_marker_position("PenetrationMarker"))
				setup.switch_to_normal_context()
			else:
				player.set_down_wall(
					setup.get_marker_position("WallsDownMarker"),
					func(): setup.switch_to_normal_context()
				)

		"Move Chair":
			if alternative:
				player.say("...", " ")
			else:
				setup.move_chair()

	SignalBus.activable_activated_done.emit(activable_name)


func _set_current_activable(new_activable: Activable) -> void:
	if current_activable == new_activable:
		return

	if current_activable != null:
		current_activable.stop_being_current()

	current_activable = new_activable


func _should_activate(activable: Activable) -> void:
	if activable.name == current_activable.name:
		activable.state_machine.transition_to(activable.state_activated.name)


func _put_on_clothes(cloth_name: String) -> void:
	living_room.make_cloth_disappear(cloth_name)
	player.put_some_clothes(cloth_name)


func _clothes_wronged() -> void:
	nolas.make_closet_disappear()
	living_room.make_closet_disappear()
	living_room.destroy_clothes()
	SignalBus.awaked.emit("clothes")
	(
		create_tween()
		. tween_callback(
			func(): player.say("Y ese espejo? no me veo reflejado, por la cara...", "")
		)
		. set_delay(3)
	)


func _clothes_righted() -> void:
	living_room.reset_closet()
	player.say("Ese es el orden en el que me visto todos los días...", "")


func _awaked(awake_name: String) -> void:
	if awakes[awake_name]:
		return

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


func _layed_down() -> void:
	living_room.switch_to_layed_mode()


func _layed_up() -> void:
	living_room.switch_to_up_mode()


func _entered_window() -> void:
	setup.hide_secret_room()


func _exited_window() -> void:
	setup.enable_activable("EnterWindowActivable")
	SignalBus.awaked.emit("window")


func _upped_wall() -> void:
	SignalBus.awaked.emit("wall")


func _jumped_down() -> void:
	setup.switch_to_penerated_context()


func _on_button_pressed() -> void:
	get_tree().quit()


func _despierta() -> void:
	player.collision_layer = 0
	player.stop_talking()
	player.global_position = living_room.get_marker_position("startMarker")
	player.lay_up_from_sofa_end(living_room.get_marker_position("layInitMarker"))
	audio.restart()

	var scan_material := scan.material as ShaderMaterial
	scan_material.set_shader_parameter("overall_effect", 0.0)
	scan_material.set_shader_parameter("pallete_effect", 0.0)
	scan_material.set_shader_parameter("scan_brightness", 1.0)


func _started_end() -> void:
	player.say("Uf, por fin. Me desperté. Me desperté? %*%*(@#", "porfinmedesperte")
	await get_tree().create_timer(4.5).timeout
	ui.show_mierda()
	ui.hide_ui()
	audio.stop()
	player.go_puppet()
	await get_tree().create_timer(1.7).timeout
	ui.hide_mierda()
	ui.start_video()
