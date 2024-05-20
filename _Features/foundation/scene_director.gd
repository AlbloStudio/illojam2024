extends Node

@export var pera: PackedScene
@export var discord_call: AudioStream
@export var noise_material: Material

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
@onready var ui := $UI as GameUI
@onready var audio := $Audio as Audios
@onready var scan := $Scan as ColorRect
@onready var action_controller := $ActionController as ActionController
@onready var awake_actions := $Awake as Awake
@onready var camera := $CameraGroup/Camera3D as Camera3D


func _ready():
	living_room.switch_context(living_room.none)
	player.collision_layer = 0
	player.global_position = living_room.get_marker_position("startMarker")
	player.lay_up_from_sofa_init(living_room.get_marker_position("upMarker"))

	SignalBus.activable_activated.connect(_activable_activated)
	SignalBus.current_activable_changed.connect(_set_current_activable)
	SignalBus.remove_current_activable.connect(_remove_current_activable)
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
	current_activable = living_room.get_tablet_activable()
	_activable_activated("TabletLivingRoom", false, player)


func _activable_activated(activable_name: String, alternative: bool, initial_point: Node3D) -> void:
	player.speech_bubble.stop_saying()

	if initial_point != null:
		action_controller.can_press = false
		await player.move_as_puppet(initial_point.global_position)
		action_controller.can_press = true

	match activable_name:
		"TabletLivingRoom":
			player.go_puppet()
			living_room.say_tablet(
				{
					"START_0": 7.0,
					"START_1": 13.0,
					"START_2": 17.5,
					"START_3": 20.5,
					"START_4": 24.5,
					"START_5": 29.5
				},
				"IlloIntroCompleta",
				{
					living_room.make_closet_appear: 16.0,
					nolas.make_closet_appear: 16.0,
					living_room.reactivate_tablet: 108.0,
					player.go_controlled: 26.0,
					living_room.reset_context: 28.0
				}
			)
		"TabletNolas":
			nolas.activate_tablet()

		"TabletSecret":
			setup.say_tablet(
				{"SECONDS_0": 5.0, "SECONDS_1": 9.0, "SECONDS_2": 14.0},
				"AcciónAlternativa",
				{setup.reactivate_tablet: 11.0}
			)

		"Get Naked":
			if alternative:
				player.dont_collide()
				await player.move_as_puppet(living_room.exit_marker.global_position)
				_secret_end()
			else:
				living_room.make_clothes_appear()
				player.get_naked()

		"Put on T-Shirt":
			if alternative:
				player.say("QUITADO", "QuitarseRopcaSinRopa")
			else:
				_put_on_clothes("tshirt")

		"Put on Pants":
			if alternative:
				player.say("QUITADO", "QuitarseRopcaSinRopa")
			else:
				_put_on_clothes("pants")

		"Put on Underwear":
			if alternative:
				player.say("QUITADO", "QuitarseRopcaSinRopa")
			else:
				_put_on_clothes("underwear")

		"ReadPoster":
			if alternative:
				player.say("CULITO", "ContemplarPoster")
			else:
				player.say("OGACEM", "OGACEM", 9)

		"Sit":
			if alternative:
				player.say(
					"TABURETE",
					"TabureteAlternativo",
					6.0,
					{func(): SignalBus.awaked.emit("talk"): 3.0}
				)
			else:
				player.sit_on_chair(living_room.get_marker_position("chairMarker"))
				living_room.sit_on_chair()

		"GetUp":
			if alternative:
				player.say("ZZZ", "ZZZSfx")
			else:
				player.get_up_from_chair()
				living_room.get_up_from_chair()

		"Tis":
			if alternative:
				player.say("ETERUBAT", "TabureteAlternativoInverso")
			else:
				player.sit_on_mirror_chair(nolas.get_marker_position("chairMarker"))

		"RetsopDear":
			if alternative:
				player.say("OTILUC", "ContemplarPosterInvertido")
			else:
				player.say(
					"ME_CAGO",
					"MeCago2",
					2.0,
					{func(): SignalBus.awaked.emit("poster"): 2.0, nolas.make_tablet_visible: 0.0}
				)

		"Lay down":
			if alternative:
				living_room.rotate_sofa()
			else:
				player.lay_down_on_sofa(living_room.get_marker_position("layMarker"))
				living_room.lay_down()

		"Lay down wall":
			if alternative:
				living_room.rotate_sofa()
			else:
				player.lay_down_on_sofa(living_room.get_marker_position("layMarker"), true)
				living_room.lay_down()

		"Lay up":
			if alternative:
				player.say("ZZZ", "ZZZSfx")
			else:
				player.lay_up_from_sofa(living_room.get_marker_position("upMarker"))
				living_room.lay_up()

		"Lay up wall":
			if alternative:
				player.say("ZZZ", "ZZZSfx")
			else:
				player.lay_up_from_sofa(living_room.get_marker_position("wallMarker"), true)
				living_room.lay_up(true)

		"StreamIn":
			if alternative:
				player.say("ARRIBA", "no puedo desde aqui arriba")
			else:
				player.sit_to_stream(setup.get_marker_position("StreamMarker"))
				setup.stream_in()

		"StreamOut":
			if alternative:
				player.say("ZZZ", "ZZZSfx")
			else:
				player.get_up_from_streaming()
				setup.stream_out()

		"StreamWrong":
			if alternative:
				player.say("ARRIBA", "no puedo desde aqui arriba")
			else:
				player.sit_to_stream_wrong(setup.get_marker_position("StreamWrongMarker"))
				setup.stream_wrong()

		"StreamOutWrong":
			if alternative:
				player.say("ZZZ", "ZZZSfx")
			else:
				player.get_up_from_streaming_wrong()
				setup.stream_out_wrong()

		"TouchWall":
			if alternative:
				player.set_up_walls(
					setup.get_marker_position("WallsUpMarker"),
					func(): setup.switch_to_upwall_context()
				)
				setup.switch_to_normal_context()
			else:
				player.say("PARED", "HostiaUnaPared")

		"Exit Window":
			if alternative:
				player.say("VENTANA_FUERA", "AsomarsePorLaVentana")
			else:
				if setup.exit_window_activable.forbidden:
					player.exit_window()
					setup.show_secret_room()
				else:
					player.say("VENTANA_ABIERTA", "NiDeCoñaSalgo")

		"Enter Window":
			if alternative:
				player.say("VENTANA_DENTRO", "AsomarseDesdeFuera")
			else:
				player.enter_window()
				setup.hide_secret_room()

		"Blinders Up":
			if alternative:
				player.say("CORDELILLO", "cordelillopersianaDialogo", 7)
			else:
				setup.blinders_up()

		"Blinders Down":
			if alternative:
				player.say("CORDELILLO", "cordelillopersianaDialogo")
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
				player.say("NOTHING", " ")
			else:
				setup.move_chair()

	SignalBus.activable_activated_done.emit(activable_name)


