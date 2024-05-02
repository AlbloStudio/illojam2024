extends Node

signal activable_activated(name: String, alternative: bool, initial_point: Node3D)
signal activable_activated_done(name: String)
signal current_activable_changed(new_activable: Activable)
signal remove_current_activable

signal clothes_wrong
signal clothes_right
signal cloth_put(name: String)

signal barrier_entered(barrier_name: String)
signal barrier_exited(barrier_name: String)

signal awaked(awake_name: String)

signal layed_down
signal layed_up

signal exited_window
signal entered_window

signal jumped_down

signal upped_wall
signal downed_wall

signal started

signal should_activate(new_activable: Activable)

signal paused

signal despierta
signal started_end
