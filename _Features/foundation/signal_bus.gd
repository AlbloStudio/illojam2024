extends Node

signal activable_activated(name: String)
signal current_activable_changed(new_activable: Activable)

signal tablet_opened
signal tablet_closed

signal clothes_wrong
signal clothes_right
signal cloth_put(name: String)

signal awaked

signal barrier_entered(barrier_name: String)
signal barrier_exited(barrier_name: String)