func _set_current_activable(new_activable: Activable) -> void:
	if current_activable == new_activable:
		return

	if current_activable != null:
		current_activable.stop_being_current()

	current_activable = new_activable
	action_controller.current_activable = new_activable


func _remove_current_activable() -> void:
	current_activable.progress_audio.stop()

	current_activable = null
	action_controller.current_activable = null


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
	create_tween().tween_callback(func(): player.say("ESPEJO", "")).set_delay(3)


func _clothes_righted() -> void:
	living_room.reset_closet()
	player.say("ORDEN", "")


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
			awake_actions.start_visibility_distorsion(
				setup.get_stuff_to_disappear, Vector2(5, 30), Vector2(0.1, 10), 2.0
			)
		"jump":
			awake_actions.spawn_something(pera, camera, 2.0)
		"stream":
			awake_actions.start_visibility_distorsion(
				setup.glitched_streaming, Vector2.ZERO, Vector2.ZERO, 1.0
			)
		"window":
			var ceiling_nodes := living_room.ceiling_nodes
			awake_actions.start_transform_distorsion(
				ceiling_nodes,
				Vector3.UP * 3.0,
				Vector3.RIGHT * 180.0,
				Vector2(INF, INF),
				Vector2.ZERO,
				3.0
			)
		"clothes":
			awake_actions.start_material_distorsion(
				living_room.noise_nodes,
				noise_material,
				Vector2(1.0, 10.0),
				Vector2(10.0, 25.0),
				3.3
			)
		"poster":
			living_room.awake_poster()
		"sit":
			awake_actions.turn_off_lights(nolas.mirror_effect)
		"rotation":
			awake_actions.start_visibility_distorsion(
				[living_room.scary_hoodie], Vector2.ZERO, Vector2.ZERO, 3.2
			)


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
	living_room.switch_context(living_room.none)

	player.say("DESPERTE", "porfinmedesperte")
	await get_tree().create_timer(4.5).timeout
	ui.show_mierda()
	ui.hide_ui()
	audio.stop()
	player.go_puppet()
	await get_tree().create_timer(1.7).timeout
	ui.hide_mierda()
	ui.start_video()

func _secret_end() -> void:
	ui.hide_ui()
	audio.stop()
	ui.start_video()