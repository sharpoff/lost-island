extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(_on_child_transition)

func _enter_tree() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	for state in states:
		state.process(delta)

func _on_child_transition(state, new_state):
	pass
