class_name LivingRoom extends Node3D

@onready var closet = $Closet as MeshInstance3D
@onready var closet_activable = $Closet/Activable as Activable

@onready var clothes = $Closet/Clothes as Node3D


func _ready() -> void:
	closet.visible = false
	clothes.visible = false


func make_closet_appear() -> void:
	closet.visible = true
	closet_activable.state_machine.transition_to(closet_activable.state_idle.name)


func make_closet_disappear() -> void:
	closet.visible = false
	closet_activable.state_machine.transition_to(closet_activable.state_deactivated.name)


func reset_closet() -> void:
	for cloth in ["underwear", "pants", "tshirt"]:
		var cloth_activable = get_node("Closet/Clothes/" + cloth) as Node3D
		cloth_activable.visible = true
	clothes.visible = false
	closet_activable.reactivate()


func make_clothes_appear() -> void:
	print("yeah appear them")
	clothes.visible = true

	for cloth in ["underwear", "pants", "tshirt"]:
		var cloth_activable = get_node("Closet/Clothes/" + cloth + "/Activable") as Activable
		cloth_activable.state_machine.transition_to(cloth_activable.state_idle.name)


func make_cloth_disappear(cloth_name: String) -> void:
	get_node("Closet/Clothes/" + cloth_name).visible = false

	var clothe_activable = get_node("Closet/Clothes/" + cloth_name + "/Activable") as Activable
	clothe_activable.state_machine.transition_to(clothe_activable.state_deactivated.name)
