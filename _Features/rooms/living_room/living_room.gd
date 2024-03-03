class_name LivingRoom extends Node3D

var cloth_names := ["underwear", "pants", "tshirt"]

@onready var closet := $Closet as MeshInstance3D
@onready var closet_collider := $Closet/StaticBody3D as StaticBody3D
@onready var closet_activable := $Closet/Activable as Activable

@onready var clothes := $Closet/Node/Clothes as Node3D


func _ready() -> void:
	closet.visible = false
	clothes.visible = false
	closet_collider.process_mode = Node.PROCESS_MODE_DISABLED


func make_closet_appear() -> void:
	closet.visible = true
	closet_collider.process_mode = Node.PROCESS_MODE_INHERIT
	closet_activable.state_machine.transition_to(closet_activable.state_idle.name)


func make_closet_disappear() -> void:
	closet.queue_free()


func reset_closet() -> void:
	for cloth_name in cloth_names:
		var cloth_activable = get_node(_clothes_path(cloth_name, false)) as Node3D
		cloth_activable.visible = true
	clothes.visible = false
	closet_activable.reactivate()


func make_clothes_appear() -> void:
	clothes.visible = true

	for cloth_name in cloth_names:
		var cloth_activable = get_node(_clothes_path(cloth_name)) as Activable
		cloth_activable.state_machine.transition_to(cloth_activable.state_idle.name)


func make_cloth_disappear(cloth_name: String) -> void:
	get_node(_clothes_path(cloth_name, false)).visible = false

	var clothe_activable = get_node(_clothes_path(cloth_name)) as Activable
	clothe_activable.state_machine.transition_to(clothe_activable.state_deactivated.name)


func destroy_clothes() -> void:
	clothes.queue_free()


func _clothes_path(cloth: String, with_activable := true) -> String:
	return "Closet/Node/Clothes/" + cloth + ("/Activable" if with_activable else "")
