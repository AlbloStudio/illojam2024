extends Node3D

@onready var entry := $Entry as Area3D
@onready var exit := $Exit as Area3D


func _on_entry_body_entered(body: Node3D) -> void:
	if body is Player:
		switch_to_exit.call_deferred()
		SignalBus.barrier_entered.emit(name)


func _on_exit_body_exited(body: Node3D) -> void:
	if body is Player:
		switch_to_enter.call_deferred()
		SignalBus.barrier_exited.emit(name)


func switch_to_exit() -> void:
	entry.process_mode = Node.PROCESS_MODE_DISABLED
	exit.process_mode = Node.PROCESS_MODE_INHERIT


func switch_to_enter() -> void:
	entry.process_mode = Node.PROCESS_MODE_INHERIT
	exit.process_mode = Node.PROCESS_MODE_DISABLED
