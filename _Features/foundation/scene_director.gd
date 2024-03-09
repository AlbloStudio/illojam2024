extends Node

var current_activable: Activable = null

@onready var player := $Player as Player
@onready var living_room := $Stage/LivingRoom/LivingRoom as LivingRoom
@onready var ui := $UI as GameUI


func _ready():
	SignalBus.tablet_closed.connect(_tablet_closed)
	SignalBus.activable_activated.connect(_activable_activated)
	SignalBus.current_activable_changed.connect(_set_current_activable)
	SignalBus.clothes_wrong.connect(_clothes_wronged)
	SignalBus.clothes_right.connect(_clothes_righted)
	SignalBus.awaked.connect(_awaked)


func _activable_activated(activable_name: String) -> void:
	current_activable = null

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


func _tablet_opened() -> void:
	player.go_puppet()
	SignalBus.tablet_opened.emit()


func _tablet_closed() -> void:
	player.go_controlled()
	living_room.make_closet_appear()


func _set_current_activable(new_activable: Activable) -> void:
	if current_activable:
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
	SignalBus.awaked.emit()


func _clothes_righted() -> void:
	living_room.reset_closet()


func _awaked() -> void:
	ui.add_progress(1)
	ui.awake()


func _read_poster() -> void:
	player.say('"¿OGAC EM?" ¿Qué significa eso?')


func _sit_on_chair() -> void:
	player.sit_on_chair()
	living_room.sit_in_chair()


func _get_up_from_chair() -> void:
	player.get_up_from_chair()
	living_room.get_up_from_chair()


func _sit_on_mirror_chair() -> void:
	SignalBus.awaked.emit()


func _read_mirror_poster() -> void:
	player.say("ME CAGO", 2)
	create_tween().tween_callback(func(): SignalBus.awaked.emit()).set_delay(2)


func _sofa_lay_down() -> void:
	player.lay_down_on_sofa()
	player.global_position = living_room.get_layed_position()
	living_room.switch_to_layed_mode()


func _sofa_lay_up() -> void:
	player.global_position = living_room.get_up_position()
	_sofa_lay_up_generic()


func _sofa_lay_up_wall() -> void:
	player.global_position = living_room.get_wall_position()
	_sofa_lay_up_generic()


func _sofa_lay_up_generic() -> void:
	player.lay_up_from_sofa()
	living_room.switch_to_up_mode()
