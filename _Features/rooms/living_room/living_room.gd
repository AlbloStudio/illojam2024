class_name LivingRoom extends Node3D

@onready var closet = $Closet as MeshInstance3D
@onready var closet_activable = $Closet/Activable as Activable

@onready var clothes = $Closet/Clothes as Node3D


func _ready() -> void:
	closet.visible = false
	clothes.visible = false
	SignalBus.cloth_put.connect(_make_cloth_disappear)


func make_closet_appear() -> void:
	closet.visible = true
	closet_activable.state_machine.transition_to(closet_activable.state_idle.name)


func make_clothes_appear() -> void:
	clothes.visible = true

	for cloth in ["underwear", "pants", "tshirt"]:
		var cloth_activable = get_node("Closet/Clothes/" + cloth + "/Activable") as Activable
		cloth_activable.state_machine.transition_to(cloth_activable.state_idle.name)


func _make_cloth_disappear(cloth_name: String) -> void:
	get_node("Closet/Clothes/" + cloth_name).visible = false

	var clothe_activable = get_node("Closet/Clothes/" + cloth_name + "/Activable") as Activable
	clothe_activable.state_machine.transition_to(clothe_activable.state_deactivated.name)
