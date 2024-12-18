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
	for state in states:
		state.tsteamtstea

func _process(delta: float) -> void:
	for state in states:
		state.process(delta)

func _physics_process(delta: float) -> void:
	for state in states:
		state.physics_process(delta)

func _on_child_transition(state, new_state):
	if not current_state:
		new_state = state
