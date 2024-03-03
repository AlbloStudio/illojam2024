extends Node

var current_activable: Activable = null

@onready var player := $Player as Player
@onready var living_room := $Stage/LivingRoom/LivingRoom as LivingRoom


func _ready():
	SignalBus.tablet_closed.connect(_tablet_closed)
	SignalBus.activable_activated.connect(_activable_activated)
	SignalBus.current_activable_changed.connect(_set_current_activable)
	SignalBus.clothes_wrong.connect(_clothes_wronged)
	SignalBus.clothes_right.connect(_clothes_righted)


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


func _clothes_righted() -> void:
	living_room.reset_closet()
