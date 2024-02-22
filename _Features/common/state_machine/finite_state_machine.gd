class_name FiniteStateMachine extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var current_state: FiniteState = get_node(initial_state)


func _ready() -> void:
	await owner.ready

	for child: FiniteState in get_children():
		child.state_machine = self

	current_state.enter()


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	current_state.exit()
	current_state = get_node(target_state_name)
	current_state.enter(msg)
	transitioned.emit(current_state.name)


func is_in_state(state_names: Array[String]) -> bool:
	return state_names.has(current_state.name)
