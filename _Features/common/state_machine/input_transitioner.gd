class_name InputTransitioner

var action_name: StringName
var transition_to: StringName


func _init(transitioner_action_name: StringName, transition_transition_to: StringName) -> void:
	action_name = transitioner_action_name
	transition_to = transition_transition_to
